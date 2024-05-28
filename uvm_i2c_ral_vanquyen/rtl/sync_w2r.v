
// Module write-domain to read-domain synchronizer
// Used to pass an n-bit pointer from the write clock domain to the read clock domain

module sync_w2r # (parameter    ADDRSIZE =   4 )
(
    input        [ADDRSIZE : 0]   wptr_i     , // The write pointer passed to read-domain
    input                         rclk_i     , // The clock of read-domain
    input                         rrst_ni    , // The negative reset of read-domain
    output       [ADDRSIZE : 0]   rq2_wptr_o   // The pointer synchronized from write-domain to read-domain
                                               
    
);

    reg     [ADDRSIZE : 0]      rq1_wptr            ;
    reg     [ADDRSIZE : 0]      rq2_wptr            ;

    assign      rq2_wptr_o      =       rq2_wptr    ;
    
    // Multi-flop synchronizer logic for passing the pointers to avoid Metastability
    always @ (posedge rclk_i,   negedge rrst_ni)
    begin
    
        if (~rrst_ni)
            {rq2_wptr, rq1_wptr}  <=  0                    ;
        else
            {rq2_wptr, rq1_wptr}  <=  {rq1_wptr, wptr_i}   ;
    end

endmodule
    