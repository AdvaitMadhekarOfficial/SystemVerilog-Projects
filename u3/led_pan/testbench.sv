// Code your testbench here
// or browse Examples



//Unit-scope items:
timeunit 1ms;
timeprecision 1ms;

package LED_PKG;

  //Type for one RYGB LED:
  typedef  enum {BLU, GRN, YEL, RED}  LED_t;

  //Type for the 2x4 panel:  --row--  --col--
  typedef  LED_t  PANEL_t [2][4];

endpackage: LED_PKG

module LED_PANEL_TB();

  //Wildcard import of all packaged items:
  import LED_PKG::*;

  //Declare a variable of panel type:
  PANEL_t PANEL;
  
  int ALERTS = 0;
  bit DANGER;

  always @(PANEL)
    begin:STATUS
      DANGER = RED inside {PANEL};
      if(DANGER)
        begin
          $display("DANGER!");
          ALERTS += 1;
        end
    end:  STATUS
      
  
  initial
    begin:UPDATE
      
      //WALK_RED(1, GRN); //Walk through row 1 with GRN background.
      //$display(" H %4t ms: %p \n", $time, PANEL);
      //All LEDs go to GRN; RED WALK Works for row 1. 
      
      //WALK_RED(2, YEL); //Walk through row 2 with YEL background.
      //$display(" H %4t ms: %p \n", $time, PANEL);
      //All LEDs go to YEL;
      //All LEDs go to GRN; RED WALK DOES NOT Work for row 2. Because 
      //row 2 = index 1, row 1 = index 0. index = row - 1.
     
      
      fork:WALK
        WALK_RED(0, GRN);
        //#10ms $display(" H %4t ms: %p \n", $time, PANEL);
        WALK_RED(1, YEL);
        //#10ms $display(" H %4t ms: %p \n", $time, PANEL);
      join:WALK //Will run both processes concurrently, multithreading
      
      
      
      //Pattern assignment to entire 2x4 array:
      #10ms PANEL = '{
        '{YEL, BLU, GRN, BLU}, '{GRN, YEL, BLU, BLU}
      };  
      
      $display("  %4t ms: %p \n", $time, PANEL);
      
      #10ms PANEL = '{
        '{YEL, GRN, RED, BLU}, '{GRN, YEL, RED, BLU}
      };  
      
      $display("  %4t ms: %p \n", $time, PANEL);
      
      /*
       //SystemVerilog detection style:
      if(RED inside {PANEL})
        begin
          $display("JJSJSJCorr");
        end
        */
      
      //PROBLEM in "RED inside {PANEL}", will go high if any index is == RED!
      
      #10ms PANEL = '{
        '{YEL, BLU, GRN, GRN}, '{GRN, YEL, GRN, RED}
      };  
      
      $display("  %4t ms: %p \n", $time, PANEL);
      
      #10ms PANEL = '{
        '{YEL, BLU, GRN, BLU}, '{GRN, YEL, GRN, BLU}
      };  
      
      $display("  %4t ms: %p \n", $time, PANEL);
      
      #10ms PANEL = '{
        '{YEL, BLU, GRN, BLU}, '{GRN, YEL, BLU, GRN}
      };  
      
      $display("  %4t ms: %p \n", $time, PANEL);
      
      #10ms PANEL = '{
        '{GRN, BLU, GRN, RED}, '{GRN, YEL, GRN, GRN}
      };  
      
      $display("  %4t ms: %p \n", $time, PANEL);
      
      #10ms PANEL = '{
        '{YEL, RED, GRN, BLU}, '{GRN, YEL, GRN, GRN}
      };  
      
      $display("  %4t ms: %p \n", $time, PANEL);
      
      #10ms PANEL = '{
        '{YEL, BLU, GRN, GRN}, '{GRN, YEL, RED, BLU}
      };  
      
      $display("  %4t ms: %p \n", $time, PANEL);
      
      $display("  TOTAL RED COUNT: %d", ALERTS);
      
      // Can't run waveforms
      //Approx: 19 GRN
      //Approx: 16 YEL
      //Approx: 6 RED
      //Rest BLU
      
      //WALK_RED(0, GRN);
      //$display(" H %4t ms: %p \n", $time, PANEL);
      
    end:UPDATE
  
  
  //walking red test: Making sure all 8 LEDs can go red/.
  
  //Walk a RED through one row of LEDs:
  task automatic WALK_RED (int ROW_arg, LED_t BKGND_arg);
    #10ms PANEL[ROW_arg] = '{LED_t: RED, default: BKGND_arg};
    //«Continue these keyed patterns for the remaining LEDs.»
    //«Final pattern to return all LEDs to background value.»
    
    PANEL[0] = '{LED_t: BKGND_arg, default: BKGND_arg};
    PANEL[1] = '{LED_t: BKGND_arg, default: BKGND_arg};
   endtask: WALK_RED     
      
      //Functions vs Tasks:
      //Functions can consume no time delay.


endmodule: LED_PANEL_TB

