

interface intf(input logic pclk, i2c_core_clk);

  logic preset;
  logic [7:0] paddr;
  logic pwrite;
  logic psel;
  logic penable;
  logic [7:0] pwdata;
  
  logic [7:0] prdata;
  logic pready;
  wire sda;
  wire scl;

  logic start;
  logic stop;
  logic [7:0] data_slave_read;
  logic data_slave_read_valid;

endinterface: intf