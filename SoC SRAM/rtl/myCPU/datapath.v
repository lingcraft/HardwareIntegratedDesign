`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 15:12:22
// Design Name: 
// Module Name: datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath(
	input  wire clk,
	input  wire rst,
	// fetch stage
	output wire [31:0] pcF,
	input  wire [31:0] instrF,
	// decode stage
	input  wire pcsrcD,
	input  wire branchD,
	output wire equalD,
	input  wire balD,
	input  wire jD,
	input  wire jalD,
	input  wire jrD,
	input  wire jalrD,
	output wire [5:0] opD,
	output wire [5:0] functD,
	output wire [4:0] rsD,
	output wire [4:0] rtD,
	input  wire [1:0] hilowriteD,
	input  wire syscallD,
	input  wire breakD,
	input  wire eretD,
	input  wire invalidityD,
	// execute stage
	input  wire memtoregE,
	input  wire [1:0] alusrcE,
	input  wire regdstE,
	input  wire regwriteE,
	input  wire [4:0] alucontrolE,
	output wire flushE,
	output wire stallE,
	output wire overflow,
	// memory visit stage
	input  wire memtoregM,
	input  wire regwriteM,
	output wire [31:0] aluoutM,
	output wire [31:0] writedata2M,
	input  wire [31:0] readdataM,
	output wire [3:0] selM,
	input  wire cp0writeM,
	output wire flushM,
	output wire exceptionoccur,
	// write back stage
	output wire [31:0] pcW,
	input  wire memtoregW,
	input  wire regwriteW,
	output wire [4:0] writeregW,
	output wire [31:0] resultW,
	output wire flushW 
    );
	
	// fetch stage
	wire stallF;
	wire isindelayslotF;
	wire [7:0] exceptionF;
	wire flushF;
	// FD
	wire [31:0] pcnextFD;
	wire [31:0] pcnextbrFD;
	wire [31:0] pcnextjrFD;
	wire [31:0] pcplus4F;
	wire [31:0] pcbranchD;
	// decode stage
	wire [31:0] instrD;
	wire [31:0] pcD;
	wire [31:0] pcplus4D;
	wire [31:0] ascii;
	wire [1:0] forwardaD;
	wire [1:0] forwardbD;
	wire [4:0] rdD;
	wire [4:0] saD;
	wire flushD;
	wire stallD;
	wire [31:0] signimmD;
	wire [31:0] signimmshD;
	wire [31:0] zeroimmD;
	wire [31:0] srcaD;
	wire [31:0] srca2D;
	wire [31:0] srcbD;
	wire [31:0] srcb2D;
	wire [31:0] hioutD;
	wire [31:0] looutD;
	wire isindelayslotD;
	wire [7:0] exceptionD;
	// execute stage
	wire [31:0] instrE; 
	wire [31:0] pcE;
	wire [5:0] opE;
	wire [1:0] forwardaE;
	wire [1:0] forwardbE;
	wire [1:0] forwardhiloE;
	wire [4:0] rsE;
	wire [4:0] rtE;
	wire [4:0] rdE;
	wire [4:0] saE;
	wire [4:0] writeregE;
	wire [4:0] writereg2E;
	wire [31:0] signimmE;
	wire [31:0] zeroimmE;
	wire [31:0] srcaE;
	wire [31:0] srca2E;
	wire [31:0] srcbE;
	wire [31:0] srcb2E;
	wire [31:0] srcb3E;
	wire [31:0] aluoutE;
	wire [31:0] aluout2E;
	wire [1:0] hilowriteE;
	wire [1:0] hilowrite2E;
	wire [31:0] hioutE;
	wire [31:0] looutE;
	wire [31:0] hiout2E;
	wire [31:0] loout2E;
	wire [31:0] hialuoutE;
	wire [31:0] loaluoutE;
	wire [31:0] hidivoutE;
	wire [31:0] lodivoutE;
	wire [31:0] hialuout2E;
	wire [31:0] loaluout2E;
	wire divsignalE;
	wire divstartE;
	wire divreadyE;
	wire signeddivsignalE;
	wire balE;		
	wire jalE;
	wire jalrE;
	wire isindelayslotE;
	wire [7:0] exceptionE;
	wire [31:0] cp0dataoutE;
	wire [31:0] cp0dataout2E;
	wire forwardcp0dataE;
	// memory visit stage
	wire [31:0] instrM;
	wire [31:0] pcM;
	wire [5:0] opM;
	wire [4:0] rdM;
	wire [4:0] writeregM;
	wire [1:0] hilowriteM;
	wire [31:0] hialuoutM;
	wire [31:0] loaluoutM;
	wire [31:0] writedataM;
	wire [31:0] finaldataM;
	wire [31:0] erroraddrM;
	wire laddrerrorM;
	wire saddrerrorM;
	wire isindelayslotM;
	wire [7:0] exceptionM;
	wire [31:0] exceptiontypeM;
	wire [31:0] pcexceptionM;
	wire [31:0] countout;
	wire [31:0] compareout;
	wire [31:0] statusout;
	wire [31:0] causeout;
	wire [31:0] epcout;
	wire [31:0] configout;
	wire [31:0] pridout;
	wire [31:0] badvaddrout;
	wire timerintout;
	// write back stage
	wire [31:0] instrW;
	wire [31:0] aluoutW;
	wire [31:0] readdataW;
	wire [1:0] hilowriteW;
	wire [31:0] hialuoutW;
	wire [31:0] loaluoutW;

	// hazard detection
	hazard h (
		// fetch stage
		.stallF 		(stallF			),
		.flushF 		(flushF			),
		// decode stage
		.rsD 			(rsD 			),
		.rtD 			(rtD 			),
		.branchD		(branchD		),
		.forwardaD		(forwardaD		),
		.forwardbD		(forwardbD		),
		.stallD			(stallD			),
		.flushD			(flushD			),
		// execute stage
		.rsE 			(rsE 			),
		.rtE 			(rtE 			),
		.rdE			(rdE			),
		.writeregE 		(writereg2E		),
		.regwriteE	 	(regwriteE		),
		.memtoregE	 	(memtoregE		),
		.hilowriteE 	(hilowriteE		),
		.forwardaE 		(forwardaE 		),
		.forwardbE 		(forwardbE 		),
		.forwardhiloE	(forwardhiloE	),
		.forwardcp0dataE(forwardcp0dataE),
		.flushE			(flushE			),
		.stallE			(stallE			),
		.divstartE		(divstartE		),
		// memory visit stage
		.writeregM		(writeregM		),
		.regwriteM		(regwriteM		),
		.memtoregM		(memtoregM		),
		.hilowriteM		(hilowriteM		),
		.cp0writeM		(cp0writeM		),
		.rdM			(rdM			),
		.flushM			(flushM			),
		.exceptionoccur	(exceptionoccur	),
		// write back stage
		.writeregW		(writeregW		),
		.regwriteW		(regwriteW		),
		.hilowriteW		(hilowriteW		),
		.flushW			(flushW			)
	);

	// next PC logic (operates in fetch an decode)
	mux2 #(32) pcbrmux (pcplus4F,pcbranchD,pcsrcD,pcnextbrFD);
	mux2 #(32) pcjrmux (pcnextbrFD,srca2D,jrD | jalrD,pcnextjrFD);
	mux2 #(32) pcmux (pcnextjrFD,{pcplus4D[31:28],instrD[25:0],2'b00},jD | jalD,pcnextFD);

	// regfile (operates in decode and writeback)
	regfile register (clk,regwriteW,rsD,rtD,writeregW,resultW,srcaD,srcbD);
	hiloreg hiloreg (clk,rst,hilowriteW,hialuoutW,loaluoutW,hioutD,looutD);


	// fetch stage logic
	// flopenr #(32) pcreg (clk,rst,~stallF,pcnextFD,pcF);
	pc #(32) pcreg (clk,rst,~stallF,flushF,pcnextFD,pcexceptionM,pcF);
	adder pcadd1 (pcF,32'd4,pcplus4F);

	assign exceptionF = (pcF[1:0]) ? 8'b1000_0000:8'b0000_0000;
	assign isindelayslotF = (jD | jalD | jrD | jalrD | branchD);


	// decode stage
	flopenrc #(32) r1D (clk,rst,~stallD,flushD,pcplus4F,pcplus4D);
	flopenrc #(32) r2D (clk,rst,~stallD,flushD,instrF,instrD);
	flopenrc #(32) r3D (clk,rst,~stallD,flushD,pcF,pcD);
	flopenrc #(8)  r4D (clk,rst,~stallD,flushD,exceptionF,exceptionD);
	flopenrc #(1)  r5D (clk,rst,~stallD,flushD,isindelayslotF,isindelayslotD);

	signext signext (instrD[15:0],signimmD);
	zeroext zeroext (instrD[15:0],zeroimmD);
	sl2 immsh (signimmD,signimmshD);
	adder pcadd2 (pcplus4D,signimmshD,pcbranchD);

	mux4 #(32) forwardadmux (srcaD,aluout2E,aluoutM,resultW,forwardaD,srca2D);
	mux4 #(32) forwardbdmux (srcbD,aluout2E,aluoutM,resultW,forwardbD,srcb2D);

	eqcmp comp (srca2D,srcb2D,opD,rtD,equalD);

	assign opD = instrD[31:26];
	assign functD = instrD[5:0];
	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];
	assign saD = instrD[10:6];


	// execute stage
	flopenrc #(32) r1E (clk,rst,~stallE,flushE,srca2D,srcaE);
	flopenrc #(32) r2E (clk,rst,~stallE,flushE,srcb2D,srcbE);
	flopenrc #(32) r3E (clk,rst,~stallE,flushE,signimmD,signimmE);
	flopenrc #(5)  r4E (clk,rst,~stallE,flushE,rsD,rsE);
	flopenrc #(5)  r5E (clk,rst,~stallE,flushE,rtD,rtE);
	flopenrc #(5)  r6E (clk,rst,~stallE,flushE,rdD,rdE);
	flopenrc #(32) r7E (clk,rst,~stallE,flushE,zeroimmD,zeroimmE);
	flopenrc #(5)  r8E (clk,rst,~stallE,flushE,saD,saE);
	flopenrc #(2)  r9E (clk,rst,~stallE,flushE,hilowriteD,hilowriteE);
	flopenrc #(64) r10E (clk,rst,~stallE,flushE,{hioutD,looutD},{hioutE,looutE});
	flopenrc #(32) r11E (clk,rst,~stallE,flushE,pcD,pcE);
	flopenrc #(1)  r12E (clk,rst,~stallE,flushE,balD,balE);
	flopenrc #(1)  r13E (clk,rst,~stallE,flushE,jalD,jalE);
	flopenrc #(1)  r14E (clk,rst,~stallE,flushE,jalrD,jalrE);
	flopenrc #(32) r15E (clk,rst,~stallE,flushE,opD,opE);
	flopenrc #(1)  r16E (clk,rst,~stallE,flushE,isindelayslotD,isindelayslotE);
	flopenrc #(8)  r17E (clk,rst,~stallE,flushE,{exceptionD[7],syscallD,breakD,eretD,invalidityD,exceptionD[2:0]},exceptionE);
	flopenrc #(32) r18E (clk,rst,~stallE,flushE,instrD,instrE);

	mux3 #(32) forwardaemux (srcaE,aluoutM,resultW,forwardaE,srca2E);
	mux3 #(32) forwardbemux (srcbE,aluoutM,resultW,forwardbE,srcb2E);

	mux3 #(32) forwardhimux (hioutE,hialuoutM,hialuoutW,forwardhiloE,hiout2E);
	mux3 #(32) forwardlomux (looutE,loaluoutM,loaluoutW,forwardhiloE,loout2E);

	mux2 #(32) forwardcp0datamux (cp0dataoutE,aluoutM,forwardcp0dataE,cp0dataout2E);

	mux3 #(32) srcbmux (srcb2E,signimmE,zeroimmE,alusrcE,srcb3E);

	alu alu (srca2E,srcb3E,saE,alucontrolE,hiout2E,loout2E,cp0dataout2E,aluoutE,hialuoutE,loaluoutE,overflow);

	mux2 #(5) wrmux (rtE,rdE,regdstE,writeregE);
	mux2 #(5) wrmux2 (writeregE,5'd31,balE | jalE,writereg2E);

	mux2 #(32) wrmux3 (aluoutE,pcE+32'd8,balE | jalE | jalrE,aluout2E);

	divdec divdec (divreadyE,alucontrolE,hilowriteE,divstartE,divsignalE,signeddivsignalE,hilowrite2E);
	divider div (clk,rst,signeddivsignalE,srca2E,srcb3E,divstartE,1'b0,{hidivoutE,lodivoutE},divreadyE);

	mux2 #(32) hidiv (hialuoutE,hidivoutE,divsignalE,hialuout2E);
	mux2 #(32) lodiv (loaluoutE,lodivoutE,divsignalE,loaluout2E);


	// memory visit stage
	floprc #(32) r1M (clk,rst,flushM,srcb2E,writedataM);
	floprc #(32) r2M (clk,rst,flushM,aluout2E,aluoutM);
	floprc #(5)  r3M (clk,rst,flushM,writereg2E,writeregM);
	floprc #(2)  r4M (clk,rst,flushM,hilowrite2E,hilowriteM);
	floprc #(64) r5M (clk,rst,flushM,{hialuout2E,loaluout2E},{hialuoutM,loaluoutM});
	floprc #(32) r6M (clk,rst,flushM,pcE,pcM);
	floprc #(32) r7M (clk,rst,flushM,opE,opM);
	floprc #(5)  r8M (clk,rst,flushM,rdE,rdM);
	floprc #(1)  r9M (clk,rst,flushM,isindelayslotE,isindelayslotM);
	floprc #(8)  r10M (clk,rst,flushM,{exceptionE[7:3],overflow,exceptionE[1:0]},exceptionM);
	floprc #(32) r11M (clk,rst,flushM,instrE,instrM);

	memsel memsel (pcM,opM,aluoutM,writedataM,readdataM,selM,writedata2M,finaldataM,erroraddrM,laddrerrorM,saddrerrorM);

	exceptiondec exceptiondec (rst,exceptionM,laddrerrorM,saddrerrorM,statusout,causeout,epcout,exceptionoccur,exceptiontypeM,pcexceptionM);

	cp0 cp0 (
		.clk 				(clk 			),
		.rst 				(rst 			),
		.we_i 				(cp0writeM 		),
		.waddr_i 			(rdM 			),
		.raddr_i 			(rdE 			),
		.data_i 			(aluoutM 		),
		.int_i 				(6'b0 			),
		.excepttype_i 		(exceptiontypeM	),
		.current_inst_addr_i(pcM 			),
		.is_in_delayslot_i	(isindelayslotM	),
		.bad_addr_i			(erroraddrM		),
		.data_o				(cp0dataoutE 	),
		.count_o			(countout 		),
		.compare_o			(compareout 	),
		.status_o			(statusout 		),    	
		.cause_o			(causeout 		),
		.epc_o				(epcout 		),
		.config_o			(configout 		),
		.prid_o				(pridout 		),
		.badvaddr_o			(badvaddrout 	),
		.timer_int_o		(timerintout	)
	);

	// write back stage
	floprc #(32) r1W (clk,rst,flushW,aluoutM,aluoutW);
	floprc #(32) r2W (clk,rst,flushW,finaldataM,readdataW);
	floprc #(5)  r3W (clk,rst,flushW,writeregM,writeregW);
	floprc #(2)  r4W (clk,rst,flushW,hilowriteM,hilowriteW);
	floprc #(64) r5W (clk,rst,flushW,{hialuoutM,loaluoutM},{hialuoutW,loaluoutW});
	floprc #(32) r6W (clk,rst,flushW,pcM,pcW);
	floprc #(32) r7W (clk,rst,flushW,writedata2M,writedataW);
	floprc #(32) r8W (clk,rst,flushW,instrM,instrW);

	instdec instdec (instrW,ascii);

	mux2 #(32) resmux (aluoutW,readdataW,memtoregW,resultW);
	
endmodule
