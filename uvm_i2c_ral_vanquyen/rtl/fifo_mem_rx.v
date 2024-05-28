module fifo_mem_rx # ( parameter DATASIZE = 8    , // Memory data width
                    parameter ADDRSIZE = 4    ) // Address width
(    
    input	       [DATASIZE - 1 : 0]   wdata_i     , // DATA write to FIFO buffer
    input	       [ADDRSIZE - 1 : 0]   waddr_i     , // Address of FIFO memory where data written
    input	       [ADDRSIZE - 1 : 0]   raddr_i     , // Address of FIFO memory where data read
    input	                            wclk_i      , // Clock of write domain
    //input                               rst_ni      , // Reset signal is active LOW
    input	                            wclken_i    , // Write clock enable
    output	      [DATASIZE - 1 : 0]    rdata_o       // DATA read from FIFO buffer   
);

    localparam  DEPTH   =   1 << ADDRSIZE                     ; // Size of buffer

    reg     [DATASIZE - 1 : 0]      mem  [0 : DEPTH - 1]     ;  // Array with DEPTH  element
    reg     [DATASIZE - 1 : 0]      rdata                    ;

    assign      rdata_o     =       rdata                    ;
    
    // Read data from FIFO buffer
	always	@ (*)
	begin

		rdata      =    mem[raddr_i]     ;

	end
    
    //Write data to FIFO buffer
    always @ (posedge wclk_i )
    begin
        
            if (wclken_i)
                mem[waddr_i]    <=   wdata_i     ; 

    end
    
endmodule

