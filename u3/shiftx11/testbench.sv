// Code your testbench here
// or browse Examples

module SHIFTx11_TB;
  
  bit XMIT, SET, CLK;
  bit LINE;
  
  SHIFTx11 DUT(.XMIT(XMIT), .SET(SET), .CLK(CLK), .LINE(LINE));
  
  initial begin
    forever
      begin
        #10
        CLK = 1'b1;
        #10
        CLK = 1'b0;
      end
    end
  
  
  initial
    begin:SUITE
      #10
      SET = 1;
      XMIT = 0;
      #10
      SET = 0;
      XMIT = 1;
      $display("%1b, ", LINE);
      for(int i = 0; i < 10; i++)
        begin
          //$display("Q: %11b", DUT.Q);
          #20
          $display("%1b, ", LINE);
        end
      
      //OUTPUT MATCHES. Only thing is, had to use a 20 ns delay in between outputs instead of 10ns. Repeated output for 10ns. 
    end:SUITE

endmodule

