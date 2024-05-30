`ifndef SEQR
`define SEQR
class sequencer extends uvm_sequencer#(packet);
  `uvm_component_utils(sequencer)
  
  
  function new(string name = "sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SEQR_CLASS", "Build Phase!", UVM_MEDIUM)
  endfunction: build_phase
  
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SEQR_CLASS", "Connect Phase!", UVM_MEDIUM)
  endfunction: connect_phase
  
endclass: sequencer
`endif