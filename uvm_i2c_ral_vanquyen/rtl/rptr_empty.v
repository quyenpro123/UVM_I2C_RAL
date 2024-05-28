// read pointer and empty logic
//The n-bit pointer ( rptr ) is passed to the write clock domain through the sync_r2w module. 
//The (n-1)-bit pointer ( raddr ) is used to address the FIFO buffer.

module rptr_empty # (parameter  ADDRSIZE = 4 )
(
    input       	[ADDRSIZE : 0]      rq2_wptr_i  , // The pointer synchronized from write_pointer to read-domain
    input                          		rinc_i      , // Read increase how many memory cells
    input                          	 	rclk_i      , // The clock of read-domain
    input                           	rrst_ni     , // The negative reset signal of read-domain
    output                       	    rempty_o    , // Output is the buffer is empty, can not read
    output  	 	[ADDRSIZE - 1 : 0]  raddr_o     , // Address used to read data from FIFO memory
    output	    	[ADDRSIZE : 0]      rptr_o      , // The gray-pointer of read-domain used for synchronization to write-domain
	output							    r_almost_empty_o	// Almost empty
      
);

    // Declar reg of output
    reg                     	rempty            ;
    reg 	[ADDRSIZE - 1 : 0]  raddr             ;
    reg  	[ADDRSIZE : 0]      rptr              ;
    reg							r_almost_empty    ;

    // Declar pointer
    reg     [ADDRSIZE : 0]  rbin        	            ; // binary read-pointer 
    wire    [ADDRSIZE : 0]  rbinnext    	            ; // binary read-pointer where the next address is to be read after increase
    wire    [ADDRSIZE : 0]  rgraynext   	            ; // gray   read-pointer where the next address is to be read after increase
	wire    [ADDRSIZE : 0]  rgraynextp1   	            ; // gray   read-pointer transfered from (rbinnext + 1)
    
    // Connect reg to ouput
    assign      rempty_o            =   rempty          ;
    assign      raddr_o             =   raddr           ;
    assign      rptr_o              =   rptr            ;
    assign      r_almost_empty_o    =   r_almost_empty  ;

    // Gray pointer and binary pointer
    always @ (posedge rclk_i,   negedge rrst_ni)
    begin
    
        if (~rrst_ni)
            {rptr, rbin}    <=  0                         ;
        else
            {rptr, rbin}    <=    {rgraynext, rbinnext}   ;
    
    end
    
    // Memory read-address pointer
	always	@ (*)
	begin

		raddr     =   rbin[ADDRSIZE - 1 : 0]      ;

	end
    
    assign  rbinnext    =   rbin + (rinc_i & ~rempty) ; // if buffer is empty, can not increase address

    // Convert from binary to gray
    assign  rgraynext   =   (rbinnext >> 1) ^ rbinnext  ;
	assign	rgraynextp1	=	((rbinnext + 1) >> 1) ^ (rbinnext + 1)  ;
    
    // FIFO empty when the next rptr == synchronized write-pointer or reset
    assign  rempty_val  		=   (rgraynext   == rq2_wptr_i)   ;
	assign	r_almost_empty_val	=	(rgraynextp1 == rq2_wptr_i)   ;

    always  @ (posedge rclk_i,  negedge rrst_ni)
    begin
    
        if (~rrst_ni)
			begin
            	rempty    		    <=  1'b1                ;
				r_almost_empty	    <=	1'b1		        ;
			end

        else
			begin
            	rempty    		    <=  rempty_val  		;
				r_almost_empty	    <=	r_almost_empty_val	;
			end
    
    end

endmodule

