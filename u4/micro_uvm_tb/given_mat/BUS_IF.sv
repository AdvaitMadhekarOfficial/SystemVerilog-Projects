interface BUS_IF(
  input bit CLK
);
//Bundled signals:
  bit [2:0] ADDR;
  bit [7:0] DOUT;
  bit [7:0] DIN;
  bit WEN,  OEN;

endinterface: BUS_IF
