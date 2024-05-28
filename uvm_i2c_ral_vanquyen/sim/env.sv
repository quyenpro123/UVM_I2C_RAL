`ifndef ENV
`define ENV
`include "subscriber.sv"
class env extends uvm_env;
  `uvm_component_utils(env)
  
  virtual intf intf;

  agent agnt;
  scoreboard scb;
  i2c_reg_block reg_model;
  uvm_reg_predictor #(packet) predictor;
  reg_adapter adapter;
  subscriber subc;
  int i, j;

  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV_CLASS", "Build Phase!", UVM_MEDIUM)
    uvm_config_db #(virtual intf)::get(this, "*", "intf", intf);
    agnt = agent::type_id::create("agnt", this);
    scb = scoreboard::type_id::create("scb", this);
    subc = subscriber::type_id::create("subc", this);

    reg_model = i2c_reg_block::type_id::create("reg_model", this);
    predictor = uvm_reg_predictor #(packet)::type_id::create("predictor", this);
    adapter = reg_adapter::type_id::create("adapter", this);

    reg_model.build();
    reg_model.lock_model();

  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("ENV_CLASS", "Connect Phase!", UVM_MEDIUM)

    agnt.mon.monitor_port.connect(scb.scoreboard_port);
    agnt.mon.monitor_port.connect(subc.sub_port);

    reg_model.default_map.set_base_addr(0);
    reg_model.default_map.set_sequencer(agnt.seqr, adapter);

    predictor.map = reg_model.default_map;
    predictor.adapter = adapter;
    agnt.mon.monitor_port.connect(predictor.bus_in);
    scb.reg_model = reg_model;
    uvm_config_db #(i2c_reg_block)::set (null, "*", "reg_model", reg_model);
  endfunction: connect_phase

  virtual task run_phase (uvm_phase phase);
    super.run_phase(phase);

    fork
      forever
        begin
            @(negedge intf.data_slave_read_valid)
            begin
                if (intf.data_slave_read != 0)
                begin
                  scb.data_slave_read.push_back(intf.data_slave_read);
                  `uvm_info("ENV_CLASS", $sformatf("I2C slave read data %0h from I2C master", intf.data_slave_read), UVM_LOW)
                end
            end
        end
    join_none
  endtask: run_phase

endclass: env
`endif