// Code your design here
/* REGISTER FILE
    * Eight 8-bit registers.
*/


//const int N_BITS = 8;

interface BUS_IF /*#(parameter int N = N_BITS)*/(
  input bit CLK
);
  bit [8:0] DOUT;
  bit WEN, OEN;
  //bit [$clog2(N)-1:0] ADDR;
  bit [2:0] ADDR;
  bit [8:0] DIN;
  
  //I/O Spec discarded as signals in an interface are directionless.
  
endinterface

module REG_FILE #(parameter int N = 8)(
  BUS_IF JACK //BUS_IF is cable's data type
);
  //Register file:
  bit [7:0] REGS[N];

  //Write operation:
  always_ff @(posedge JACK.CLK)
    if (JACK.WEN)
      begin
        //$write("ENTRY INTO REGS WRITE\n");
        //$write("DIN: %8b, ADDR: %1d\n", JACK.DIN, JACK.ADDR);
      	REGS[JACK.ADDR] <= JACK.DIN;
        //$write("REGS[JACK.ADDR]: %8b\n", REGS[JACK.ADDR]);
      end

  //Read operation:
  always_ff @(posedge JACK.CLK)
    if (JACK.OEN)
      begin
        //$write("ENTRY INTO REGS READ: %8b \n", REGS[JACK.ADDR]);
      	JACK.DOUT <= REGS[JACK.ADDR];
        //$write("EXIT REGS READ: %8b \n", JACK.DOUT);
      end
  
endmodule: REG_FILE
