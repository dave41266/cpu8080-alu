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
class sequence_item extends uvm_sequence_item;
   `uvm_object_utils(sequence_item);

   function new(string name = "");
      super.new(name);
   endfunction : new
   
   rand byte unsigned        A;
   rand byte unsigned        B;
   rand bit                 cin;
   bit                      cout,
   bit                      zout,
   bit                      sout,
   bit                      parity,
   bit                      auxcar,
   rand operation_t         sel;
   shortint  unsigned       res;

   constraint op_con {sel dist {aluop_add := 5, aluop_adc=5, aluop_and:=5, 
                               aluop_sub=5, aluop_sbb=5, aluop_xor:=5, aluop_cmp=5};}

   constraint data { A dist {8'h00:=1, [8'h01 : 8'hFE]:=1, 8'hFF:=1};
      B dist {8'h00:=1, [8'h01 : 8'hFE]:=1, 8'hFF:=1};} 
   
   function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      sequence_item tested;
      bit               same;
      
      if (rhs==null) `uvm_fatal(get_type_name(), 
                                "Tried to do comparison to a null pointer");
      
      if (!$cast(tested,rhs))
        same = 0;
      else
        same = super.do_compare(rhs, comparer) && 
               (tested.A == A) &&
               (tested.B == B) &&
               (tested.op == op) &&
               (tested.cin == cin) &&
               (tested.cout == cout) &&
               (tested.zout == zout) &&
               (tested.sout == sout) &&
               (tested.parity == parity) &&
               (tested.auxcar == auxcar) &&
               (tested.res == res);
      return same;
   endfunction : do_compare

   function void do_copy(uvm_object rhs);
      sequence_item RHS;
      assert(rhs != null) else
        $fatal(1,"Tried to copy null transaction");
      super.do_copy(rhs);
      assert($cast(RHS,rhs)) else
        $fatal(1,"Faied cast in do_copy");
      A = RHS.A;
      B = RHS.B;
      cin = RHS.cin;
      cout = RHS.cout;
      zout = RHS.zout;
      sout = RHS.sout;
      parity = RHS.parity;
      auxcar = RHS.auxcar;
      sel = RHS.sel;
      res = RHS.res;
   endfunction : do_copy

   function string convert2string();
      string            s;
      s = $sformatf("A: %2h  B: %2h cin  op: %s = %4h",
                    A, B, cin, op.name(), res);
      return s;
   endfunction : convert2string

endclass : sequence_item


