// Code your design here
//Unit-scope items:
timeunit 1ms;
timeprecision 1us;

module SIREN(); 
  //Audio output signal:
  bit AUDIO_OUT;
  //Half-period, with initial value:
  realtime Thalf = 1ms;
  realtime Tfull;

  //Highest and lowest period:
  parameter realtime Tmax = 0.001ms, Tmin = 0.005ms; 
  //LOWEST: 200 Hz
  //f = 1 / T
  //200 = 1 / T
  // T = 0.005 ms
  //HIGHEST: 1000 Hz.
  //T = 1 / 1000
  //
  //A derived parameter:
  parameter realtime Tdelta = Tmax - Tmin; 

  initial
    repeat(3) begin
      begin:SAWTOOTH
        //Falling segment of sawtooth: 
        begin:FALLING
          for (real N = 0; N < 50.0; N++)
            begin:INC

              //TFULL
              Tfull = (Tdelta / 50.0) * N + Tmin;
              Thalf = Tfull / 2;
              /* Expression to compute Thalf. */
              #(Thalf) AUDIO_OUT = 1'b1;
              #(Thalf) AUDIO_OUT = 1'b0;
              $write(" TFALL: %4.2f ms\n", Tfull);
            end:  INC
        end:  FALLING
        //RISING
        begin: RISING
          for(real N = 0; N < 50.0; N++)
            begin:DEC
              Tfull = (-1 * (Tdelta / 50.0)) * N + Tmax;
              Thalf = Tfull / 2;
              #(Thalf) AUDIO_OUT = 1'b1;
              #(Thalf) AUDIO_OUT = 1'b0;
              $write(" TRISE: %4.2f ms\n", Tfull);
            end:DEC
        end: RISING
      end:  SAWTOOTH
    end
	//RISING has to be opposite of FALLING. y = -mx + b.
  //OUT is a little bit off: TFALL ends at 1000ms but TRISE starts at 1080ms. Just one iter off. 
  //Unable to view waveforms. 
  
  //I tried adding mistake from Part E, but it didn't change my output much. Only difference I noticed was TFALL ends at 1080ms but TRISE starts at 1000ms. It will reverse it. Once agian, one iteration off. 
  
  //The reason I see no difference is because I have N declared as a real datatype. I also have N < 50.0.
endmodule: SIREN 
