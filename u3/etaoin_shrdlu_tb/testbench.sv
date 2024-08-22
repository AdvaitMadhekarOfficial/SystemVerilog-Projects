// Code your testbench here
// or browse Examples
module DECODER_TB();
  
  /*bit [7:0] TEXT_ONE [12] = '{
    "I", "A", "H", "U", "O", "T",
    "D", "N", "S", "L", "R", "E"
  };*/
  
  //Because of unique case statement, an unidentified CIPHER gives runtime warning message in VCS.
  
  //string TEXT = ""; // Not synthesizeable
  
  string TEXT [4] = '{
    "HAAITAOUTHRRETOAD",
    "HRISARHDISDHAIRROAIDAU",
    "DNUUAHRRAISSUSODALSUTID",
    "ITSUEAIAUTHAUOTDAHRRHAOUT"
  }; //Unpacked arr of strings. 
  
  ALPHA_T CIPHER, PLAIN;
  
  DECODER DUT(.CIPHER(CIPHER), .PLAIN(PLAIN));
  
  initial
    begin:SUITE
      $write("  Decoded message:\n");
      //TEXT_ONE
      /*for(int i = 0; i < 8; i++)
        begin
          //$write("TEXT_ONE[i]: %s\n", TEXT_ONE[i]);
          CIPHER = TEXT_ONE[i];
          //$write("CIPHER: %d\n", CIPHER);
          //#10 $write("PLAIN: %d\n", PLAIN);
          #10 $write("DEC: CIPHER: %d; PLAIN: %d\n", CIPHER, PLAIN);
          $write("HEX: CIPHER: %h; PLAIN: %h\n", CIPHER, PLAIN);
          //For some reason, string casting not working on VCS. Works on Xcelium.
        end*/
      for(int i = 0; i < 4; i++)
        begin
          for(int j = 0; j < TEXT[i].len(); j++)
            begin
              CIPHER = TEXT[i][j];
              #10 $display("%d", PLAIN);
            end
          $display("\n");
        end
    end:SUITE
  
  
endmodule
