// Code your design here


/* SHIFT REGISTER (x11 bits)
    * SET loads register contents asynchronously.
    * XMIT enables shifting out the loaded data.
*/
module SHIFTx11(
  input  bit XMIT, SET, CLK,
  output bit LINE
);
  //Vector to model register:
  bit [10:0] Q;

  always_ff @(posedge SET, posedge CLK)
    begin:SHIFT 
      if (SET) //Asynchronous set function.
        Q = 11'b11010001010;
      else if (XMIT) //On active edges of CLK.
        begin
          Q = Q >> 1;
          Q[10] = 0;
        end
      
    end:  SHIFT

  assign LINE = Q[0];

endmodule: SHIFTx11
