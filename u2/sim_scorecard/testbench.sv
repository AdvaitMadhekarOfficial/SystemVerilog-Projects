module SCORECARD();
  
  //Unpacked struct b/c of VOUT being a real type. 
  typedef
    struct {
      int       TAG;  //Transaction ID (1, 2, 3, ...).
      bit [2:0] MODE; //Applied digital mode (0 to 7).
      longint   FREQ; //Applied audio frequency, in Hz.
      real      VOUT; //Measured output response, in volts.
      real      GAIN;
    } ROW_t;
  
  //Variables of type ROW_t:
  ROW_t ROW1, //First row.
  	ROW2,
 	ROW3; //Last row.
  
  parameter real VIN = 0.100; //V.

  initial
    begin:SIZE
      //Compute total bit-positions of memory per row: 
      $display("\n", "  TAG bits:  %3d\n  MODE bits: %3d\n  FREQ bits: %3d\n  VOUT bits: %3d\n", $bits(ROW1.TAG), $bits(ROW1.MODE), $bits(ROW1.FREQ), 64, "  %s\n", {20{"-"}}, "  Bit Size: %3d\n", $bits(ROW1.TAG) + $bits(ROW1.MODE) + $bits(ROW1.FREQ) + 64);
    end:  SIZE
  
  initial
    begin:FILL
      //Fill row 1 field by field:
      ROW1.TAG++;
      ROW1.MODE = 3'h2;
      ROW1.FREQ = 13_000; //Hz
      ROW1.VOUT = 0.106_268; //V.
      
      ROW1.GAIN = ROW1.VOUT / VIN;
      $display("  ROW1: %p", ROW1);

      //Fill row 2 by positional pattern:
      #10 ROW2 = '{ /* Order is critical. */
        2, 3'h4, 68_000, 0.074_509, 0.074_509/VIN
      };
      
      $display("  ROW2: %p", ROW2);

      //Fill row 3 by keyed (named) pattern:
      #10 ROW3 = '{ /* Order is immaterial. */ 
        TAG: 3, 
        FREQ: 97_000, 
        MODE: 3'h5, 
        VOUT: 0.057_805,
        GAIN: 0.057_805/VIN
      };
      
      $display("  ROW3: %p", ROW3);
    end:  FILL
  

  
endmodule
