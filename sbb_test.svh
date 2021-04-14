class sbb_test extends alu_base_test;
   `uvm_component_utils(sbb_test);
   
   sbb_sequence sbb_seq;

   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      sbb_seq.start(null);
      phase.drop_objection(this);
   endtask : run_phase


   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new

endclass