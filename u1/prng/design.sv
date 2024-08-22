// Code your design here

timeunit 1ps;
timeprecision 1ps;

module PRNG(
  input bit [1:0] MODE,
  output bit [3:0] FF, 
  input bit [3:0] SEED, 
  input bit RSTn, CLK,
  output bit SOUT
);
  
  
  bit temp_bit;
  //Remember to use "<=" for all sequential logic!
  always_ff @(negedge RSTn, posedge CLK)
    begin
      if(RSTn == 1)
        FF <= 4'b0001;
      else
        begin
          //$write("ENTRY! MODE: %2b\n", MODE);
          case(MODE)
            2'b10: 
              begin
                FF = (FF >> 1); // SHIFT MODE; vacated bit filled with 1'b1;
                FF[3] = 1'b1;
              end
            2'b11: 
              begin
                //$write("FF %4b\n", FF);
                temp_bit = FF[0];
                FF[1] = FF[3] ^ FF[0];
                FF = (FF >> 1);
                if(temp_bit == 1'b1)
            	  FF[3] = 1'b1;
                //$write("FF %4b\n", FF);
              end
            2'b01: 
              begin
              	FF = SEED;
                //$write("SEED: %4b\n", SEED);
                //$write("FF: %4b\n", FF);
              end
            2'b00: /*HOLD*/;
          endcase
        end
      /*if(MODE == 2'b11)
        begin
          
        end*/
      	
      
    end
            
    assign SOUT = FF[3];
  
endmodule: PRNG
