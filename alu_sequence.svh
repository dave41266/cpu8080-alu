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
class alu_sequence extends uvm_sequence #(alu_sequence_item);

   alu_sequence_item command;
   
   task body();
      $fatal(1,"You cannot use alu_sequence directly. You must override it");
   endtask : body

endclass : alu_sequence






