// Code your design here
//Unit-scope items:
timeunit 1ns;
timeprecision 1ns;

typedef
    enum bit [7:0] {
      E, T, A, O, I, N, S, H, R, D, L, U
    } ALPHA_T;

module DECODER(
  input ALPHA_T CIPHER,
  output ALPHA_T PLAIN
);
  always_comb
    case (CIPHER)
      //Convert cipher letter to plain:
      8'd69 : PLAIN = 8'd85; // E > U
      8'd84 : PLAIN = 8'd78; // T > N
      8'd65 : PLAIN = 8'd84; // A > T
      8'd79 : PLAIN = 8'd73; // O > I
      8'd73 : PLAIN = 8'd69; // I > E
      8'd78 : PLAIN = 8'd72; // N > H
      8'd83 : PLAIN = 8'd82; // S > R
      8'd72 : PLAIN = 8'd65; // H > A
      8'd82 : PLAIN = 8'd76; // R > L
      8'd68 : PLAIN = 8'd83; // D > S
      8'd76 : PLAIN = 8'd68; // L > D
      8'd85 : PLAIN = 8'd79; // U > O
    endcase
  
endmodule: DECODER

/*
module DECODER(
  input  bit [7:0] CIPHER,
  output bit [7:0] PLAIN
);
  always_comb
    case (CIPHER)
      //Convert cipher letter to plain:
      8'd69 : PLAIN = 8'd85; // E > U
      8'd84 : PLAIN = 8'd78; // T > N
      8'd65 : PLAIN = 8'd84; // A > T
      8'd79 : PLAIN = 8'd73; // O > I
      8'd73 : PLAIN = 8'd69; // I > E
      8'd78 : PLAIN = 8'd72; // N > H
      8'd83 : PLAIN = 8'd82; // S > R
      8'd72 : PLAIN = 8'd65; // H > A
      8'd82 : PLAIN = 8'd76; // R > L
      8'd68 : PLAIN = 8'd83; // D > S
      8'd76 : PLAIN = 8'd68; // L > D
      8'd85 : PLAIN = 8'd79; // U > O
    endcase
  
endmodule: DECODER
*/
