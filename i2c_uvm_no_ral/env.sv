
class env extends uvm_env;
  `uvm_component_utils(env)
  
  agent agnt;
  scoreboard scb;
  
  
  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV_CLASS", "Build Phase!", UVM_MEDIUM)
    
    agnt = agent::type_id::create("agnt", this);
    scb = scoreboard::type_id::create("scb", this);
    
    
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("ENV_CLASS", "Connect Phase!", UVM_MEDIUM)
    
    agnt.mon.monitor_port.connect(scb.scoreboard_port);
  endfunction: connect_phase
  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
  endtask: run_phase
  
  
endclass: env