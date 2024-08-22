
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
  
  ROW_t SCD[1:5];
  real GAIN_x30[1:5];

  parameter real VIN = 0.100; //V.

  /*
  initial
    begin:SIZE
      //Compute total bit-positions of memory per row:
      $display("\n", "  TAG bits:  %3d\n  MODE bits: %3d\n  FREQ bits: %3d\n  VOUT bits: %3d\n", $bits(ROW1.TAG), $bits(ROW1.MODE), $bits(ROW1.FREQ), 64, "  %s\n", {20{"-"}}, "  Bit Size: %3d\n", $bits(ROW1.TAG) + $bits(ROW1.MODE) + $bits(ROW1.FREQ) + 64);
    end:  SIZE
    
  */

  initial
    begin:FILL
      SCD[1] = '{
      	TAG: 1,
        MODE: 3'h2,
        FREQ: 13_000,
        VOUT: 0.106_268,
        //GAIN: 1.06_268
        GAIN: (SCD[1].VOUT)/VIN
      };
      
      SCD[2] = '{
      	TAG: 2,
        MODE: 3'h2,
        FREQ: 19_000,
        VOUT: 0.130_553,
        //GAIN: 1.30_553
        GAIN: (SCD[2].VOUT)/VIN
      };
      
      SCD[3] = '{
      	TAG: 3,
        MODE: 3'h2,
        FREQ: 34_000,
        VOUT: 0.148_253,
        //GAIN: 1.48_253
        GAIN: (SCD[3].VOUT)/VIN
      };
      
      SCD[4] = '{
      	TAG: 4,
        MODE: 3'h2,
        FREQ: 60_000,
        VOUT: 0.132_044,
        //GAIN: 1.32_044
        GAIN: (SCD[4].VOUT)/VIN
      };
      
      SCD[5] = '{
      	TAG: 5,
        MODE: 3'h2,
        FREQ: 91_000,
        VOUT: 0.105_602,
        //GAIN: 1.05_602
        GAIN: (SCD[5].VOUT)/VIN
      };
      
      foreach(SCD[i])
        begin
          $display("%d: %p\n", i, SCD[i]);
        end
    end:  FILL
  
	initial
    begin:PLOT

      //Plot horizontal axis:
      $display("%s\n", {40{"-"}});

      foreach (SCD[J])
        begin:BARS     
          GAIN_x30[J] = SCD[J].GAIN * 30;
          $write("%0d Hz |", SCD[J].FREQ);
          //Print each bar of length GAIN_x30:
          repeat(GAIN_x30[J])
            begin
            	$write("+"); //Omit newline.
            end
          $write("\n");
        end:  BARS

      //Extend vertical axis:
      $write("");
    end:  PLOT



endmodule
