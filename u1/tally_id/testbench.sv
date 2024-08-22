// Code your testbench here
// or browse Examples
/* 1-D VECTOR TALLY TESTBENCH
   * Verify the DUT counts up
   * the correct number of 1s.
   */


module TALLY_1D_TB();
  //Test leads:
  bit [11:0] VECTOR;
  bit [ 3:0] COUNT;
  //Instantiate design, using .name style:
  TALLY_1D DUT( .VECTOR(VECTOR), 
                .COUNT(COUNT) 
              );
/*
  initial
    begin:SUITE
      //Test suite applies a dozen vectors, 
      //comparing expected vs. actual count:
      #10 VECTOR = 12'b0;
      #1;
      $strobe("Exp:  0   Act: %2d", COUNT);
      #10 VECTOR = 12'h321;
      #1;
      $strobe("Exp:  4   Act: %2d", COUNT);
      //. . . . .
      #10 VECTOR = 12'h8AC; //1000_1010_1100
      #1;
      $strobe("Exp:  5   Act: %2d", COUNT);
      #10 VECTOR = 12'b1111_1111_1111;
      #1;
      $strobe("Exp: 12   Act: %2d", COUNT);
    end:  SUITE
  
  always @(COUNT)
    assert($countones(VECTOR) == COUNT);
*/
  initial 
    repeat(12)
      begin: SUITE
        VECTOR = $urandom_range(12'b0, 12'hFFF);
        //wire [3:0] exp_val = $countones(VECTOR);
        #10 $write(
          "Time: %2d ns, Exp: %2d, Act: %2d\n", $realtime, $countones(VECTOR), COUNT
        );
      end: SUITE
 
//My own version of an assertion:
  /*
 initial
   begin:CHECK
     #1000;
     VECTOR = 12'b0;
     send_and_check(COUNT, 12'b0, 0);
     VECTOR = 12'h321;
     #100
     send_and_check(COUNT, VECTOR, 4);
     VECTOR = 12'h8AC;
     #100;
     send_and_check(COUNT, 12'h8AC, 5);
     VECTOR = 12'b1111_1111_1111;
     #100;
     send_and_check(COUNT, 12'b1111_1111_1111, 12);
   end:CHECK
  
  function send_and_check(bit[3:0] COUNT, bit[11:0] VECTOR_CHECK, bit[3:0] COUNT_CHECK);
    assert (COUNT == COUNT_CHECK);
    $display("COUNT = %2d, COUNT_CHECK = %2d, VECTOR_CHECK = 0x%0h", COUNT, COUNT_CHECK, VECTOR_CHECK);
  endfunction
  */
endmodule: TALLY_1D_TB
