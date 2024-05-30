`ifndef REG_SEQ
`define REG_SEQ
// Object class
`include "reg_model.sv"
class reg_base_sequence extends uvm_sequence;
  `uvm_object_utils(reg_base_sequence)

  i2c_reg_block reg_model;
  rand bit [7:0] data;

  function new(string name= "reg_base_sequence");
    super.new(name);
  endfunction

  virtual task ena_core_sr;
      uvm_status_e status;
      this.reg_model.reg_cmd.write(status, 8'he0);
  endtask

  virtual task reset();
    uvm_status_e status;
      this.reg_model.reg_cmd.write(status, 8'h00);
  endtask

  virtual task ena_core_no_sr;
      uvm_status_e status;
      this.reg_model.reg_cmd.write(status, 8'hc0);
  endtask
endclass

class TEST_1 extends reg_base_sequence;
  `uvm_object_utils(TEST_1)
  
  function new(string name= "TEST_1");
    super.new(name);
  endfunction
  
  task body();
    uvm_reg_data_t data, mirror_reg_value;
    uvm_status_e status;
    `uvm_info(get_name(), "-------------TEST 1: reset, read/write reg------------", UVM_MEDIUM)    
    
    //write new value
    this.reg_model.reg_tran.write(status, 8'h11);
    this.reg_model.reg_addr.write(status, 8'h22);
    this.reg_model.reg_cmd.write(status, 8'h30);
    this.reg_model.reg_pres.write(status, 8'h99);

    this.reg_model.reg_tran.read(status, data);
    this.reg_model.reg_st.read(status, data);
    this.reg_model.reg_addr.read(status, data);
    this.reg_model.reg_cmd.read(status, data);
    this.reg_model.reg_pres.read(status, data);

    #5000;
  endtask: body
endclass

class TEST_2 extends reg_base_sequence;
  `uvm_object_utils(TEST_2)

  function new(string name= "TEST_2");
    super.new(name);
  endfunction
  
  task body();
    uvm_reg_data_t data;
    uvm_status_e status;
    `uvm_info(get_name(), "-------------TEST 2: apb write/read out-of-range register------------", UVM_MEDIUM)
    //registers was configured. there is no out-of-range register 
    #500;
  endtask: body
endclass

class TEST_3 extends reg_base_sequence;
  `uvm_object_utils(TEST_3)
  
  function new(string name= "TEST_3");
    super.new(name);
  endfunction
  
  task body();
    uvm_reg_data_t data;
    uvm_status_e status;
    `uvm_info(get_name(), "-------------TEST 3: i2c reset core suddenly------------", UVM_MEDIUM)
    this.reg_model.reg_pres.write(status, 8'h08);   // 1 -> 0
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_tran.write(status, 8'h00);
    this.reg_model.reg_tran.write(status, 8'h11);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #55;
    this.reset();
    this.reg_model.reg_pres.write(status, 8'h08);  // 2 -> 0
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_tran.write(status, 8'h00);
    this.reg_model.reg_tran.write(status, 8'h11);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #200;
    this.reset();
    this.reg_model.reg_pres.write(status, 8'h08);  // 3 -> 0
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_tran.write(status, 8'h00);
    this.reg_model.reg_tran.write(status, 8'h11);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #1455;
    this.reset();
    this.reg_model.reg_pres.write(status, 8'h08); // 4 -> 0
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_tran.write(status, 8'h00);
    this.reg_model.reg_tran.write(status, 8'h11);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #1755;
    this.reset();
    this.reg_model.reg_pres.write(status, 8'h08); // 5 -> 0
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_tran.write(status, 8'h00);
    this.reg_model.reg_tran.write(status, 8'h11);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #2955;
    this.reset();

    this.reg_model.reg_pres.write(status, 8'h08); // 5 -> 8
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_tran.write(status, 8'h00);
    this.reg_model.reg_tran.write(status, 8'h11);
    this.reg_model.reg_tran.write(status, 8'h11);
    this.reg_model.reg_tran.write(status, 8'h11);
    this.reg_model.reg_tran.write(status, 8'h11);
    this.reg_model.reg_cmd.write(status, 8'he0);
    #2955;
    this.reset();

    this.reg_model.reg_pres.write(status, 8'h08); // 6 -> 0
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_tran.write(status, 8'h00);
    repeat(3)
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #7610;
    this.reg_model.reg_addr.write(status, 8'h21);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #1755;
    this.reset();

    this.reg_model.reg_pres.write(status, 8'h08); // 7 -> 8
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_tran.write(status, 8'h00);
    repeat(3)
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #7610;
    this.reg_model.reg_addr.write(status, 8'h21);
    this.reg_model.reg_cmd.write(status, 8'he0);
    #30000;
    this.reset();

    this.reg_model.reg_pres.write(status, 8'h08); // 7 -> 0
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_tran.write(status, 8'h00);
    repeat(3)
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #7610;
    this.reg_model.reg_addr.write(status, 8'h21);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #2925;
    this.reset();
    

    this.reg_model.reg_pres.write(status, 8'h08); // 8 -> 0: repeat start only occurs when transfifo is not empty
    this.reg_model.reg_addr.write(status, 8'h20); // Need to change i2c_slave_model.sv at line 293 (less than number of bytes that master transmits)
    this.reg_model.reg_tran.write(status, 8'h00);
    repeat(10)
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    this.reg_model.reg_cmd.write(status, 8'he0);
    #8800;
    this.reset();

     this.reg_model.reg_pres.write(status, 8'h08); // 8 -> 0: repeat start only occurs when transfifo is not empty
    this.reg_model.reg_addr.write(status, 8'h20); // Need to change i2c_slave_model.sv at line 293 (less than number of bytes that master transmits)
    this.reg_model.reg_tran.write(status, 8'h00);
    repeat(10)
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #8800;

    #1000000;
  endtask: body
endclass

class TEST_4 extends reg_base_sequence;
  `uvm_object_utils(TEST_4)
  
  function new(string name= "TEST_4");
    super.new(name);
  endfunction
  
  task body();
    uvm_reg_data_t data;
    uvm_status_e status;
    `uvm_info(get_name(), "-------------TEST 4: wrong address------------", UVM_MEDIUM)
    this.reg_model.reg_pres.write(status, 8'h08);
    this.reg_model.reg_addr.write(status, 8'h22);
    this.reg_model.reg_cmd.write(status, 8'he0);
    #5000;
  endtask: body
endclass

class TEST_5 extends reg_base_sequence;
  `uvm_object_utils(TEST_5)
  
  function new(string name= "TEST_5");
    super.new(name); 
  endfunction
  
  task body();
    uvm_reg_data_t data;
    uvm_status_e status;
    `uvm_info(get_name(), "-------------TEST 5: combination of 1 write/1 read------------", UVM_MEDIUM)
    this.reg_model.reg_pres.write(status, 8'h08);
    this.reg_model.reg_tran.write(status, 0);
    repeat(1) begin
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    end
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25000;
    this.reg_model.reg_addr.write(status, 8'h21);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25500
    repeat(1) begin
      this.reg_model.reg_rev.read(status, data);
    end
    #25000;
  endtask: body
endclass

class TEST_6 extends reg_base_sequence;
  `uvm_object_utils(TEST_6)
  
  function new(string name= "TEST_6");
    super.new(name);
  endfunction
  
  task body();
    uvm_reg_data_t data;
    uvm_status_e status;
    `uvm_info(get_name(), "-------------TEST 6: write n byte - repeat start - read n byte------------", UVM_MEDIUM)
    this.reg_model.reg_pres.write(status, 8'h08);
    this.reg_model.reg_tran.write(status, 0);
    repeat(15) begin
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    end
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25500;
    this.reg_model.reg_addr.write(status, 8'h21);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25500;
    repeat(16) begin
      this.reg_model.reg_rev.read(status, data);
    end

  endtask: body
endclass

class TEST_7 extends reg_base_sequence;
  `uvm_object_utils(TEST_7)
  
  
  
  function new(string name= "TEST_7");
    super.new(name);
  endfunction
  
  task body();
    uvm_reg_data_t data;
    uvm_status_e status;
    `uvm_info(get_name(), "-------------TEST 7: write n times------------", UVM_MEDIUM)
    this.reg_model.reg_pres.write(status, 8'h08);
    this.reg_model.reg_tran.write(status, 0);
    repeat(1) begin
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    end
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_cmd.write(status, 8'hc0);


    #5000;
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #5000;
    this.reg_model.reg_tran.write(status, 0);
    repeat(1) begin
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    end
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_cmd.write(status, 8'hc0);

    #5000;
    this.reg_model.reg_tran.write(status, 0);
    repeat(1) begin
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    end
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25000;
  endtask: body
endclass

class TEST_8 extends reg_base_sequence;
  `uvm_object_utils(TEST_8)
  
  function new(string name= "TEST_8");
    super.new(name);
  endfunction
  
  task body();
    uvm_reg_data_t data;
    uvm_status_e status;
    `uvm_info(get_name(), "-------------TEST 8: read n times------------", UVM_MEDIUM)

    this.reg_model.reg_pres.write(status, 8'h08);
    this.reg_model.reg_tran.write(status, 0);
    repeat(15) begin
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    end
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25500;
    this.reg_model.reg_addr.write(status, 8'h21);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25500;
    repeat(16) begin
      this.reg_model.reg_rev.read(status, data);
    end


    this.reg_model.reg_pres.write(status, 8'h08);
    this.reg_model.reg_tran.write(status, 0);
    repeat(15) begin
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    end
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25500;
    this.reg_model.reg_addr.write(status, 8'h21);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25500;
    repeat(16) begin
      this.reg_model.reg_rev.read(status, data);
    end

    this.reg_model.reg_pres.write(status, 8'h08);
    this.reg_model.reg_tran.write(status, 0);
    repeat(15) begin
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    end
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25500;
    this.reg_model.reg_addr.write(status, 8'h21);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25500;
    repeat(16) begin
      this.reg_model.reg_rev.read(status, data);
    end

    this.reg_model.reg_pres.write(status, 8'h08);
    this.reg_model.reg_tran.write(status, 0);
    repeat(15) begin
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    end
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25500;
    this.reg_model.reg_addr.write(status, 8'h21);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25500;
    // repeat(16) begin
    //   this.reg_model.reg_rev.read(status, data);
    // end

    this.reg_model.reg_pres.write(status, 8'h08);
    this.reg_model.reg_tran.write(status, 0);
    repeat(15) begin
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    end
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25500;
    this.reg_model.reg_addr.write(status, 8'h21);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #25500;
    repeat(16) begin
      this.reg_model.reg_rev.read(status, data);
    end

  endtask: body
endclass

class TEST_9 extends reg_base_sequence;
  `uvm_object_utils(TEST_9)
  
  function new(string name= "TEST_9");
    super.new(name);
  endfunction
  
  task body();
  uvm_reg_data_t data;
    uvm_status_e status;
    `uvm_info(get_name(), "-------------TEST 9: apb write to tx fifo until full------------", UVM_MEDIUM)
    
    this.reg_model.reg_pres.write(status, 8'h08);
    this.reg_model.reg_tran.write(status, 0);
    repeat(20) begin
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    end
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #29000;
    this.reg_model.reg_addr.write(status, 8'h21);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #29000;
    repeat(20) begin
      this.reg_model.reg_rev.read(status, data);
    end
    #3000000;
  endtask: body
endclass

class TEST_10 extends reg_base_sequence;
  `uvm_object_utils(TEST_10)
  
  
  
  function new(string name= "TEST_10");
    super.new(name);
  endfunction
  
  task body();
    uvm_reg_data_t data;
    uvm_status_e status;
    `uvm_info(get_name(), "-------------TEST 10: apb read from rx fifo until empty------------", UVM_MEDIUM)
    this.reg_model.reg_pres.write(status, 8'h08);
    this.reg_model.reg_tran.write(status, 0);
    repeat(15) begin
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    end
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #29000;
    this.reg_model.reg_addr.write(status, 8'h21);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #29000;
    repeat(20) begin
      this.reg_model.reg_rev.read(status, data);
    end
    #3000000;

  endtask: body
endclass

class TEST_11 extends reg_base_sequence;
  `uvm_object_utils(TEST_11)
  
  function new(string name= "TEST_11");
    super.new(name);
  endfunction
  
  task body();
  uvm_reg_data_t data;
  uvm_status_e status;
    `uvm_info(get_name(), "-------------TEST 11: receive nack from slave when writing------------", UVM_MEDIUM) //change code in i2c_slave_model.sv file at line 293
    this.reg_model.reg_pres.write(status, 8'h08);
    this.reg_model.reg_tran.write(status, 0);
    repeat(15) begin
      this.reg_model.reg_tran.write(status, $urandom_range(1, 255));
    end
    this.reg_model.reg_addr.write(status, 8'h20);
    this.reg_model.reg_cmd.write(status, 8'hc0);
    #100000;
  endtask: body
endclass

class TEST_12 extends reg_base_sequence;
  `uvm_object_utils(TEST_12)
  function new (string name = "TEST_12");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_name(), "-------------TEST 12: cover condition coverage------------", UVM_MEDIUM)
    
  endtask


endclass
`endif