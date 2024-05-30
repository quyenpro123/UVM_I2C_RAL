`ifndef  SUBC
`define SUBC
class subscriber extends uvm_subscriber #(packet);
    `uvm_component_utils(subscriber)
    uvm_analysis_imp #(packet, subscriber) sub_port;

    logic [7:0] paddr;
    logic pwrite;
    logic [7:0] pwdata;

    covergroup cov;
        cov_addr: coverpoint paddr {
            bins bin0 = {0};
            bins bin1 = {1};
            bins bin2 = {2};
            bins bin4 = {4};
            bins bin5 = {5};
        }

        cov_paddr_slave_addr: coverpoint paddr {
            bins bin3 = {3};
        }

        cov_slave_addr: coverpoint pwdata {
            bins bin7 = {8'h20};
            bins bin8 = {8'h21};
        }

        cov_write_addr_slave: cross cov_paddr_slave_addr, cov_slave_addr;
    endgroup

    function new(string name = "subscriber", uvm_component parent);
        super.new(name, parent);
        cov = new();
        sub_port = new("sub_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("SUBSCRIBER_CLASS", "Inside build phase!", UVM_LOW)
    endfunction

    virtual function void write(packet t);
        paddr = t.paddr;
        pwrite = t.pwrite;
        if (t.pwrite)
            pwdata = t.pdata;
        cov.sample();
    endfunction
endclass: subscriber
`endif