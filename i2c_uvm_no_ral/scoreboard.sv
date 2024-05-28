

class scoreboard extends uvm_test;
  `uvm_component_utils(scoreboard)
  
  uvm_analysis_imp #(packet, scoreboard) scoreboard_port;
  
  packet transactions[$];
  

  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB_CLASS", "Build Phase!", UVM_MEDIUM)
   
    scoreboard_port = new("scoreboard_port", this);
    
  endfunction: build_phase
  

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SCB_CLASS", "Connect Phase!", UVM_MEDIUM)
  endfunction: connect_phase
  
  

  function void write(packet item);
    transactions.push_back(item);
  endfunction: write 
  
  

  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("SCB_CLASS", "Run Phase!", UVM_MEDIUM)
   
    // forever begin
    //   packet curr_trans;
    //   wait((transactions.size() != 0));
    //   curr_trans = transactions.pop_front();
    //   compare(curr_trans);
      
    // end
    
  endtask: run_phase
  
  

  // task compare(packet curr_trans);
  //   logic [7:0] expected;
  //   logic [7:0] actual;
    
  //   expected = curr_trans.a + curr_trans.b;
    
  //   actual = curr_trans.c;
    
  //   if(actual != expected) begin
  //     `uvm_error("COMPARE", $sformatf("Transaction failed! ACT=%d, EXP=%d", actual, expected))
  //   end
  //   else begin
  //     `uvm_info("COMPARE", $sformatf("Transaction Passed! ACT=%d, EXP=%d", actual, expected), UVM_MEDIUM)
  //   end
    
  // endtask: compare
  
  
endclass: scoreboard