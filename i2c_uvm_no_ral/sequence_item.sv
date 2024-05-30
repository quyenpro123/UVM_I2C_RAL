//Object class
class packet extends uvm_sequence_item;
  `uvm_object_utils(packet)
  logic preset;
  logic [7:0] paddr;
  logic pwrite;
  logic psel;
  logic penable;
  rand logic [7:0] pwdata;

  logic [7:0] data_slave_read;
  logic data_slave_read_valid;
  function new(string name = "packet");
    super.new(name);
  endfunction: new

endclass: packet