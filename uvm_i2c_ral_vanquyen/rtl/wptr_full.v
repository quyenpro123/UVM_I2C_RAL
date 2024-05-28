
// Write pointer and full logic
// The n-bit pointer ( wptr ) is passed to the read clock domain through the sync_w2r module. 
// The (n-1)-bit pointer ( waddr ) is used to address the FIFO buffer.

module wptr_full	#(parameter	ADDRSIZE = 4)
(
	input		[ADDRSIZE : 0]		wq2_rptr_i	, // The pointer synchronized from read-domain to write-domain
	input							winc_i		, // Write increase how many cells
	input							wclk_i		, // The clock of write-domain
	input							wrst_ni		, // The negative reset signal of write-domain
	output							wfull_o		, // Output is the buffer is full, can not write
	output		[ADDRSIZE : 0]		wptr_o		, // The gray-pointer of write-domain used for synchronization to read-domain
	output		[ADDRSIZE - 1 : 0]	waddr_o	  	, // The address used write data to FIFO memory
	output							w_almost_full_o 	// Almost full
);

	// Decalar reg of output
	reg							wfull		    	;
	reg		[ADDRSIZE : 0]		wptr				;
	reg		[ADDRSIZE - 1 : 0]	waddr  				;
	reg							w_almost_full		;

	// Decalar pointer
	reg		[ADDRSIZE : 0]	wbin		; // binary write-pointer
	wire	[ADDRSIZE : 0]	wbinnext	; // binary write-pointer where the next address is to be write
	wire	[ADDRSIZE : 0]	wgraynext	; // gray   write-pointer where the next address is to be write
	wire	[ADDRSIZE : 0]	wgraynextp1	; // gray   write-pointer converted from (wbinnext + 1)

	// Connect reg to output
	assign		wfull_o		=		wfull			;
	assign		wptr_o		=		wptr			;
	assign		waddr_o		=		waddr			;
	assign		w_almost_full_o	=	w_almost_full	;

	// memory write-address pointer
	always	@ (*)
	begin

		waddr	  =		wbin[ADDRSIZE - 1 : 0]		;

	end

	// Caculator write binary next pointer = write binary + increment if FIFO buffer not full
	assign	wbinnext  =		wbin + (winc_i & ~wfull)	;

	// Convert binary to gray
	assign	wgraynext =		(wbinnext >> 1) ^ wbinnext	;

	// Almost full if wptr-binary + 1 = synchrosized rptr
	assign	wgraynextp1	=	((wbinnext + 1) >> 1) ^ (wbinnext + 1)	;

	// gray pointer and binary pointer of write-domain
	always	@ (posedge wclk_i,	negedge wrst_ni)
	begin
		
		if (~wrst_ni)
			{wptr, wbin}	<=	0						;
		else
			{wptr, wbin}	<=	{wgraynext, wbinnext}	;

	end

	//------------------------------------------------------------------
 	// FIFO full if 2 MSB bit of write gray next != synchronized rptr and other ==
 	// assign wfull_val=((wgnext[ADDRSIZE] !=wq2_rptr[ADDRSIZE] )    &&
 	// 					 (wgnext[ADDRSIZE-1] !=wq2_rptr[ADDRSIZE-1]) &&
 	// 					 (wgnext[ADDRSIZE-2:0]==wq2_rptr[ADDRSIZE-2:0]));
 	//------------------------------------------------------------------

	assign	wfull_val			=	(wq2_rptr_i == { ~wgraynext[ADDRSIZE : ADDRSIZE - 1], 
											  		  wgraynext[ADDRSIZE - 2 : 0]		});
		
	assign	w_almost_full_val	=	(wq2_rptr_i == { ~wgraynextp1[ADDRSIZE : ADDRSIZE - 1], 
											  		  wgraynextp1[ADDRSIZE - 2 : 0]		});

	// Logic wfull
	always	@ (posedge wclk_i,	negedge wrst_ni)
	begin
	
		if	(~wrst_ni)
		begin
			wfull				<=	1'b0		;
			w_almost_full		<=	1'b0		;
		end

		else
		begin
			wfull				<=	wfull_val			;
			w_almost_full		<=	w_almost_full_val	;
		end

	end

endmodule
