/* CONTROLLER AREA NETWORK (CAN) BUS
	   * Widely used in vehicles like self-driving cars.
       * Transmits frames serially between on-board ECUs
       * at speeds up to 1 Mb/s, with bitwise arbitration.
*/
//Unit scope items:
timeunit 1us;
timeprecision 1us;

module JKFF(input bit J, K, CLK,
            output bit Q, Qn);
  bit STATE;
  
  always_ff @(posedge CLK)
    case({J, K})
      2'b11: STATE <= ~STATE;
      2'b10: STATE <= 1'b1;
      2'b01: STATE <= 1'b0;
      2'b00: /* HOLD */;
    endcase
        
  assign Q = STATE, Qn = ~STATE;
endmodule

module CAN_BUS_TB();

  //CAN data frame type (simplified):
  typedef
  struct {
    bit SOF = 1'b0;    //Start-of-frame bit.
    bit [10:0] MSG_ID;    //A unique message ID.
    bit ID_XTND = 1'b0;     //1'b0 for base format.
    bit [3:0] DLC;      //Data length code = 4.
    bit [3:0] DATA;       //Simplified payload data.
    bit [14: 0] CRC_WORD;       //Cyclic redundancy check.
    bit CRC_EOF = 1'b1;    //CRC-EOF delimiter bit.
    bit [6 : 0] EOF = 7'b1111111;   //End-of-frame field.
  } CAN_FRAME_t;

  //An individual CAN frame:
  CAN_FRAME_t CAN_FRAME1;
  
  

  initial 
    //repeat(20) // Allows us to repeat 20 times to see assert failures.
    begin: SUITE
      //Local field variables:
      bit [3:0] DLC = 4'h4;
      bit [31:0] DATA;
      bit [3:0] itr;

      //Assign various fields:
      #1 CAN_FRAME1.MSG_ID = 11'h6A4;
      #1 CAN_FRAME1.DLC = DLC;
     
      //Quick Comp:
      
      itr = 2 ** (DLC*8) - 1;
      //$display("itr: %d", itr);
     
      #1 DATA = $urandom_range(itr);
      
      //$display("DATA: %d", DATA);
      #1 CAN_FRAME1.DATA = DATA;
      #1 CAN_FRAME1.CRC_EOF = 1'b0;
      //Print entire data frame:
      $display(
        "CAN_FRAME1: ", CAN_FRAME1
      );
  	end: SUITE
  
    always @(CAN_FRAME1.DATA)
      begin
        assert(CAN_FRAME1.DLC == $size(CAN_FRAME1.DATA));
        $info("DLC code %0d matches payload size, in bytes.", CAN_FRAME1.DLC);
      end
  

endmodule: CAN_BUS_TB

//bitwise arbitration
/*
	* As multiple
	* nodes attempt to drive their message ID fields onto the bus, wired-	   
    * AND logic is used to ensure that the lowest eleven-bit message ID 	* will win the arbitration. An ID of 11'h6A4, for instance, wins out 	
    * over 11'6A5.
*/

module ARBITER (
  input  bit RST, CLK,
  input  bit [3:1] MSG_ID,
  output bit CAN_BUS
);
  //2:1 MUX outputs:
  bit [3:1] MUX;
  
  //CAN frame ID fields:
  parameter bit SOF = 1'b0;
  parameter bit [11:0] MSG_ID3 = {SOF, 11'h7B3},
                       MSG_ID2 = {SOF, 11'h6A5},
                       MSG_ID1 = {SOF, 11'h6A4};

  //Initialize SEL to 0:
  bit [3:1] SEL = 3'b000; // Low even if 111
  
  bit [3:1] LOST = 3'b000;
  
  bit first = 1'b1;
  
  //Stick LOST into J
  //Can't put instances of a module with always_ff in always_comb, but since everything runs linearly, output should be the same. 
  
  //if(~first) begin
  JKFF jkff_inst_3(.CLK(CLK), .J(LOST[3]), .K(1'b1), .Q(SEL[3]));
  JKFF jkff_inst_2(.CLK(CLK), .J(LOST[2]), .K(1'b1), .Q(SEL[2]));
  JKFF jkff_inst_1(.CLK(CLK), .J(LOST[1]), .K(1'b1), .Q(SEL[1]));
  //end

  //One MUX per node:
  always_comb
    begin:PLEX
      
      // Logic to use the JK FF:
      LOST[3] = MUX[3] ^ CAN_BUS;
      LOST[2] = MUX[2] ^ CAN_BUS;
      LOST[1] = MUX[1] ^ CAN_BUS;
      
      
      //Can use either T1 or T2.
      //T1:
      MUX[3] = (SEL[3] && 1'b1) | (~SEL[3] && MSG_ID[3]);
      MUX[2] = (SEL[2] && 1'b1) | (~SEL[3] && MSG_ID[2]);
      MUX[1] = (SEL[1] && 1'b1) | (~SEL[3] && MSG_ID[1]);
      
      /*
      //T2:
      MUX[3] = (SEL[3]) ? 1'b1 : MSG_ID[3];
      MUX[2] = (SEL[2]) ? 1'b1 : MSG_ID[2];
      MUX[1] = (SEL[1]) ? 1'b1 : MSG_ID[1];
      */
    end:  PLEX

  //Wired-AND operation:
  //assign CAN_BUS = MUX[3] && MUX[2] && MUX[1];
  
  wire WAND_OUT;
  assign CAN_BUS = WAND_OUT;
  
  pullup Rpull(WAND_OUT);
  
  nmos #1 M[3:1] (WAND_OUT, 1'b0, MUX[3]), (WAND_OUT, 1'b0, MUX[2]), (WAND_OUT, 1'b0, MUX[1]);
  
  
  initial begin
    $display("CAN_BUS: ", CAN_BUS);
  end

endmodule: ARBITER
