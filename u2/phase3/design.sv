/* THREE-PHASE CLOCK GENERATOR
         * o Reset asynchronously to 3'b011.
         * o Rotate right to generate phases.
*/

//Using logic datatype
//all datatypes will default to indeterminant initial values of X

//Tried Part C:


/*
module PHASE3(
  input  logic CLK_IN,
  output logic [3:1] PHI_OUT
);
  //One-cold state vector:
  logic [1:3] STATE, NEXT;
  
  always_ff @(posedge RST, posedge CLK_IN)
    begin:ROTx3
      //Rotate bits to right:
      STATE <= STATE >>> 1;
    end:  ROTx3
  
  // case(1'b0): LEGAL, and recommended for one-hot/cold Finite State Machine
  always_comb
    begin:ONE_COLD
      case(1'b0)
        1'b0: NEXT = 1'b1;
        1'b1: NEXT = 1'b1;
        default:     NEXT = 1'b0;
      endcase
    end:  ONE_COLD
  
  // 011
  //When STATE = 1'b0, NEXT = 1'b1; When STATE = 1'b1, NEXT = 1'b1. Default, NEXT = 1'b0. QUESTION: (TODO) CHANGE TO USE STATE[] VECTOR.

  
  //always_ff > describes only STATE reg. On each edge of CLK_IN, reg should clock in NEXT state bits. 
  //always_comb > gate logic and wiring that computes NEXT nased on STATE.
  //Drive out the state bits:
  assign PHI_OUT = STATE;

endmodule: PHASE3
*/

//Without Part C:

module PHASE3(
  input  logic CLK_IN,
  output logic [3:1] PHI_OUT,
  //output logic [3:1] CLK_OUT
);
  //One-cold state vector:
  logic [1:3] STATE, NEXT;
  
  parameter realtime GUARD_BAND = 1.0ns;
  
  always_ff @(posedge CLK_IN)
  //always
    begin:ROTx3
      //Rotate bits to right:
      STATE <= STATE >>> 1;
    end:  ROTx3
  
  // case(1'b0): LEGAL, and recommended for one-hot/cold Finite State Machine
  always_comb
  //always
    begin:ONE_COLD
      case(1'b0)
        1'b0: NEXT = 1'b1;
        1'b1: NEXT = 1'b1;
        default:     NEXT = 1'b0;
      endcase
    end:  ONE_COLD
  
  // 011
  //When STATE = 1'b0, NEXT = 1'b1; When STATE = 1'b1, NEXT = 1'b1. Default, NEXT = 1'b0. QUESTION: (TODO) CHANGE TO USE STATE[] VECTOR.

  
  //always_ff > describes only STATE reg. On each edge of CLK_IN, reg should clock in NEXT state bits. 
  //always_comb > gate logic and wiring that computes NEXT nased on STATE.
  //Drive out the state bits:
  assign PHI_OUT = STATE;
  
  //CLOCK GENERATION:

  logic [3:1] CLK_OUT;
  
  //CLK_OUT[1] = PHI_OUT[1] NOR ((CLK_OUT[1] NOR PHI_OUT[2]) [CLK_OUT[2]] NOR PHI_OUT[3]) [CLK_OUT[3]]
  //CLK_OUT[2] = CLK_OUT[1] NOR PHI_OUT[2]
  //CLK_OUT[3] = CLK_OUT[2] NOR PHI_OUT[3]
  
  //Typical VHDL syntax:
  /*
  CLK_OUT[1] = ~(CLK_OUT[3] | PHI_OUT[1]);
  CLK_OUT[2] = ~(CLK_OUT[1] | PHI_OUT[2]);
  CLK_OUT[3] = ~(CLK_OUT[2] | PHI_OUT[3]);
  */
  
  
  //In this version, CLK_OUT would be output.
  
  //Generic NOR gates with adjustable delay:
  nor #(GUARD_BAND)
    //  Output first     Inputs last
  	NOR1(CLK_OUT[1], PHI_OUT[1], CLK_OUT[3]),
  	NOR2(CLK_OUT[2], PHI_OUT[2], CLK_OUT[1]),
  	NOR3(CLK_OUT[3], PHI_OUT[3], CLK_OUT[2]);
  
  


endmodule: PHASE3

