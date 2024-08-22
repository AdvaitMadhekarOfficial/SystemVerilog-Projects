// Code your testbench here
// or browse Examples
/* REGISTER-FILE TESTBENCH
 * Type:
 * o Write random data to each address.
 * o Read data back from each address,
 *   in descending order.
 */


//https://verificationguide.com/uvm/uvm-phases/
//UVM PHASES

//BUILD PHASES:
//BUILD
//CONNECT
//END OF ELABORATION

/*


*/

//START OF ELABORATION
//RUN
//EXTRACT
//CHECK
//REPORT


class MONITOR;
  //Virtual bus representation:
  typedef virtual BUS_IF  VRWIF_t;
  VRWIF_t VRWIF;

  //Randomizable write data:
  bit [7:0] DATA;
  
  
  function new(VRWIF_t RWIF_arg);
    VRWIF = RWIF_arg;
  endfunction: new

  //Write data in ascending order:
  task READ_BACK;
    VRWIF.OEN = 1'b1; VRWIF.WEN = 1'b0;
    $display("\n  Read from ADDR:");
    repeat (12)
      begin:RANGE
        //ADDR = this.srandom(8);
        randcase
          1 : VRWIF.ADDR = 1;
          1 : VRWIF.ADDR = 2;
          1 : VRWIF.ADDR = 3;
          1 : VRWIF.ADDR = 4;
          1 : VRWIF.ADDR = 5;
          1 : VRWIF.ADDR = 6;
          1 : VRWIF.ADDR = 7;
        endcase
        @(posedge VRWIF.CLK) /* DOUT latched.*/;
        @(negedge VRWIF.CLK) $display(
          "  REGS[%1d] <-- 8'h%2h",
          VRWIF.ADDR, VRWIF.DOUT
        );
      end:  RANGE
    @(posedge VRWIF.CLK) $finish();
  endtask: READ_BACK

endclass: MONITOR



class DRIVER;
  //Virtual bus representation:
  typedef virtual BUS_IF  VRWIF_t;
  VRWIF_t VRWIF;

  //Randomizable write data:
  rand bit [7:0] DATA;
  
  
  function new(VRWIF_t RWIF_arg);
    VRWIF = RWIF_arg;
  endfunction: new

  //Write data in ascending order:
  task WRITE_DATA;
    @(negedge VRWIF.CLK);
      VRWIF.WEN = 1'b1; VRWIF.OEN = 1'b0;
      $display("\n  Write to ADDR:");
      for (int A = 0; A <= 7; A++)
      begin:RANGE
        this.randomize();
        VRWIF.ADDR = A;
        VRWIF.DIN = DATA;
        @(posedge VRWIF.CLK) /* Write DIN to ADDR. */;
        @(negedge VRWIF.CLK) $display(
          "  @%3t ns: REGS[%1h] <-- 8'h%2h",
          $time, VRWIF.ADDR, VRWIF.DIN
        );
      end:  RANGE
  endtask: WRITE_DATA

endclass: DRIVER



module REG_FILE_TB();

//Test leads:
  bit CLK = 1'b1;

//Interface bus:
  BUS_IF RWIF(CLK);
  
  //Null instantiations
  DRIVER DRV;
  MONITOR MON;

//Register file:
  REG_FILE DUT(.JACK(RWIF));

  initial
    begin:TEST_SUITE

      DRV = new(RWIF); //Ran at time 0, Build phase
      MON = new(RWIF); //Ran at time 0, Build phase
      
      DRV.randomize();
      
      DRV.WRITE_DATA();
      MON.READ_BACK();

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

