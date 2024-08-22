// Code your testbench here
// or browse Examples

timeunit 1us;
timeprecision 1us;

//package lets you package definitions of subroutines, params, datatypes, ...etc.
//Makes them reusable across modules.

package MATH_PKG;
  parameter real PI = 3.14159;

function real ABS(real N_arg);
    if(N_arg < 0)
      ABS = -N_arg;
    else
      ABS = N_arg;
  endfunction:ABS

endpackage: MATH_PKG

//Functions are instantaneous, so use blocking statements instead of "<=" (nonblocking)

module FREQ_SPECTRA_TB();
  
  import MATH_PKG::*;
  
  struct {
    real AMPL; // Amplitude
    shortreal PHASE; // Radians
  } SPECTRA;
  
  
  initial
    begin:SUITE
      #1 SPECTRA = '{+0.20,  -1.5700};
      #1 SPECTRA = '{-0.20,  +4.7124};
      #1 SPECTRA = '{+0.16,  -5.4978};
      #1 SPECTRA = '{-0.14,  +7.0686};
      #1 SPECTRA = '{+0.07, +10.9956};
      #1 SPECTRA = '{-0.03, -10.9956};
    end:SUITE
  
  initial
    begin:PRINT
      #0.5;
      $monitor(
        "%4t us:  |AMPL| = %4.2f, PHASE = %6.4f",
        	$time, ABS(SPECTRA.AMPL), SPECTRA.PHASE/PI
      );
    end:PRINT
  
endmodule

//SV's % is only for ints.


/* (b) Compute the value of PHASE modulo PI.
* (E.g. 5PI/4 % PI --> PI/4). But since
* % only accepts integer values, we must
* convert from radians to degrees, then
* back again. Use the functions below:
*/
/*
  shortreal MOD_PHASE;
  assign MOD_PHASE = DEG2RAD(
   RAD2DEG(<<member PHASE>>) <<modulo PI>>
  );

 //Degrees per radian: 360/2*PI
 function shortreal DEG2RAD(int DEG_arg);
    return ( (PI/180.0) * DEG_arg );
  endfunction: DEG2RAD

 function int RAD2DEG(shortreal RAD_arg);
   return ( (<<radians_to_degrees>>) * RAD_arg );
  endfunction: RAD2DEG
*/
