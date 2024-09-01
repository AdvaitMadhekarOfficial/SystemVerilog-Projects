`timescale 1ms/1ms

interface BUS_IF(
  input bit CLK
);
  bit WR;
  bit RD;
  bit [15:0] DOUT;
  bit [15:0] DIN;
  bit QUEUE_EMPTY;
  bit QUEUE_FULL;
endinterface:BUS_IF


module FIFO_32x16 #(parameter N = 32)(BUS_IF IO_DATA);

  bit [15:0] FIFO_STACK[N]; //Datastorage
  bit [4:0] RD_PTR = 5'b00000;
  bit [4:0] WR_PTR = 5'b00000;
  bit QUEUE_FIRST_ITER = 1'b0;
  bit [4:0] QUEUE_OCCUPANCY = 5'b0;
  
  wire W_QUEUE_EMPTY; 
  wire W_QUEUE_FULL;
  
  /*initial
    begin
      RD_PTR = 0;
      WR_PTR = 0;
    end
   */

  assign W_QUEUE_EMPTY = (QUEUE_OCCUPANCY == 0);
  assign W_QUEUE_FULL = (QUEUE_OCCUPANCY == (N - 1));
  
  assign IO_DATA.QUEUE_EMPTY = W_QUEUE_EMPTY;
  assign IO_DATA.QUEUE_FULL = W_QUEUE_FULL;

  //UPDATE VARS
  always @(posedge IO_DATA.CLK)
    begin:UPDATE
      //QUEUE_EMPTY = (WR_PTR == RD_PTR);
      //QUEUE_EMPTY = (QUEUE_OCCUPANCY == 0);
      
      //QUEUE_FULL = (WR_PTR == RD_PTR - 1) & ~QUEUE_EMPTY;
      //QUEUE_FULL = (QUEUE_OCCUPANCY == N);
      //IO_DATA.QUEUE_FULL = QUEUE_FULL;
      
      if(WR_PTR == N)
        WR_PTR = 5'b0;
      if(RD_PTR == N)
        RD_PTR = 5'b0;
    end:UPDATE
  
  //READ OPERATION
  always @(posedge IO_DATA.CLK)
    begin
      if(IO_DATA.RD)
        begin
          $write("\nRDPTR: %d\nQE: %b\nFS[RP]: %4h\n==x==\n", RD_PTR, W_QUEUE_EMPTY, FIFO_STACK[RD_PTR]);
          if(W_QUEUE_EMPTY == 0)
            begin
              //$write("\nENTRY\n==x==\n");
              IO_DATA.DOUT = FIFO_STACK[RD_PTR];
              RD_PTR = RD_PTR + 1;
              QUEUE_OCCUPANCY = QUEUE_OCCUPANCY - 1;
            end
        end
    end

  always @(posedge IO_DATA.CLK) begin
    $display (" RD = %0b WR = %0b WR_PTR = %0d RD_PTR = %0d FULL = %0b EMPTY = %0b OCCPUANCY = %0d \n", IO_DATA.RD, IO_DATA.WR, WR_PTR , RD_PTR, W_QUEUE_FULL, W_QUEUE_EMPTY, QUEUE_OCCUPANCY );
  end  
  
  //WRITE OPERATION
  always @(posedge IO_DATA.CLK)
    if(IO_DATA.WR)
      begin
        if(W_QUEUE_FULL == 0)
          begin
            FIFO_STACK[WR_PTR] = IO_DATA.DIN;
            WR_PTR = WR_PTR + 1;
            QUEUE_OCCUPANCY += 1;
          end
      end



endmodule
