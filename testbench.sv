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

// playground copy of Ray's original is here: https://edaplayground.com/x/wTgG
package alu_pkg;
   import uvm_pkg::*;
`include "uvm_macros.svh"
   
      typedef enum bit[2:0] {
                      aluop_add = 3'b000,
        					 aluop_adc = 3'b001,
        					 aluop_sub = 3'b010,
        					 aluop_sbb = 3'b011,
        					 aluop_and = 3'b100,
        					 aluop_xor = 3'b101,
        					 aluop_or = 3'b110,
                      aluop_cmp = 3'b111} operation_t;
      
`include "sequence_item.svh"   
typedef uvm_sequencer #(sequence_item) sequencer;
   
`include "add_sequence_item.svh"
`include "adc_sequence_item.svh"
`include "and_sequence_item.svh"
`include "or_sequence_item.svh"
`include "xor_sequence_item.svh"
`include "sub_sequence_item.svh"
`include "sbb_sequence_item.svh"
`include "cmp_sequence_item.svh"

`include "adc_sequence.svh"
`include "cmp_sequence.svh"
`include "sub_sequence.svh"
`include "sbb_sequence.svh"
`include "or_sequence.svh"
`include "xor_sequence.svh"
`include "add_sequence.svh"
`include "cmp_sequence.svh"
`include "random_sequence.svh"
`include "runall_sequence.svh"
`include "short_random_sequence.svh"

`include "result_transaction.svh"
`include "coverage.svh"
`include "scoreboard.svh"
`include "driver.svh"
`include "command_monitor.svh"
`include "result_monitor.svh"
   
`include "env.svh"
`include "parallel_sequence.svh"

`include "alu_base_test.svh"
`include "full_test.svh"
`include "add_test.svh"
`include "adc_test.svh"
`include "and_test.svh"
`include "or_test.svh"
`include "xor_test.svh"
`include "sub_test.svh"
`include "sbb_test.svh"
`include "cmp_test.svh"
`include "parallel_test.svh"
   
endpackage : alu_pkg


interface alu_bfm;
   import alu_pkg::*;
/*
   byte         unsigned        A;
   byte         unsigned        B;
   bit          clk;
   bit          reset_n;
   wire [2:0]   op;
   bit          start;
   wire         done;
   wire [15:0]  result;
*/
  
   // alu for 8080
   // I'm going to add a clk
   byte unsigned		opra;
   byte unsigned		oprb;
   bit         clk;
   bit			cin;
   wire        cout;
   wire			zout;
   wire			sout;
   wire			parity;
   wire			auxcar;
   wire [2:0]	sel;  // op
   wire [7:0]  res;  // result
  
  typedef enum bit[2:0] operation_t  op_set;

   assign sel = op_set;

  // do we have a done signal in our design? no we don't
  task send_op(input byte iA, input byte iB, input alu_cin, input operation_t iop, output shortint alu_result,
               output bit alu_cout, output bit alu_zout, output bit alu_sout,
               output bit alu_parity, output bit alu_auxcar);

         @(negedge clk);
         op_set = iop;
         A = iA;
         B = iB;
         cin = alu_cin;
         //do begin
           @(negedge clk);
           @(negedge clk);  // let's give him one more cycle
            //while (done == 0); // how do we know when we are done?
            // I think all ops take one cycle
            cout = alu_cout;
            zout = alu_zout;
            sout = alu_sout;
            parity = alu_parity;
            auxcar = alu_auxcar;
            res = alu_result;
         //end
      
   endtask : send_op
   
   command_monitor command_monitor_h;

   function operation_t op2enum();
      case(sel)
        3'b000 : return aluop_add;
        3'b001 : return aluop_adc;
        3'b010 : return aluop_sub;
        3'b011 : return aluop_sbb;
        3'b100 : return aluop_and;
        3'b101 : return aluop_xor;
        3'b110 : return aluop_or;
        3'b111 : return aluop_cmp;
        default : $fatal("Illegal operation on op bus");
      endcase // case (sel)
   endfunction : op2enum


   always @(posedge clk) begin : op_monitor
      static bit in_command = 0;
      if (start) begin : start_high
        if (!in_command) begin : new_command
           command_monitor_h.write_to_monitor(A, B, cin, op2enum());
           in_command = (op2enum() != no_op);
        end : new_command
      end : start_high
      else // start low
        in_command = 0;
   end : op_monitor

   /* shouldn't we have a reset being passed into the ALU?

   always @(negedge reset_n) begin : rst_monitor
      if (command_monitor_h != null) //guard against VCS time 0 negedge
        command_monitor_h.write_to_monitor($random,0,rst_op);
   end : rst_monitor
   */
           
   result_monitor  result_monitor_h;

   initial begin : result_monitor_thread
      forever begin : result_monitor_block
         @(posedge clk) ;
         // we don't have done in our design, so have to 
         // figure out when we are - one cycle, two cycle?
         //if (done) 
           result_monitor_h.write_to_monitor(result);
      end : result_monitor_block
   end : result_monitor_thread
   

   initial begin
      clk = 0;
      fork
         forever begin
            #10;
            clk = ~clk;
         end
      join_none
   end

endinterface: alu_pkg

module top
   import uvm_pkg::*;
   import   alu_pkg::*;
   //`include "alu_macros.svh" -  file is empty
   include "uvm_macros.svh"
   
   alu_bfm       bfm();
   alu DUT (.opra(bfm.opra), .oprb(bfm.oprb), .cin(bfm.cin), 
                .cout(bfm.cout), .zout(bfm.zout), 
                .sout(bfm.sout), .parity(bfm.parity), .auxcar(bfm.auxcar),
                .sel(bfm.sel), .res(bfm.res));


initial begin
   uvm_config_db #(virtual alu_bfm)::set(null, "*", "bfm", bfm);
   run_test();
end
  
initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
end

endmodule : top