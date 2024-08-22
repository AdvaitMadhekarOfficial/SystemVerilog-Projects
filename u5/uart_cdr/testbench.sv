// Code your testbench here
// or browse Examples
/* UART TRANSMITTER
 * Bus-Functional Model:
 * Serial RS-232 protocol.
 * Type:
 * Send string of ASCII characters.
 * File: UART_TB.sv
 * Path: UART/Sample_4-1/Part-C
 * Rate: 110 baud
 * Date: 07 Mar 2023
 */

module UART_TB();

//A message string of characters:
  parameter string MSG = "SAN DIEGO";

//Approximate time-slot at 110 bps:
  parameter realtime SLOT = 9.0ms;

//Serial TXD line:
  bit LINE = 1'b1; //Initially at idle.
  
  bit CLK_MID;
  
  bit CLK_x16 = 1'b1;

  CDR DUT(.CLK_MID(CLK_MID), .CLK_x16(CLK_x16), .RXD(LINE));

//Framed character objects:
  class FRAMER;

  //RS-232 frame, initially at idle:
    bit [10:0] FRAME = '1;
 
  //Transmit the input character:
    task XMIT(
      bit [6:0] CHAR = " " //Space: 7'h20.
    );
      int I = 0;

    //Compute even parity:
      bit PARITY;
      PARITY = ^CHAR;

    //Assemble and print frame:
      FRAME = {2'b11, PARITY, CHAR, 1'b0}; 
      $display(
        "\nCHAR \"%c\": %11b", CHAR, FRAME
      );
    //Shift out eleven bits, LSB first:
      do  //Put a bit out, then wait.
      begin:LOOP
        LINE = FRAME[I];
        $write("%0b-", LINE);
        #(SLOT) ++I;
      end:  LOOP
      while (I <= 10);
    //Skip line:
      $write("\n");
    //Arbitrary time gap:
      #(SLOT * $urandom_range(5));
    endtask: XMIT

  endclass: FRAMER

  initial
  begin:SUITE
    FRAMER F0;
    F0 = new();
  //Send message string:
    foreach (MSG[J])
    begin:TRANSMIT
      F0.XMIT(MSG[J]);
    end:  TRANSMIT
  end:  SUITE
  
  
  initial
    begin:CLOCKING
      localparam realtime Tosc = SLOT/16;
      repeat (2000) begin
        #(Tosc/2) CLK_x16 = 1'b0;
        #(Tosc/2) CLK_x16 = 1'b1;
      end
    end:  CLOCKING

endmodule: UART_TB

