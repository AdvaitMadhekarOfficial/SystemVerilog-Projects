// Code your design here
//Unit-scope items:
timeunit 1ns;
timeprecision 1ns;

module CLIPPER(
  output bit [11:0] PRODUCT,
  input  bit [ 7:0] LUMA,
  bit [ 3:0] GAIN,
  bit        CLK
);
  
  //LEGAL VALUES FOR LUMA
  parameter int FLOOR = 16,
  				CEILING = 235;
  
  // LOCAL VARS
  bit [11:0] PROD_RAW;
  bit [11:0] PROD_CLIP;
 
  
  
  always_comb
    begin:CLIP
      PROD_RAW = LUMA * GAIN;
      
      //CLIP PROD_RAW
      if(PROD_RAW > CEILING)
        begin
          PROD_CLIP = CEILING;
        end
      else if(PROD_RAW < FLOOR)
        begin
          PROD_CLIP = FLOOR;
        end
     else
       begin
         PROD_CLIP = PROD_RAW;
       end
      
    end:CLIP
  
  //RULE OF THUMB: ANYTHING SEQUENTIAL USES NONBLOCKING ASSIGNMENTS
  //always_ff @(posedge CLK)
    //PRODUCT <= PROD_RAW;
  
  always_ff @(posedge CLK)
    begin:REG
      //A labeled immediate assertion:
      HEADROOM:
      assert (PRODUCT <=  CEILING)
      	else
          $error("Headroom violation CEIL!\n %8d, %4d, %12d", LUMA, GAIN, PROD_CLIP);

      assert (PRODUCT >= FLOOR)
        else
          $error("Headroom Violation FLOOR!\n %8d, %4d, %12d", LUMA, GAIN, PROD_CLIP);
      	
      PRODUCT <= PROD_CLIP;
    end:  REG
  
  
  
 endmodule: CLIPPER
