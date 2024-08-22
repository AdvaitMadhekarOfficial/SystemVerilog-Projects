// Code your design here

module MPEG_ZIGZAG();
  
  /* SAMPLE COEFFICIENT BLOCK */
  shortint COEFF_BLOCK[0:7][0:7] = '{
    '{-22,  17,  01,  01,  00,  00,  00,  00},
    '{-21, -15,  01,  00,  00,  00,  00,  00},
    '{ 11,  03, -04,  00,  00,  00,  00,  00},
    '{-03,  02,  02,  00,  00,  00,  00,  00},
    '{ 00, -01, -01,  00,  00,  00,  00,  00},
    '{ 00,  00,  00,  00,  00,  00,  00,  00},
    '{ 00,  00,  00,  00,  00,  00,  00,  00},
    '{ 00,  00,  00,  00,  00,  00,  00,  00}
  };
  /* STREAM VECTOR TO DISK */
  typedef  shortint STREAM_t[64];  //Type.
  
  STREAM_t   STREAM_OUT;    //Variable of type.

  /* ZIG-ZAG INDEXING  */
  shortint INDEX_BLOCK[0:7][0:7] = '{
    '{00, 01, 05, 06, 14, 15, 27, 28},
    '{02, 04, 07, 13, 16, 26, 29, 42},
    '{03, 08, 12, 17, 25, 30, 41, 43},
    '{09, 11, 18, 24, 31, 40, 44, 53},
    '{10, 19, 23, 32, 39, 45, 52, 54},
    '{20, 22, 33, 38, 46, 51, 55, 60},
    '{21, 34, 37, 47, 50, 56, 59, 61},
    '{35, 36, 48, 49, 57, 58, 62, 63}
  };
  initial
    begin:INSERT
      //Insertion algorithm:
      shortint COEFF; //A DCT coefficient.
      shortint INDEX; //A stream position.
      
      
      for(int i = 0; i < 8; i++)
        begin:VISIT_OUT
          for(int j = 0; j < 8; j++)
            begin:VISIT_IN
              INDEX = INDEX_BLOCK[i][j];
              COEFF = COEFF_BLOCK[i][j];
              
              //$write("COEFF: %d\n", COEFF);
              //$write("INDEX: %d\n", INDEX);

              STREAM_OUT[INDEX] = COEFF;
              //$write("STREAM_OUT[INDEX]: %d\n", STREAM_OUT[INDEX]);
            end:  VISIT_IN
        end: VISIT_OUT
      
      
      //$write("STREAM_OUT: %p\n", STREAM_OUT);
      PRINT(STREAM_OUT);
    end:  INSERT
  
  task PRINT(
    STREAM_t  STREAM_OUT
  );
    $write("%s ------x PRINTING STREAM_OUT x------\n", {40{" "}});
    for(int i = 0; i < 64; i++)  
      begin:LINE
        //Print one line of 8x8 block:
        $write("%d ", STREAM_OUT[i]); //Omit \n.
        //Skip to next line:
        if ((i % 8) == 7)
          $write("\n"); 
      end:  LINE
  endtask: PRINT
  
  
  
  
  
  
endmodule: MPEG_ZIGZAG
