/* REGISTER FILE
 * Type:
 * o Eight 8-bit registers.
 * o Data output register.
 * o Interface port JACK.
 */

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
