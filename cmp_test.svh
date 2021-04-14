class cmp_test extends alu_base_test;
   `uvm_component_utils(cmp_test);
   
   cmp_sequence cmp_seq;

   task run_phase(uvm_phase phase);
      cmp_seq = new("cmp_seq");
      phase.raise_objection(this);
      cmp_seq.start(null);
      phase.drop_objection(this);
   endtask : run_phase


   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new

endclass