`ifndef MON
`define MON
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
      forever
      begin
        @(posedge intf.pclk);
        if (intf.psel & intf.penable & intf.preset)
        begin
          item = packet::type_id::create("item");
          item.paddr = intf.paddr;
          item.pwrite = intf.pwrite;
          if (item.pwrite)
          begin
            item.pdata = intf.pwdata;
            `uvm_info("MONITOR_CLASS", $sformatf("WRITE item addr %0h data %0h", item.paddr, item.pdata), UVM_MEDIUM)
          end
          else
            item.pdata = intf.prdata;
          monitor_port.write(item);
          // `uvm_info("MONITOR_CLASS", "write transaction!", UVM_MEDIUM)
        end
      end

  endtask: run_phase
endclass: monitor
`endif