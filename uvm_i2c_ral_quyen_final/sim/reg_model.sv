`ifndef REG_MODEL
`define REG_MODEL
//addr: 0x00
class transmit extends uvm_reg;
    `uvm_object_utils(transmit)
    rand uvm_reg_field data_trans;

    function new (string name = "transmit");
        super.new(name, 8, UVM_NO_COVERAGE);
    endfunction

    function void build;
        data_trans = uvm_reg_field::type_id::create("data_trans");
        data_trans.configure(.parent(this), 
                   .size(8), 
                   .lsb_pos(0),  
                   .access("RW"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));   
    endfunction
endclass

//addr: 0x01
class receive extends uvm_reg;
    `uvm_object_utils(receive)
    rand uvm_reg_field data_rev;

    function new (string name = "receive");
        super.new(name, 8, UVM_NO_COVERAGE);
    endfunction

    function void build;
        data_rev = uvm_reg_field::type_id::create("data_rev");
        data_rev.configure(.parent(this), 
                   .size(8), 
                   .lsb_pos(0),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));   
    endfunction
endclass

//addr: 0x02
class status extends uvm_reg;
    `uvm_object_utils(status)
    rand uvm_reg_field tx_emp;
    rand uvm_reg_field tx_ful;
    rand uvm_reg_field tx_al_emp;
    rand uvm_reg_field tx_al_ful;
    rand uvm_reg_field rx_emp;
    rand uvm_reg_field rx_ful;
    rand uvm_reg_field rx_al_emp;
    rand uvm_reg_field rx_al_ful;


    function new (string name = "status");
        super.new(name, 8, UVM_NO_COVERAGE);
    endfunction

    function void build;
        tx_emp = uvm_reg_field::type_id::create("tx_emp");
        tx_emp.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(7),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));   
        

        tx_ful = uvm_reg_field::type_id::create("tx_ful");
        tx_ful.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(6),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));

        tx_al_emp = uvm_reg_field::type_id::create("tx_al_emp");
        tx_al_emp.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(5),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));

        tx_al_ful = uvm_reg_field::type_id::create("tx_al_ful");
        tx_al_ful.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(4),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));

        rx_emp = uvm_reg_field::type_id::create("rx_emp");
        rx_emp.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(3),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));

        rx_ful = uvm_reg_field::type_id::create("rx_ful");
        rx_ful.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(2),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));

        rx_al_emp = uvm_reg_field::type_id::create("rx_al_emp");
        rx_al_emp.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(1),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));

        rx_al_ful = uvm_reg_field::type_id::create("rx_al_ful");
        rx_al_ful.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(0),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));
    endfunction
endclass

//addr: 0x03
class slave_addr extends uvm_reg;
    `uvm_object_utils(slave_addr)
    rand uvm_reg_field addr;

    function new (string name = "slave_addr");
        super.new(name, 8, UVM_NO_COVERAGE);
    endfunction

    function void build;
        addr = uvm_reg_field::type_id::create("addr");
        addr.configure(.parent(this), 
                   .size(8), 
                   .lsb_pos(0),  
                   .access("RW"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));   
    endfunction
endclass

//addr: 0x04
class cmd extends uvm_reg;
    `uvm_object_utils(cmd)
    rand uvm_reg_field reset;
    rand uvm_reg_field enable;
    rand uvm_reg_field repeat_start;
    rand uvm_reg_field mode;

    function new (string name = "cmd");
        super.new(name, 8, UVM_NO_COVERAGE);
    endfunction

    function void build;
        reset = uvm_reg_field::type_id::create("reset");
        reset.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(7),  
                   .access("RW"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));  

        enable = uvm_reg_field::type_id::create("enable");
        enable.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(6),  
                   .access("RW"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));

        repeat_start = uvm_reg_field::type_id::create("repeat_start");
        repeat_start.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(5),  
                   .access("Rw"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));

        mode = uvm_reg_field::type_id::create("mode");
        mode.configure(.parent(this), 
                   .size(1), 
                   .lsb_pos(4),  
                   .access("RO"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));
    endfunction
endclass

//addr: 0x05
class prescale extends uvm_reg;
    `uvm_object_utils(prescale)
    rand uvm_reg_field pre_val;

    function new (string name = "prescale");
        super.new(name, 8, UVM_NO_COVERAGE);
    endfunction

    function void build;
        pre_val = uvm_reg_field::type_id::create("pre_val");
        pre_val.configure(.parent(this), 
                   .size(8), 
                   .lsb_pos(0),  
                   .access("RW"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));   
    endfunction
endclass

class i2c_reg_block extends uvm_reg_block;
    `uvm_object_utils(i2c_reg_block)

    rand prescale reg_pres;
    rand receive reg_rev;
    rand cmd reg_cmd;
    rand slave_addr reg_addr;
    rand status reg_st;
    rand transmit reg_tran;

    function new (string name = "");
        super.new(name, build_coverage(UVM_NO_COVERAGE));
    endfunction

    function void build;
        reg_pres = prescale::type_id::create("reg_pres");   
        reg_pres.build();
        reg_pres.configure(this);

        reg_rev = receive::type_id::create("reg_rev");
        reg_rev.build();
        reg_rev.configure(this);

        reg_cmd = cmd::type_id::create("reg_cmd");
        reg_cmd.build();
        reg_cmd.configure(this);

        reg_addr = slave_addr::type_id::create("reg_addr");
        reg_addr.build();
        reg_addr.configure(this);

        reg_st = status::type_id::create("reg_st"); 
        reg_st.build();
        reg_st.configure(this);

        reg_tran = transmit::type_id::create("reg_tran");
        reg_tran.build();
        reg_tran.configure(this);

        default_map = create_map("my_map", 0, 1, UVM_LITTLE_ENDIAN); // name, base, nBytes
        default_map.add_reg(reg_tran, 0, "RW");  // reg, offset, access
        default_map.add_reg(reg_rev	, 1, "RO");
        default_map.add_reg(reg_st	, 2, "RO");
        default_map.add_reg(reg_addr, 3, "RW");
        default_map.add_reg(reg_cmd , 4, "RW");
        default_map.add_reg(reg_pres, 5, "RW");
    endfunction
endclass
`endif