package TB_PKG;

  typedef struct {
    realtime RTIME; 
    int TAG;
    bit [1:0] READ_OR_WRITE;
    bit [15:0] DATA;
    bit QUEUE_EMPTY;
    bit QUEUE_FULL;
  } SCOREBOARD_OBJ;

  parameter int Nburst = 500;

  SCOREBOARD_OBJ scorecard[Nburst];
  int curr_ptr = 0;
  bit first_iter = 1'b1;

  typedef virtual BUS_IF VRWIF_t;
  
  import uvm_pkg::*;

  class DRIVER extends uvm_driver;
  
    VRWIF_t VRWIF;
    
    rand bit [1:0] READ_OR_WRITE;
    
    rand bit [15:0] DATA;
    
    //Makes sure Writes are 70% likely compared to reads
    constraint R_O_W_DECIDE {
      READ_OR_WRITE dist{
        2'b00 := 1, //HOLD
        2'b01 := 3, //WRITE
        2'b10 := 3, //READ
        2'b11 := 3  //BOTH
      };
    }
    
    function new(string INAME, VRWIF_t RWIF_arg);
      super.new(INAME, null);
      VRWIF = RWIF_arg;
    endfunction:new
    
    
    task NONE_DATA(int TAG);
      VRWIF.WR = 1'b0;
      VRWIF.RD = 1'b0;
      VRWIF.DIN = DATA;
      //bit [15:0] TEMP_DATA_OUT = VRWIF.DOUT;
      
      if(VRWIF.QUEUE_FULL == 1)
        begin
          scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, 16'b0, 0, 1};
          curr_ptr += 1;
        end
      else if(VRWIF.QUEUE_FULL == 0)
        begin
          scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, DATA, 0, 0};
          curr_ptr += 1;
        end
      
      //RD SCORECARD COND. QUEUE_EMPTY
      if(VRWIF.QUEUE_EMPTY)
        begin
          if(scorecard[curr_ptr - 1].DATA != VRWIF.DOUT && scorecard[curr_ptr - 1].QUEUE_EMPTY != 1)
            begin 
              scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, VRWIF.DOUT, 0, 0};
              curr_ptr += 1;
            end
          else
            begin
              scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, 16'b0, 1, 0};
              curr_ptr += 1;
            end
        end
      else
        begin
          scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, VRWIF.DOUT, 0, 0};
          curr_ptr += 1;
        end
      
      
    endtask:NONE_DATA
    
    task WRITE_AND_READ_DATA(int TAG);
      VRWIF.WR = 1'b1;
      VRWIF.RD = 1'b1;
      VRWIF.DIN = DATA;
      //bit [15:0] TEMP_DATA_OUT = VRWIF.DOUT;
      
      //WR SCORECARD COND. QUEUE_FULL
      if(VRWIF.QUEUE_FULL == 1)
        begin
          scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, 16'b0, 0, 1};
          curr_ptr += 1;
        end
      else if(VRWIF.QUEUE_FULL == 0)
        begin
          scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, DATA, 0, 0};
          curr_ptr += 1;
        end
      
      //RD SCORECARD COND. QUEUE_EMPTY
      if(VRWIF.QUEUE_EMPTY)
        begin
          if(scorecard[curr_ptr - 1].DATA != VRWIF.DOUT && scorecard[curr_ptr - 1].QUEUE_EMPTY != 1)
            begin 
              scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, VRWIF.DOUT, 0, 0};
              curr_ptr += 1;
            end
          else
            begin
              scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, 16'b0, 1, 0};
              curr_ptr += 1;
            end
        end
      else
        begin
          scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, VRWIF.DOUT, 0, 0};
          curr_ptr += 1;
        end
      
    endtask:WRITE_AND_READ_DATA
    
    task WRITE_DATA(int TAG);
      VRWIF.WR = 1'b1;
      VRWIF.RD = 1'b0;
      VRWIF.DIN = DATA;
      if(VRWIF.QUEUE_FULL)
        begin
          scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, 16'b0, 0, 1};
          curr_ptr += 1;
        end
      else
        begin
          scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, DATA, 0, 0};
          curr_ptr += 1;
        end
    endtask:WRITE_DATA;
    
    task READ_DATA(int TAG);
      VRWIF.RD = 1'b1;
      VRWIF.WR = 1'b0;
      
      if(VRWIF.QUEUE_EMPTY)
        begin
          if(scorecard[curr_ptr - 1].DATA != VRWIF.DOUT && scorecard[curr_ptr - 1].QUEUE_EMPTY != 1)
            begin 
              scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, VRWIF.DOUT, 0, 0};
              curr_ptr += 1;
            end
          else
            begin
              scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, 16'b0, 1, 0};
              curr_ptr += 1;
            end
        end
      else
        begin
          scorecard[curr_ptr] = '{$time, TAG, READ_OR_WRITE, VRWIF.DOUT, 0, 0};
          curr_ptr += 1;
        end
    endtask:READ_DATA;
    
    task ENV_OF_TASKS;
      for(int i = 0; i < Nburst; i++)
        begin
          this.randomize();
          //READ_OR_WRITE = 1'b1;
          if(READ_OR_WRITE == 2'b01) // READ
            begin:CALL_READ
              #20ms
              this.READ_DATA(i);
            end:CALL_READ
          else if(READ_OR_WRITE == 2'b10) //WRITE
            begin:CALL_WRITE
              #20ms
              this.WRITE_DATA(i);
            end:CALL_WRITE
          else if(READ_OR_WRITE == 2'b11) //BOTH
            begin:CALL_BOTH
              #20ms
              WRITE_AND_READ_DATA(i);
            end:CALL_BOTH
          
          
        end
    endtask:ENV_OF_TASKS;
  
  endclass: DRIVER

  class MONITOR extends uvm_monitor;
    
    VRWIF_t VRWIF;
    
    function new(string INAME, VRWIF_t RWIF_arg);
      super.new(INAME, null);
      VRWIF = RWIF_arg;
    endfunction:new
  	
    task DISPLAY_RESULTS;
      $display("@ TIME TAG READ_OR_WRITE DATA QUEUE_EMPTY QUEUE_FULL");
      for(int i = 0; i < Nburst; i++)
        begin
          if(scorecard[i].QUEUE_EMPTY == 1)
            begin
              $display("ERROR: FIFO EMPTY");
            end
          else if(scorecard[i].QUEUE_FULL == 1)
            begin
              $display("ERROR: FIFO FULL");
            end
          else
            begin
              $display("@ %d, %d :: %2b :: %4h", scorecard[i].RTIME, scorecard[i].TAG, scorecard[i].READ_OR_WRITE, scorecard[i].DATA);
            end
        end
      //DUMP SCOREBOARD
      $display("\n\nSCORECARD: \n\n%p", scorecard);
    endtask:DISPLAY_RESULTS;
  	
  endclass: MONITOR


  class ENVIRONMENT extends uvm_env;
  
    DRIVER DRV;
    MONITOR MON;
    
    VRWIF_t VRWIF;
    
    function new(string INAME, VRWIF_t RWIF_arg);
      super.new(INAME, null);
      VRWIF = RWIF_arg;
      DRV = new("DRIVER", RWIF_arg);
      MON = new("MONITOR", RWIF_arg);
    endfunction:new
    
  endclass: ENVIRONMENT

endpackage: TB_PKG;


module FIFO_32x16_TB;
  
  import TB_PKG::*;
  
  bit CLK = 1'b0;
  
  BUS_IF RWIF(CLK);
  
  FIFO_32x16 DUT(.IO_DATA(RWIF));
  
  ENVIRONMENT ENV;
  
  initial
    begin:TEST_SUITE
      ENV = new("ENVIRONMENT", RWIF);
      
      ENV.DRV.randomize();
      
      ENV.DRV.ENV_OF_TASKS();
      ENV.MON.DISPLAY_RESULTS();
      $display("\n\nFIFO_STACK: \n\n%p\nWR_PTR: %5b\nRD_PTR: %5b\n\n\n", DUT.FIFO_STACK, DUT.WR_PTR, DUT.RD_PTR);
    end:TEST_SUITE
  
  //CLK GEN
  initial
    repeat(Nburst)
      begin:CLOCK
        #10 CLK = 1'b1;
        #10 CLK = 1'b0;
      end:CLOCK  
  
endmodule

