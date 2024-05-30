`ifndef SCB
`define SCB
class scoreboard extends uvm_component;
  `uvm_component_utils(scoreboard)
  logic check_data;
  i2c_reg_block reg_model;
  logic [7:0] data_slv;
  logic [7:0] data_mas;
  logic [7:0] data_slave_read[$];
  logic [7:0] data_apb_master_send[$];

  uvm_reg_data_t mirror_data;
  uvm_analysis_imp #(packet, scoreboard) scoreboard_port;
  int i;
  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB_CLASS", "Build Phase!", UVM_MEDIUM)
   
    scoreboard_port = new("scoreboard_port", this);
  endfunction: build_phase
  
  //compare data i2c master sent to data i2c slave received
  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    // `uvm_info("SCOREBOARD_CLASS", $sformatf("data size APB: %d", data_apb_master_send.size()), UVM_LOW)
    // `uvm_info("SCOREBOARD_CLASS", $sformatf("data size slave: %d", data_slave_read.size()), UVM_LOW)
    //if ((data_apb_master_send.size() == data_slave_read.size()) && data_slave_read.size() != 0)
    // foreach(data_apb_master_send[j]) begin
    //   if (data_apb_master_send[j] == 0)
    //     data_apb_master_send.delete(j);
    // end
    if ((data_apb_master_send.size() == data_slave_read.size()) && data_slave_read.size() != 0)
    begin
      foreach (data_apb_master_send[j]) begin
        assert (data_apb_master_send[j] == data_slave_read[j]) $display("SCOREBOARD_CLASS ASSERTION, Slave received successfully data %0h", data_apb_master_send[j]); else  
          $error("%d SCOREBOARD_CLASS ASSERTION, Slave received unsuccessfully data %0h, actual data %0h", $time, data_apb_master_send[j], data_slave_read[j]);
      end
    end

    foreach(data_apb_master_send[j]) begin
      `uvm_info("SCOREBOARD_CLASS", $sformatf("data APB: %h", data_apb_master_send[j]), UVM_LOW)
    end

    foreach(data_slave_read[j]) begin
      `uvm_info("SCOREBOARD_CLASS", $sformatf("data SLAVE: %h", data_slave_read[j]), UVM_LOW)
    end

    data_apb_master_send.delete();
    data_slave_read.delete();
  endfunction

  function void write(packet item);
    if (item.paddr == 0 && item.pwrite == 1 && item.pdata != 0)
      data_apb_master_send.push_back(item.pdata);

    //check mirror data and data APB read from DUT's register block
    if (!item.pwrite)
    begin
      case (item.paddr)
        0: mirror_data = this.reg_model.reg_tran.get_mirrored_value();
        1: mirror_data = this.reg_model.reg_rev.get_mirrored_value();
        2: mirror_data = this.reg_model.reg_st.get_mirrored_value();
        3: mirror_data = this.reg_model.reg_addr.get_mirrored_value();
        4: mirror_data = this.reg_model.reg_cmd.get_mirrored_value();
        5: mirror_data = this.reg_model.reg_pres.get_mirrored_value();
      endcase
      if (mirror_data == item.pdata)
        `uvm_info("SCOREBOARD CLASS", $sformatf("reg %0h MATCH VALUE", item.paddr), UVM_LOW)
      else
        $error("[SCOREBOARD CLASS] reg %0h MISMATCH VALUE - EXPECT VALUE: %0h, ACTUAL VALUE: %0h", item.paddr, mirror_data, item.pdata);
    end
    // `uvm_info("SCB_CLASS", $sformatf("Inside write function! addr %0h", item.paddr), UVM_MEDIUM)
  endfunction
endclass: scoreboard
`endif