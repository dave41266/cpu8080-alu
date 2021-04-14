
class adc_sequence extends uvm_sequence #(sequence_item);
   `uvm_object_utils(adc_sequence);

   sequence_item command;

   function new(string name = "adc");
      super.new(name);
   endfunction : new


   task body();
      repeat (10) begin
         command = adc_sequence_item::type_id::create("command");
         start_item(command);
         assert(command.randomize());
         finish_item(command);
      end 
   endtask : body
endclass : adc_sequence











