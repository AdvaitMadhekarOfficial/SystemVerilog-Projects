// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples

/* UART TRANSMITTER
	* Bus-Functional Model:
    * Serial RS-232 protocol.
*/

//Unit-scope time scale:
timeunit 1ms;
timeprecision 1ms;

module UART_TB();
  //Approximate time-slot at 110 bps:
  parameter realtime SLOT = 9ms;
  
  //A message string of characters:
  parameter string MSG = "SAN DIEGO";

  //Serial TXD line:
  bit LINE = 1'b0; //Initially at idle.

  //Skeletal class:
  class FRAMER;

    //RS-232 frame, initially at idle:
    bit [10:0] FRAME = 11'b0;
    rand bit INJECT;
    
    constraint INJECT_CON{
      INJECT dist {
        1'b0 := 4, //80% of the time, error free
        1'b1 := 1  //20% of the time, error prone
      };
    }
    
    //Transmit the input character:
    task XMIT(
      bit [6:0] CHAR = " "  //Space: 7'h20.
    );
      
      int K;
      string RULER;
      
      int I = 0;
      //Compute even parity:
      bit PARITY;

      //PARITY BIT:
      //IF CHAR CONTAINS ODD # of 1s, PARITY = 1;
      //ELSE, PARITY = 0;
      int NUM_OF_ONES = 0;
      for(int j = 0; j < 7; j++)
        begin:CHECK_NUM_OF_ONES
          if(CHAR[j] == 1)
            NUM_OF_ONES += 1;
        end:CHECK_NUM_OF_ONES

      if(NUM_OF_ONES % 2 != 0)
        PARITY = 1;

      //Assemble and print frame:


      FRAME = {2'b11, PARITY, CHAR, 1'b0};
      
      //Inject one flipped bit:
      if (INJECT)
        begin:TOGGLE
          K = $urandom_range(8,1);
          FRAME[K] = ~FRAME[K]; //Flip.
          RULER = { {K{"  "}}, "^Err" };
        end:  TOGGLE

      
      $display(
        "\nCHAR \"%c\": %11b", CHAR, FRAME
      );

      //Shift out eleven bits, LSB first:
      do  //Put a bit out, then wait.
        begin:LOOP
          LINE = CHAR[I];
          $write("%0b-", LINE);
          #(99ms) ++I;
        end:  LOOP
      while (I < 7);
      //Skip line:
      //$write("\n");  
      if (INJECT)
        $write("\n%s", RULER);
      else
        $write("\n");
      #(SLOT * $urandom_range(5));
    endtask: XMIT

  endclass:FRAMER
  
  initial
    begin:SUITE
      FRAMER F0;
      F0 = new();
      //Send message string:
      foreach (MSG[J])
        begin:TRANSMIT
          F0.randomize();
          F0.XMIT(MSG[J]);
        end:  TRANSMIT
    end:  SUITE

endmodule: UART_TB
