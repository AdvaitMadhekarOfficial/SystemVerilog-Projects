// Code your design here
// Code your design here
/* 
* 1-D VECTOR TALLY MODULE
* Inputs a 12-bit vector.
* Counts the number of 1s.
*/

//Unit-scope timescale:
timeunit 1ns;
timeprecision 1ns;

module TALLY_1D(
  input  bit [11:0] VECTOR,
  output bit [3:0] COUNT
);
  always_comb
    begin:TOTAL
      COUNT = 4'b0;
      for (int ROW = 0; ROW < 12; ROW++) begin
        COUNT += VECTOR[ROW];
      end
    end:  TOTAL
endmodule: TALLY_1D
