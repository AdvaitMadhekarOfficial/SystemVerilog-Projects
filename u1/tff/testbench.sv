// Code your testbench here
// or browse Examples
 module TFF_TB();

   //Test leads:
   bit T, Q, CLK;

   //Instance DUT of TFF:
   TFF DUT( .CLK(CLK), .Q(Q), .T );
   
    
   /*
   initial
   repeat(20)
     begin: CLK_GEN
       CLK = 1'b0;
       #10
       CLK = 1'b1;
       #10
     end: CLK_GEN
   */
   always
    begin
      CLK = 1; #10; CLK = 0; #10;
    end
   
    initial
      fork:PULSED
        # 5 T = 1'b1;  //Pulse T high
        #15 T = 1'b0;  //for 100 ns.
        #25 T = 1'b1;
        #35 T = 1'b0;
        #45 $stop;
        $dumpfile("dump.vcd");
   		$dumpvars;
      join:PULSED
   
   //«Other testbench code.»
   //$dumpfile("dump.vcd");
   //$dumpvars;
   //Unable to open EPWave

 endmodule: TFF_TB
