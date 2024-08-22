// Code your testbench here
// or browse Examples

timeunit 1ps;
timeprecision 1ps;

module PRNG_TB;

  bit SOUT;
  bit [1:0] MODE;
  bit [3:0] FF;
  bit [3:0] SEED;
  bit CLK, RSTn;
  
  bit enable = 1'b1;
  
  PRNG DUT(.MODE(MODE), .FF(FF), .SEED(SEED), .CLK(CLK), .RSTn(RSTn), .SOUT(SOUT));
  
  initial
    repeat(20) 
      begin
        #500
        CLK = 1'b1;
        #500
        CLK = 1'b0;
      end
  
  
  
  initial begin
    
    $display("TIME  MODE --FF[0:3]-- SOUT");
    MODE = 2'b00;
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    MODE = 2'b01;
    SEED = 4'b0001;
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    MODE = 2'b11;
    #1000;
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    MODE = 2'b11;
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
	MODE = 2'b10;
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
    #1000
    $display("%0d ns:  %2b   %1h %4b     %1b", $time/1000, MODE, FF, FF, SOUT);
  end
endmodule
