// Code your design here
//Unit-scope timescale:
timeunit 1ns;
timeprecision 1ns;


module TFF(
  output bit Q,
  input  bit T,
  CLK
);
  always_ff @(posedge CLK)
    Q <= (Q ^ T);

endmodule: TFF


/*
module TFFx4(
  input bit [3:0] T,
  output bit [3:0] Q,
  input bit CLK
);
  
  always_ff @(posedge CLK)
    begin: VECTOR
      Q[3:0] <= (Q[3:0] ^ T[3:0]); // Difference between bitwise XOR and XOR altogether.
    end: VECTOR
    
  
endmodule: TFFx4
*/
