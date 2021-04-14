/*
   Copyright 2013 Ray Salemi

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
class runall_sequence extends uvm_sequence #(uvm_sequence_item);
   `uvm_object_utils(runall_sequence);

   protected or_sequence or;
   protected and_sequence and;
   protected add_sequence add;
   protected adc_sequence adc;
   protected sub_sequence sub;
   protected sbb_sequence sbb;
   protected xor_sequence xor;
   protected cmp_sequence cmp;
   protected random_sequence random;
   protected sequencer sequencer_h;
   protected uvm_component uvm_component_h;
   
 function new(string name = "runall_sequence");
   super.new(name);
    
    uvm_component_h =  uvm_top.find("*.env_h.sequencer_h");

    if (uvm_component_h == null)
     `uvm_fatal("RUNALL SEQUENCE", "Failed to get the sequencer")

    if (!$cast(sequencer_h, uvm_component_h))
      `uvm_fatal("RUNALL SEQUENCE", "Failed to cast from uvm_component_h.")
      
    or = or_sequence::type_id::create("or");
    and = and_sequence::type_id::create("and");
    add = add_sequence::type_id::create("add");
    //adc = adc_sequence::type_id::create("adc");
    sub = sub_sequence::type_id::create("sub");
    //sbb = sbb_sequence::type_id::create("sbb");
    xor = xor_sequence::type_id::create("xor");
    //cmp = cmp_sequence::type_id::create("cmp");
    random = random_sequence::type_id::create("random");
 endfunction : new

 task body();
    or.start(sequencer_h);
    and.start(sequencer_h);
    add.start(sequencer_h);
    //adc.start(sequencer_h);
    sub.start(sequencer_h);
    //sbb.start(sequencer_h);
    xor.start(sequencer_h);
    //cmp.start(sequencer_h);
    random.start(sequencer_h);
 endtask : body
   
endclass : runall_sequence



