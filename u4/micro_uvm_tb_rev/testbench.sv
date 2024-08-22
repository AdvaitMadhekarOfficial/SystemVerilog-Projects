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


//Fully UVM Complaint: every OOP component is derived from an existing UVM base class. 

//YOu're able to import packages from existing classes in the uvm_package. 

//`include "uvm_pkg.sv"
`include "uvm_macros.svh"


package CLASS_PKG;

  	//Virtual interface type:
  	typedef virtual BUS_IF VRWIF_t;

	import uvm_pkg::*;

	//Unresolvable Error. Package found at: https://github.com/chiggs/UVM/blob/master/distrib/examples/simple/hello_world/hello_world.sv

	//https://verificationacademy.com/forums/t/package-export-does-not-work-like-i-expect/31199/2

	//import uvm_pkg::uvm_driver;
	//import uvm_pkg::uvm_monitor;

	



	class DRIVER extends uvm_driver;
      //Virtual bus representation:
      typedef virtual BUS_IF  VRWIF_t;
      VRWIF_t VRWIF;

      //Randomizable write data:
      rand bit [7:0] DATA;


      function new(
        string INAME,
        VRWIF_t RWIF_arg
      );
        
        //Each object must be aware of it's name and parent's name.
        super.new(INAME, null); //Fix to an error
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

	class MONITOR extends uvm_monitor; 
      //Virtual bus representation:
      typedef virtual BUS_IF  VRWIF_t;
      VRWIF_t VRWIF;

      //Randomizable write data:
      bit [7:0] DATA;
      
      //Nburst
      int Nburst = 12;


      function new(
        string INAME,
        VRWIF_t RWIF_arg,
        int Nburst_arg
      );
        
        //Each object must be aware of it's name and parent's name.
        super.new(INAME, null); //Fix to an error
        VRWIF = RWIF_arg;
        Nburst = Nburst_arg;
      endfunction: new 

      //Write data in ascending order:
      task READ_BACK;
        VRWIF.OEN = 1'b1; VRWIF.WEN = 1'b0;
        $display("\n  Read from ADDR:");
        repeat (Nburst)
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


    class ENVIRONMENT extends uvm_env;     
      //Encapsulate driver and monitor:
      DRIVER DRV;
      MONITOR MON;
      
      VRWIF_t VRWIF;

      //Build driver, monitor components:
      function new(
		string INAME, VRWIF_t RWIF_arg, int Nburst_arg
      );
        super.new(INAME, null);
        DRV = new("DRIVER", RWIF_arg);
        MON = new("MONITOR", RWIF_arg, Nburst_arg);
      endfunction: new

    endclass: ENVIRONMENT
    
endpackage: CLASS_PKG


module REG_FILE_TB();

//Test leads:
  bit CLK = 1'b1;

//Interface bus:
  BUS_IF RWIF(CLK);
  
  import CLASS_PKG::*;
  
  int Nburst = 20;
  
  //Null instantiations
  //DRIVER DRV;
  //MONITOR MON;
  ENVIRONMENT ENV;

//Register file:
  REG_FILE DUT(.JACK(RWIF));

  initial
    begin:TEST_SUITE
      $value$plusargs("Nburst=%0d", Nburst);

      //DRV = new("DRIVER", RWIF); //Ran at time 0, Build phase
      //MON = new("MONITOR", RWIF); //Ran at time 0, Build phase
      
      ENV = new("ENVIRONMENT", RWIF, Nburst);
      
      //ENV.randomize();
      ENV.DRV.WRITE_DATA();
      ENV.MON.READ_BACK();
      
      //DRV.WRITE_DATA();
      //MON.READ_BACK();

    end:  TEST_SUITE

  initial
    repeat (50)
    begin:CLOCK
      #5 CLK = 1'b0;
      #5 CLK = 1'b1;
    end:  CLOCK
  
  final
  	begin:DISPLAY_REPORT
      /*$display(
        "\n  Total iterations: %d \n",
        Nburst
      );
      $display(
        "\n  Dump REG_FILE data:\n  %p\n",
        DUT.REGS
      );*/
      
      $display("\n",
               "  Nburst:  %0d\n", Nburst,
               "  Environ: %s\n", ENV.get_full_name(),
               "  Driver:  %s\n", ENV.DRV.get_full_name(),
               "  Monitor: %s\n", ENV.MON.get_full_name(),
               "\n  Dump REG_FILE data:\n  %p\n", DUT.REGS
      );

    end:DISPLAY_REPORT
endmodule:  REG_FILE_TB


