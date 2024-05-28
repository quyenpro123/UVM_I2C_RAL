
class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  driver drv;
  monitor mon;
  sequencer seqr;

  function new(string name = "agent", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGENT_CLASS", "Build Phase!", UVM_MEDIUM)
    
    drv = driver::type_id::create("drv", this);
    mon = monitor::type_id::create("mon", this);
    seqr = sequencer::type_id::create("seqr", this);
    
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT_CLASS", "Connect Phase!", UVM_MEDIUM)
    
    drv.seq_item_port.connect(seqr.seq_item_export);
    
  endfunction: connect_phase
  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("AGENT_CLASS", "Run Phase!", UVM_MEDIUM)
  endtask: run_phase
  
  
endclass: agent