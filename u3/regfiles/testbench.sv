// Code your testbench here
// or browse Examples

module REG_FILE_TB();
  
  bit WEN, OEN, CLK;
  bit [8:0] DOUT;
  bit [2:0] ADDR;
  bit [8:0] DIN;
  
  
  BUS_IF RWIF(.CLK(CLK));
  REG_FILE DUT(.JACK(RWIF));
  
  
  initial
    begin
      forever begin
          #10
          CLK = 1'b1;
          #10
          CLK = 1'b0;
      end
    end
    
  /*
  initial begin
    repeat(25)
      begin
        #10
        CLK = 1'b1;
        #10
        CLK = 1'b0;
      end
  end
  */
  initial
    begin:TEST_SUITE
      //Write to every register:
      begin:WRITE_DATA
        @(negedge CLK)
          begin
            RWIF.WEN = 1'b1;
            RWIF.OEN = 1'b0;
          end
        $display("\n  Write to ADDR:");
        for (int i = 0; i < 7; i++)
          begin:RANGE
            ADDR = i;
            DIN = $urandom_range(100);
            @(posedge CLK) 
              begin
                RWIF.ADDR = ADDR;
                RWIF.DIN = DIN;
                //$display("IN REGS: 8'h%2h", DUT.REGS[ADDR]);
              end
            @(negedge CLK) 
              begin
            	RWIF.OEN = 1'b1;
                //$display("OUTPUT SHOULD BE: 8'h%2h\n", DIN);
                //$display("IN REGS: 8'h%2h", DUT.REGS[ADDR]);
                #10 $display(  
                  "  @%3t ns: REGS[%1h] <-- 8'h%2h",
                  $time, RWIF.ADDR, RWIF.DOUT
              	);
                #10 RWIF.OEN = 1'b0;
              end
          end:  RANGE
      end:  WRITE_DATA
      
      
      begin:READ_BACK
        RWIF.WEN = 1'b0;
        RWIF.OEN = 1'b1;
        $display("\n  Read from ADDR:");
        for (int i = 0; i < 7; i++)
          begin:RANGE 
            RWIF.ADDR = i;
            @(posedge CLK) /* DOUT latched. */;
            @(negedge CLK) $display( 
              "  @%3t ns: REGS[%1h] --> 8'h%2h",
              $time, RWIF.ADDR, RWIF.DOUT
            );
          end: RANGE
        @(posedge CLK) $finish();
      end:  READ_BACK
    end:  TEST_SUITE
  final
    $display(
      "\n  Dump REG_FILE data:\n  %p\n",
      DUT.REGS
    );
  
endmodule:REG_FILE_TB
