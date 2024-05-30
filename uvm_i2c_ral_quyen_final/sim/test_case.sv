`ifndef TEST_CASE
`define TEST_CASE
// `include "env.sv"
class test extends uvm_test;
  `uvm_component_utils(test)

  env ev;
  `SEQ seq;
  
  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_CLASS", "Build Phase!", UVM_MEDIUM)
    seq = `SEQ::type_id::create("seq");
    ev = env::type_id::create("ev", this);

  endfunction: build_phase

  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS", "Connect Phase!", UVM_MEDIUM)

  endfunction: connect_phase

  
  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("TEST_CLASS", "Run Phase!", UVM_MEDIUM)
    phase.raise_objection(this);
      //test_seq
      seq.reg_model = ev.reg_model;
      seq.start(ev.agnt.seqr);
    phase.drop_objection(this);

  endtask: run_phase


endclass: test
`endif