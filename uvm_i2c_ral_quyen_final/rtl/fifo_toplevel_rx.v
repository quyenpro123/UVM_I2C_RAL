
module fifo_toplevel_rx	# (	parameter	DATASIZE	=	8,
							parameter	ADDRSIZE	=	4)
(
	input		[DATASIZE - 1 : 0]		wdata_i			, // data which write to FIFO buffer

	input								winc_i			, // write increase how many cells
	input								wclk_i			, // The clock of write-domain
	input								wrst_ni			, // The negative reset signal of write-domain

	input								rinc_i			, // read increase how many cells
	input								rclk_i			, // The clock of read-domain
	input								rrst_ni			, // The negative reset signal of read-domain

	output		[DATASIZE - 1 : 0]		rdata_o			, // Data which read from FIFO buffer
	output								rempty_o		, // State of FIFO buffer is empty
	output								wfull_o			,  // State of FIFO buffer is full
	output								r_almost_empty_o,	// almost empty
	output								w_almost_full_o		// almost full
	
);

	wire	[ADDRSIZE - 1 : 0]		raddr		; 
	wire	[ADDRSIZE - 1 : 0]		waddr		;

	wire	[ADDRSIZE 	  : 0]		rptr		;
	wire	[ADDRSIZE 	  : 0]		rq2_wptr	;
	wire	[ADDRSIZE 	  : 0]		wptr		;
	wire	[ADDRSIZE 	  : 0]		wq2_rptr	;


	fifo_mem_rx	# (DATASIZE, ADDRSIZE)	fifo_mem1
	(
		.wdata_i  (wdata_i 	)	, // DATA write to FIFO buffer
    	.waddr_i  (waddr	)	, // Address of FIFO memory where data written
    	.raddr_i  (raddr	)	, // Address of FIFO memory where data read
    	.wclk_i   (wclk_i	)	, // Clock of write domain
    	.wclken_i (winc_i	)	, // Write clock enable
    	.rdata_o  (rdata_o	)	  // DATA read from FIFO buffer  
	);

	rptr_empty	# (ADDRSIZE)	rptr_empty1
	(
    	.rq2_wptr_i (rq2_wptr)  , // The pointer synchronized from write_pointer to read-domain
    	.rinc_i     (rinc_i	 )	, // Read increase how many memory cells
    	.rclk_i     (rclk_i  )	, // The clock of read-domain
    	.rrst_ni    (rrst_ni )	, // The negative reset signal of read-domain
    	.rempty_o   (rempty_o)	, // Output is the buffer is empty, can not read
    	.raddr_o    (raddr   )	, // Address used to read data from FIFO memory
    	.rptr_o     (rptr    )	,  // The gray-pointer of read-domain used for synchronization to write-domain
		.r_almost_empty_o (r_almost_empty_o)
	);

	wptr_full	# (ADDRSIZE)	wptr_full1
	(
		.wq2_rptr_i	(wq2_rptr)	, // The pointer synchronized from read-domain to write-domain
		.winc_i		(winc_i	 )	, // Write increase how many cells
		.wclk_i		(wclk_i	 )	, // The clock of write-domain
		.wrst_ni	(wrst_ni )	, // The negative reset signal of write-domain
		.wfull_o	(wfull_o )	, // Output is the buffer is full, can not write
		.wptr_o		(wptr	 )	, // The gray-pointer of write-domain used for synchronization to read-domain
		.waddr_o	(waddr	 ) 	, // The address used write data to FIFO memory
		.w_almost_full_o (w_almost_full_o)
	);

	sync_r2w	# (ADDRSIZE)	sync_r2w1
	(
	    .rptr_i     (rptr	 )	, // read pointer passed to write-domain
    	.wclk_i     (wclk_i	 )	, // Clock of write-domain
    	.wrst_ni    (wrst_ni )  , // Negative reset signal of write-domain
    	.wq2_rptr_o (wq2_rptr) 	  // The pointer synchronized from read-domain to write-domain
	);	

	sync_w2r	# (ADDRSIZE)	sync_w2r1
	(
	    .wptr_i     (wptr	 )	, // The write pointer passed to read-domain
    	.rclk_i     (rclk_i	 )	, // The clock of read-domain
    	.rrst_ni    (rrst_ni )	, // The negative reset of read-domain
    	.rq2_wptr_o (rq2_wptr)    // The pointer synchronized from write-domain to read-domain
	);

endmodule

