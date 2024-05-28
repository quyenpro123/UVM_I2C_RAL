
class test extends uvm_test;
  `uvm_component_utils(test)

  env ev;
  sequence_ seq;
  
  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_CLASS", "Build Phase!", UVM_MEDIUM)

    ev = env::type_id::create("ev", this);

  endfunction: build_phase

  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS", "Connect Phase!", UVM_MEDIUM)

  endfunction: connect_phase

  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("TEST_CLASS", "Run Phase!", UVM_MEDIUM)

    phase.raise_objection(this);
      //test_seq
      seq = sequence_::type_id::create("seq");
      seq.start(ev.agnt.seqr);
    
    phase.drop_objection(this);

  endtask: run_phase


endclass: test