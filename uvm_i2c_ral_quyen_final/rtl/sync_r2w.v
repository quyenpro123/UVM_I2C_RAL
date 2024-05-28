
// Module read-domain to write-domain synchronizer
// Used to pass an n-bit pointer from the read clock domain to the write clock domain

module sync_r2w # (parameter ADDRSIZE = 4 )
(
    input       [ADDRSIZE : 0]  rptr_i     , // read pointer passed to write-domain
    input                       wclk_i     , // Clock of write-domain
    input                       wrst_ni    , // Negative reset signal of write-domain
    output      [ADDRSIZE : 0]  wq2_rptr_o  // The pointer synchronized from read-domain to write-domain
    
); 

    reg     [ADDRSIZE : 0]   wq1_rptr       ;
    reg     [ADDRSIZE : 0]  wq2_rptr        ;
    
    assign  wq2_rptr_o      =       wq2_rptr    ;

    // Multi-flop synchronizer logic for passing the pointers to avoid Metastability
    always @ (posedge wclk_i,   negedge wrst_ni)
    begin
    
        if (~wrst_ni)
            {wq2_rptr, wq1_rptr}  <=  0                    ;
        else
            {wq2_rptr, wq1_rptr}  <=  {wq1_rptr, rptr_i}   ;
    
    end

endmodule 
