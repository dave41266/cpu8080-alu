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
class runall_sequence extends alu_sequence;
   `uvm_object_utils(runall_sequence);

   add_sequence add;
   sub_sequence sub;
   random_sequence random;
   
   task body();
      add = add_sequence::type_id::create("add");
      sub = sub_sequence::type_id::create("sub");

      // we will get all of our sequences in here
      random = random_sequence::type_id::create("random");

      add.start(m_sequencer);
      sub.start(m_sequencer);
      random.start(m_sequencer);
   endtask : body
endclass : runall_sequence

     