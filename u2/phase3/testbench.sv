// Code your testbench here
// or browse Examples
module PHASE3_TB();
  //Test leads:
  logic CLK_IN = 1'b1;
  logic [3:1] PHI_OUT;
  logic [3:1] CLK_OUT;

  //Instantiate phase generator:
  PHASE3 DUT(.CLK_IN(CLK_IN), .PHI_OUT(PHI_OUT), .CLK_OUT(CLK_OUT));

  initial
    begin:CLOCK
      repeat (21)
        begin:CLK_100MHz
          #5
          CLK_IN = 1'b0;
          #5
          CLK_IN = 1'b1;
          $display("PHI_OUT: ", PHI_OUT);
          $display("CLK_OUT: ", CLK_OUT);
        end:  CLK_100MHz
    end:  CLOCK
  
  	//Works with always in design
    //State Assigned next value. 
  	//initial
      //#1ns DUT.STATE = 3'b000;

  

endmodule: PHASE3_TB

/*
//Power up into invalid state:
            initial
              #1ns DUT.STATE = 3'b000;
              */

//Faulty code ^^ 
//Error [ICPD]: Illegal Combination of Procedural Drivers
    //Variable STATE is written to on the LHS of an always_ff.
    //Thus, it cannot be written to by any other process.

//always_ff is more restrictive than a legacy Verilog always. 

