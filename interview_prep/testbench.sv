/*
module top;
  
  initial 
    begin
      
      static int number = $urandom();
      static int count;
      
      //Number of ones in number
      count = $countones(number);
      
      $display("NUMBER: %0b", number);
      $display("COUNT: %0d", count);
    
  	end
endmodule:top
*/

class widget;
  int id;
  bit to_remove;
endclass:widget

module top;
  widget q[$];
  int num = $urandom_range(20, 40);
  
  //widget new_q[$];
  //int new_num_count = 0;
  //widget w_new;
  
  int new_num = 0;
  
  initial begin
    widget w;
    for(int i = 0; i < num; i++)
      begin
        w = new;
        w.id = i;
        w.to_remove = $urandom_range(0, 1);
        q.push_back(w);
        $display("widget id:%02d, to_remove: %b", q[$].id, q[$].to_remove);
      end

    //remove entries in q[$] that have to_remove;
    
    /*
    //Pop out everything in existing q.
    //Only add the ones that have ~to_remove into new_q.
    //Push everything from new_q back into q.
    //Change num to new_num_count.
    
    $display("\n----x----\n");
    for(int i = 0; i < num; i++)
      begin
        w_new = q.pop_front(); //queues are fifo
        if(w_new.to_remove == 0)
          begin
            $display("w_new: %d", w_new.id);
            new_q.push_back(w_new);
            new_num_count += 1;
          end
      end
    
    for(int i = 0; i < new_num_count; i++)
      begin
        w_new = new_q.pop_front();
        q.push_back(w_new);
      end
    
    num = new_num_count;
    //Check that no entry in q[$] has to_remove;
    for(int i = 0; i < num; i++)
      begin
        w = q.pop_front();
        if(w.to_remove == 1)
          $display("ERROR!");
        else
          $display("w: %d", w.id);
      end
    */
    
    //Simpler Solution
    for(int i = 0; i < q.size(); i++)
      begin
        $display("q[i].to_remove: %b", q[i].to_remove);
        if(q[i].to_remove == 1)
          begin
            q.delete(i);
            i--;
          end
      end
    
    for(int j = 0; j < q.size(); j++)
      begin
        if(q[j].to_remove == 1)
          $display("ERROR!: j = %0d", j);
        else
          $display("q[j] = %0d", q[j].id);
      end
    
  end
endmodule:top


