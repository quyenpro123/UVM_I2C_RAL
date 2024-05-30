`ifndef DRIVER
`define DRIVER
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
    intf.pwdata <= 0;
    intf.pwrite <= 0;
    intf.paddr <= 0;
    intf.psel <= 0;
    intf.penable <= 0;
    reset();
    forever begin
      logic [7:0] prdata;
      item = packet::type_id::create("item"); 
      seq_item_port.get_next_item(item);
      if (item.pwrite == 1)
        write(item.paddr, item.pdata);
      else
      begin
        read(item.paddr, prdata);
        item.pdata = prdata;
      end
      seq_item_port.item_done();
    end
  endtask: run_phase

  virtual task read(input logic [7:0] paddr, output logic [7:0] prdata);
    @(posedge intf.pclk);
    intf.psel <= 1;
    intf.paddr <= paddr;
    intf.pwrite <= 0;
    @(posedge intf.pclk);
    intf.penable <= 1;
    @(posedge intf.pclk);
    intf.penable <= 0;
    intf.psel <= 0;
    prdata = intf.prdata;
  endtask

  virtual task write(input logic [7:0] paddr, input logic [7:0] pwdata);
    @(posedge intf.pclk);
    intf.psel <= 1;
    intf.paddr <= paddr;
    intf.pwdata <= pwdata;
    intf.pwrite <= 1;
    @(posedge intf.pclk);
    intf.penable <= 1;
    @(posedge intf.pclk);
    intf.penable <= 0;
    intf.psel <= 0;
  endtask
  

  virtual task reset();
    @(posedge intf.pclk);
    intf.preset <= 0;
    @(posedge intf.pclk);
    intf.preset <= 1;
  endtask
endclass: driver
`endif