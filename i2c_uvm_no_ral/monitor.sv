
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  virtual intf intf;
  packet item;
  
  uvm_analysis_port #(packet) monitor_port;
  
  
  function new(string name = "monitor", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MONITOR_CLASS", "Build Phase!", UVM_MEDIUM)
    
    monitor_port = new("monitor_port", this);
    
    if(!(uvm_config_db #(virtual intf)::get(this, "*", "intf", intf))) begin
      `uvm_error("MONITOR_CLASS", "Failed to get intf from config DB!")
    end
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MONITOR_CLASS", "Connect Phase!", UVM_MEDIUM)
  endfunction: connect_phase
  

  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("MONITOR_CLASS", "Inside Run Phase!", UVM_MEDIUM)
    
    // forever begin
    //   item = packet::type_id::create("item");
            
    //   //sample inputs
    //   @(posedge intf.clock);
    //   item.a = intf.a;
    //   item.b = intf.b
      
    //   //sample output
    //   @(posedge intf.clock);
    //   item.c = intf.c;
      
    //   // send item to scoreboard
    //   monitor_port.write(item);
    end
        
  endtask: run_phase
  
  
endclass: monitor