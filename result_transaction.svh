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
class result_transaction extends uvm_transaction;

   bit      cout;
   bit      zout;
   bit      sout;
   bit      parity;
   bit      auxcar;
   shortint res;

   function new(string name = "");
      super.new(name);
   endfunction : new


   function void do_copy(uvm_object rhs);
      result_transaction copied_transaction_h;
      assert(rhs != null) else
        $fatal(1,"Tried to copy null transaction");
      super.do_copy(rhs);
      assert($cast(copied_transaction_h,rhs)) else
        $fatal(1,"Faied cast in do_copy");

      cout = copied_transaction_h.cout;
      zout = copied_transaction_h.zout;
      sout = copied_transaction_h.sout;
      parity = copied_transaction_h.parity;
      auxcar = copied_transaction_h.auxcar;
      res = copied_transaction_h.res;
   endfunction : do_copy

   function string convert2string();
      string s;
      s = $sformatf("cout: %d zout: %d sout: %d parity: %d auxcar: %d result: %4h",
                     cout, zout, sout, parity, auxcar, res);
      return s;
   endfunction : convert2string

   function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      result_transaction RHS;
      bit    same;
      assert(rhs != null) else
        $fatal(1,"Tried to compare null transaction");

      same = super.do_compare(rhs, comparer);

      $cast(RHS, rhs);
      same = (res == RHS.res) &&
             (cout == RHS.cout) &&
             (zout == RHS.zout) &&
             (sout == RHS.sout) &&
             (parity == RHS.parity) &&
             (auxcar == RHS.auxcar) && same;
      return same;
   endfunction : do_compare
   
        

endclass : result_transaction

      
        
