// Code your testbench here
// or browse Examples

module CLIPPER_TB;
  
  bit [11:0] PRODUCT;
  bit [7:0] LUMA;
  bit [3:0] GAIN;
  bit CLK;
  
  CLIPPER DUT(.PRODUCT(PRODUCT), .LUMA(LUMA), .GAIN(GAIN), .CLK(CLK));
  
  bit [7:0] max_luma;
  assign max_luma = 8'd30;
  
  bit [3:0] max_gain;
  assign max_gain = 4'b1111;
  
  initial begin
  forever begin
      #40
      CLK = 1'b1;
      #40
      CLK = 1'b0;
    end
  end
  
  always @(posedge CLK)
    begin:GEN_VARS
      #2000
      LUMA = $urandom_range(0, max_luma);
      GAIN = $urandom_range(0, max_gain);
  	end:GEN_VARS
  
  always @(posedge CLK)
    begin:DISP
      #1500
      //$strobe("@ %2d ns: %8d * %4d = %12d", $time, LUMA, GAIN, PRODUCT);
      $strobe(
          " @%t %3h * %3h = %3h from raw product %3h equals %3h",
          $time, LUMA, GAIN, PRODUCT, DUT.PROD_RAW, LUMA * GAIN
      ); 
      
      //Self determined expression:
      //LUMA * GAIN is ^
      //Width of self-determined op is maximum of operand widths. In this case, 8 bits (LUMA = 8 bits)
      //Context determined expression:
      //PROD_RAW = LUMA * GAIN;
      //Bit Width = max(LHS, RHS)
      //LHS will win in this case (PROD_RAW, 12 bits)
      
      
      // FINAL SETTLED VALUES, AVOIDS RACE CONDITIONS
    end:DISP

  
  
  
endmodule
