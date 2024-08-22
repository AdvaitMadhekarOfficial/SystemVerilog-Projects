// Code your design here
interface BUS_IF(
  input bit CLK
);
//Bundled signals:
  bit [2:0] ADDR;
  bit [7:0] DOUT;
  bit [7:0] DIN;
  bit WEN,  OEN;

endinterface: BUS_IF

module REG_FILE(
  BUS_IF JACK
);

//Register array:
  bit [7:0] REGS[8];

//Write operation:
  always_ff @(posedge JACK.CLK)
    if(JACK.WEN)
      REGS[JACK.ADDR] <= JACK.DIN;

//Read operation:
  always_ff @(posedge JACK.CLK)
    if(JACK.OEN)
      JACK.DOUT <= REGS[JACK.ADDR];

endmodule:  REG_FILE
