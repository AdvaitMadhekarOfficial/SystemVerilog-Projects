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

  class LED_PANEL;
    
    covergroup CVG;
      LED11: coverpoint PANEL[1][1];
      LED12: coverpoint PANEL[1][2];
      LED13: coverpoint PANEL[1][3];
      LED14: coverpoint PANEL[1][4];
      LED21: coverpoint PANEL[2][1];
      LED22: coverpoint PANEL[2][2];
      LED23: coverpoint PANEL[2][3];
      LED24: coverpoint PANEL[2][4];
      COMBS: cross LED11, LED12, LED13, LED14, LED21, LED22, LED23, LED24;
    endgroup: CVG 
    
    //covergroup
    //Allows you to cover class's own variables, and offers a shortcut 
    //CVG is a special-purpose class, so needs to be constructed. 
    
    function new();
      CVG = new();
    endfunction: new

    //A random variable:
    rand PANEL_t PANEL; //rand will automatically randomize when randomize() invoked.
    
    int ALERTS = 0;
    bit DANGER;

    //Count up red alerts:
    task TALLY_RED();
      DANGER = RED inside {PANEL};
      if (DANGER) ++ALERTS;
      CVG.sample();
    endtask: TALLY_RED
    
    //Constrain a single LED:
    constraint COLOR_con {
      foreach(PANEL[J,K])
        PANEL[J][K] dist {
          BLU := 30,
          GRN := 40,
          YEL := 25,
          RED :=  5
        };   // 100 total.
    }
    
    
    task WALK_RED (int ROW_arg, LED_t BKGND_arg);
      #10ms PANEL[ROW_arg] = '{LED_t: RED, default: BKGND_arg};
      //«Continue these keyed patterns for the remaining LEDs.»
      //«Final pattern to return all LEDs to background value.»

      PANEL[0] = '{LED_t: BKGND_arg, default: BKGND_arg};
      PANEL[1] = '{LED_t: BKGND_arg, default: BKGND_arg};
     endtask: WALK_RED     
    
    //Methods of a class are by default automatic
    //automatic keyword after task allows you to make task asynchronous.

  endclass: LED_PANEL


endpackage: LED_PKG

module LED_PANEL_TB();

  //Wildcard import of all packaged items:
  import LED_PKG::*;
  
  LED_PANEL LP; 
  //LP is an address pointer to block of memory allocated for this object and all it's data.
  //The default initial value of pointer is NULL. No memory has been allocated to it yet. You can allocate the memory using new() func.
  
  
  initial
    begin:SUITE
      LP = new();  
      
      
      fork:WALK
        LP.WALK_RED(0, GRN);
        LP.WALK_RED(1, YEL);
      join:WALK

      repeat (25)
        begin:TRIALS
          #10 LP.randomize();
          LP.TALLY_RED();
          //Construct new LP:
          $display(
            "%4t ms: %p  @'h%0h",  $time, LP.PANEL, LP
          );
        end:  TRIALS
        $display("  TOTAL RED COUNT: %d", LP.ALERTS);
        #10 $finish();
    end:SUITE
  
  final
  	begin:STATS
      LP.CVG.COMBS.get_coverage();
      $display(
        "  Coverage: %9.6f %%\n",
        LP.CVG.get_coverage()
      );
    end:STATS
  
  
  //This will create five seperate objects of LP. We only need one for our case, so we don't need this loop:
  /*
  initial
      repeat (5)
      begin:TRIALS
      	//Construct new LP:
        #10 LP = new(); //
        $display(
          "%4t ms: %p  @'h%0h",  $time, LP.PANEL, LP
        );
      end:  TRIALS
      */

  /*
  always @(PANEL)
    begin:STATUS
      DANGER = RED inside {PANEL};
      if(DANGER)
        begin
          $display("DANGER!");
          ALERTS += 1;
        end
    end:  STATUS
  */
  
  //walking red test: Making sure all 8 LEDs can go red/.
  
  //Walk a RED through one row of LEDs:
  
  /*
  task automatic WALK_RED (int ROW_arg, LED_t BKGND_arg);
    #10ms PANEL[ROW_arg] = '{LED_t: RED, default: BKGND_arg};
    //«Continue these keyed patterns for the remaining LEDs.»
    //«Final pattern to return all LEDs to background value.»
    
    PANEL[0] = '{LED_t: BKGND_arg, default: BKGND_arg};
    PANEL[1] = '{LED_t: BKGND_arg, default: BKGND_arg};
   endtask: WALK_RED     
   */
      
      //Functions vs Tasks:
      //Functions can consume no time delay.


endmodule: LED_PANEL_TB

