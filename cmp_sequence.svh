class cmp_sequence extends uvm_sequence #(sequence_item);
   `uvm_object_utils(add_sequence);

   sequence_item command;

   function new(string name = "cmp");
      super.new(name);
   endfunction : new


   task body();
      repeat (10) begin
         command = cmp_sequence_item::type_id::create("command");
         start_item(command);
         assert(command.randomize());
         finish_item(command);
      end 
   endtask : body
endclass : cmp_sequence
