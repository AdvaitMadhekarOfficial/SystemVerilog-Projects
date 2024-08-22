/* REGISTER-FILE TESTBENCH
 * Type:
 * o Write random data to each address.
 * o Read data back from each address,
 *   in descending order.
 */
module REG_FILE_TB();

//Test leads:
  bit CLK = 1'b1;
  
//Interface bus:
  BUS_IF RWIF(CLK);

//Register file: 
  REG_FILE DUT(.JACK(RWIF));

  initial
  begin:TEST_SUITE
  //Write to every register:
    begin:WRITE_DATA
      @(negedge CLK);
      RWIF.WEN = 1'b1; RWIF.OEN = 1'b0;
      $display("\n  Write to ADDR:");
      for (int A = 0; A <= 7; A++)
      begin:RANGE
        RWIF.ADDR = A;
        RWIF.DIN = $urandom_range(8'hFF);
        @(posedge CLK) /* Write DIN to ADDR. */;
        @(negedge CLK) $display(
          "  @%3t ns: REGS[%1h] <-- 8'h%2h",
          $time, RWIF.ADDR, RWIF.DIN
        );
      end:  RANGE
    end:  WRITE_DATA
  //Read back from registers:
    begin:READ_BACK
      RWIF.OEN = 1'b1; RWIF.WEN = 1'b0;
      $display("\n  Read from ADDR:");
      for (int A = 7; A >= 0; A--)
      begin:RANGE
	RWIF.ADDR = A;
        @(posedge CLK) /* DOUT latched. */;
        @(negedge CLK) $display(
	  "  @%3t ns: REGS[%1h] --> 8'h%2h",
	  $time, RWIF.ADDR, RWIF.DOUT
	);
      end:  RANGE
      @(posedge CLK) $finish();
    end:  READ_BACK
  end:  TEST_SUITE

  initial
    repeat (50)
    begin:CLOCK
      #5 CLK = 1'b0;
      #5 CLK = 1'b1;
    end:  CLOCK

  final
    $display(
      "\n  Dump REG_FILE data:\n  %p\n",
      DUT.REGS
    );
endmodule:  REG_FILE_TB
