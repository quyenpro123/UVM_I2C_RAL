// Object class

class sequence_ extends uvm_sequence;
  `uvm_object_utils(sequence_)
  
  packet pkt;
  
  function new(string name= "sequence_");
    super.new(name);
  endfunction
  
  task body();
    pkt = packet::type_id::create("pkt");
    test_1();
  endtask: body

  task apb_write (logic [7:0] paddr, logic [7:0] pwdata);
    start_item(this.pkt);
    this.pkt.paddr = paddr;
    this.pkt.pwrite = 1;
    this.pkt.pwdata = pwdata;
    this.pkt.psel = 1;
    this.pkt.penable = 0;
    finish_item(pkt);

    start_item(this.pkt);
    this.pkt.penable = 1;
    finish_item(this.pkt);

    start_item(this.pkt);
    this.pkt.psel = 0;
    this.pkt.penable = 0;
    finish_item(this.pkt);
  endtask

  task apb_read (logic [7:0] paddr);
    start_item(this.pkt);
    this.pkt.paddr = paddr;
    this.pkt.pwrite = 0;
    this.pkt.psel = 1;
    this.pkt.penable = 0;
    finish_item(this.pkt);

    start_item(this.pkt);
    this.pkt.penable = 1;
    finish_item(this.pkt);

    start_item(this.pkt);
    this.pkt.psel = 0;
    this.pkt.penable = 0;
    finish_item(this.pkt);
  endtask

  task apb_reset();
    start_item(this.pkt);
    this.pkt.preset = 0;
    finish_item(this.pkt);

    start_item(this.pkt);
    this.pkt.preset = 1;
    finish_item(this.pkt);
  endtask

  task test_1 ();
    apb_reset();
    this.pkt.randomize();
    apb_write(0, this.pkt.pwdata);
    this.pkt.randomize();
    apb_write(1, this.pkt.pwdata);
    this.pkt.randomize();
    apb_write(2, this.pkt.pwdata);
    this.pkt.randomize();
    apb_write(3, this.pkt.pwdata);
    this.pkt.randomize();
    apb_write(4, this.pkt.pwdata);
    this.pkt.randomize();
    apb_write(5, this.pkt.pwdata);
  endtask
endclass: sequence_