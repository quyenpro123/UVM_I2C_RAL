class driver extends uvm_driver#(packet);
  `uvm_component_utils(driver)
  
  virtual intf intf;
  packet item;
  

  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRIVER_CLASS", "Build Phase!", UVM_MEDIUM)
    
    if(!(uvm_config_db #(virtual intf)::get(this, "*", "intf", intf))) begin
      `uvm_error("DRIVER_CLASS", "Failed to get intf from config DB!")
    end
    
  endfunction: build_phase
  

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("DRIVER_CLASS", "Connect Phase!", UVM_MEDIUM)
    
  endfunction: connect_phase
  

  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("DRIVER_CLASS", "Inside Run Phase!", UVM_MEDIUM)
    
    forever begin
      item = packet::type_id::create("item"); 
      seq_item_port.get_next_item(item);
      drive(item);
      seq_item_port.item_done();
    end
  endtask: run_phase

  task drive(packet item)
    @(posedge intf.pclk);
    intf.paddr <= item.paddr;
    intf.pwdata <= item.pwdata;
    intf.psel <= item.psel;
    intf.penable <= item.penable;
    intf.pwrite <= item.pwrite;
  endtask
  
endclass: driver