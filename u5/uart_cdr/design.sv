/* UART CDR MODULE
 * Clock-data recovery
 * for RS-232 protocol.
 */
//Unit-scope items:
timeunit 1ms;
timeprecision 1us;

module CDR(
  output bit CLK_MID,
  input  bit CLK_x16, RXD
);
  //Last line level:
  bit RXD_OLD;
  
  //COUNT
  bit [3:0] COUNT;

  //Update last line level:
  always_ff @(posedge CLK_x16)
    RXD_OLD <= RXD;

    //Difference detected:
  bit DIFF;

  //Detect any data transition:
  assign DIFF = (RXD_OLD == RXD);
  
  
  //Single-process FSM:
  always_ff @(posedge CLK_x16)
    begin:FSM
      //Start a new time slot:
      if (DIFF)
        begin:tSTART
          CLK_MID <= 1'b0;
          COUNT <= 0;
        end:  tSTART
      else
        case(COUNT)
          4'h7: 
            begin:tMID
              CLK_MID <= 1'b1;
              COUNT <= COUNT + 1;
            end:tMID
          4'hF:
            begin:tEND
              CLK_MID <= 1'b0;
              COUNT <= COUNT + 1;
            end:tEND
          default:
              COUNT <= COUNT + 1;
        endcase
    end:  FSM


endmodule: CDR
