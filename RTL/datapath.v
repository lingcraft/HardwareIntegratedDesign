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
	input  wire jumpD,
	input  wire jalD,
	input  wire jrD,
	input  wire jalrD,
	output wire [5:0] opD,
	output wire [5:0] functD,
	output wire [4:0] rtD,
	input  wire [1:0] hilowriteD,
	// execute stage
	input  wire memtoregE,
	input  wire [1:0] alusrcE,
	input  wire regdstE,
	input  wire regwriteE,
	input  wire [4:0] alucontrolE,
	output wire flushE,
	output wire stallE,
	// memory visit stage
	input  wire memtoregM,
	input  wire regwriteM,
	output wire [31:0] aluoutM,
	output wire [31:0] writedata2M,
	input  wire [31:0] readdataM,
	output wire [3:0] selM,
	// write back stage
	input  wire memtoregW,
	input  wire regwriteW
    );
	
	// fetch stage
	wire stallF;
	// FD
	wire [31:0] pcnextFD;
	wire [31:0] pcnextbrFD;
	wire [31:0] pcnextjrFD;
	wire [31:0] pcplus4F;
	wire [31:0] pcbranchD;
	// decode stage
	wire [31:0] pcD;
	wire [31:0] pcplus4D;
	wire [31:0] instrD;
	wire forwardaD;
	wire forwardbD;
	wire [4:0] rsD;
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
	// execute stage
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
	wire overflow;
	wire [31:0] hidivoutE;
	wire [31:0] lodivoutE;
	wire [31:0] hialuout2E;
	wire [31:0] loaluout2E;
	wire divsignalE;
	wire divstartE;
	wire divreadyE;
	wire [31:0] pcplus8E;
	wire balE;		
	wire jalE;
	wire jalrE;
	// memory visit stage
	wire [31:0] pcM;
	wire [5:0] opM;
	wire [4:0] writeregM;
	wire [1:0] hilowriteM;
	wire [31:0] hialuoutM;
	wire [31:0] loaluoutM;
	wire balM;
	wire jalM;
	wire jalrM;
	wire [31:0] writedataM;
	wire [31:0] finaldataM;
	wire [31:0] erroraddrM;
	wire laddrerrorM;
	wire saddrerrorM;
	// write back stage
	wire [31:0] pcW;
	wire [4:0] writeregW;
	wire [31:0] aluoutW;
	wire [31:0] readdataW;
	wire [31:0] resultW;
	wire [1:0] hilowriteW;
	wire [31:0] hialuoutW;
	wire [31:0] loaluoutW;
	wire balW;
	wire jalW;
	wire jalrW;

	// hazard detection
	hazard h (
		// fetch stage
		.stallF 		(stallF			),
		// decode stage
		.rsD 			(rsD 			),
		.rtD 			(rtD 			),
		.branchD		(branchD		),
		.forwardaD		(forwardaD		),
		.forwardbD		(forwardbD		),
		.stallD			(stallD			),
		// execute stage
		.rsE 			(rsE 			),
		.rtE 			(rtE 			),
		.writeregE 		(writereg2E		),
		.regwriteE	 	(regwriteE		),
		.memtoregE	 	(memtoregE		),
		.hilowriteE 	(hilowriteE		),
		.forwardaE 		(forwardaE 		),
		.forwardbE 		(forwardbE 		),
		.forwardhiloE	(forwardhiloE	),
		.flushE			(flushE			),
		.stallE			(stallE			),
		.divstart		(divstartE		),
		// memory visit stage
		.writeregM		(writeregM		),
		.regwriteM		(regwriteM		),
		.memtoregM		(memtoregM		),
		.hilowriteM		(hilowriteM		),
		// write back stage
		.writeregW		(writeregW		),
		.regwriteW		(regwriteW		),
		.hilowriteW		(hilowriteW		)
	);

	// next PC logic (operates in fetch an decode)
	mux2 #(32) pcbrmux (pcplus4F,pcbranchD,pcsrcD,pcnextbrFD);
	mux2 #(32) pcjrmux (pcnextbrFD,srca2D,jrD | jalrD,pcnextjrFD);
	mux2 #(32) pcmux (pcnextjrFD,{pcplus4D[31:28],instrD[25:0],2'b00},jumpD | jalD,pcnextFD);

	// regfile (operates in decode and writeback)
	regfile rf (clk,regwriteW,rsD,rtD,writeregW,resultW,srcaD,srcbD);
	hiloreg hilo (clk,rst,hilowriteW,hialuoutW,loaluoutW,hioutD,looutD);


	// fetch stage logic
	flopenr #(32) pcreg (clk,rst,~stallF,pcnextFD,pcF);
	adder pcadd1 (pcF,32'd4,pcplus4F);


	// decode stage
	flopenr #(32) r1D (clk,rst,~stallD,pcplus4F,pcplus4D);
	flopenrc #(32) r2D (clk,rst,~stallD,flushD,instrF,instrD);
	flopenr #(32) r3D (clk,rst,~stallD,pcF,pcD);

	signext se (instrD[15:0],signimmD);
	zeroext ze (instrD[15:0],zeroimmD);
	sl2 immsh (signimmD,signimmshD);
	adder pcadd2 (pcplus4D,signimmshD,pcbranchD);
	mux2 #(32) forwardamux (srcaD,aluoutM,forwardaD,srca2D);
	mux2 #(32) forwardbmux (srcbD,aluoutM,forwardbD,srcb2D);
	eqcmp comp (srca2D,srcb2D,opD,rtD,equalD);

	assign opD = instrD[31:26];
	assign functD = instrD[5:0];
	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];
	assign saD = instrD[10:6]; 


	// execute stage
	flopenrc #(32) r1E (clk,rst,~stallE,flushE,srcaD,srcaE);
	flopenrc #(32) r2E (clk,rst,~stallE,flushE,srcbD,srcbE);
	flopenrc #(32) r3E (clk,rst,~stallE,flushE,signimmD,signimmE);
	flopenrc #(5) r4E (clk,rst,~stallE,flushE,rsD,rsE);
	flopenrc #(5) r5E (clk,rst,~stallE,flushE,rtD,rtE);
	flopenrc #(5) r6E (clk,rst,~stallE,flushE,rdD,rdE);
	flopenrc #(32) r7E (clk,rst,~stallE,flushE,zeroimmD,zeroimmE);
	flopenrc #(5) r8E (clk,rst,~stallE,flushE,saD,saE);
	flopenrc #(2) r9E (clk,rst,~stallE,flushE,hilowriteD,hilowriteE);
	flopenrc #(64) r10E (clk,rst,~stallE,flushE,{hioutD,looutD},{hioutE,looutE});
	flopenr #(1) r11E (clk,rst,~stallE,balD,balE);
	flopenr #(32) r12E (clk,rst,~stallE,pcD,pcE);
	flopenr #(1) r13E (clk,rst,~stallE,jalD,jalE);
	flopenr #(1) r14E (clk,rst,~stallE,jalrD,jalrE);
	flopenr #(32) r15E (clk,rst,~stallE,opD,opE);

	mux3 #(32) forwardaemux (srcaE,resultW,aluoutM,forwardaE,srca2E);
	mux3 #(32) forwardbemux (srcbE,resultW,aluoutM,forwardbE,srcb2E);
	mux3 #(32) forwardhimux (hioutE,hialuoutM,hialuoutW,forwardhiloE,hiout2E);
	mux3 #(32) forwardlomux (looutE,loaluoutM,loaluoutW,forwardhiloE,loout2E);
	mux3 #(32) srcbmux (srcb2E,signimmE,zeroimmE,alusrcE,srcb3E);

	alu alu (srca2E,srcb3E,saE,alucontrolE,hiout2E,loout2E,aluoutE,hialuoutE,loaluoutE,overflow);
	mux2 #(5) wrmux (rtE,rdE,regdstE,writeregE);
	mux2 #(5) wrmux2 (writeregE,5'd31,balE | jalE,writereg2E);
	mux2 #(32) wrmux3 (aluoutE,pcE + 32'd8,balE | jalE | jalrE,aluout2E);

	divjudger divjudge (divreadyE,alucontrolE,hilowriteE,divstartE,divsignalE,signeddivsignalE,hilowrite2E);
	divider division (clk,rst,signeddivsignalE,srca2E,srcb3E,divstartE,1'b0,{hidivoutE,lodivoutE},divreadyE);
	mux2 #(32) hidiv (hialuoutE,hidivoutE,divsignalE,hialuout2E);
	mux2 #(32) lodiv (loaluoutE,lodivoutE,divsignalE,loaluout2E);


	// memory visit stage
	flopr #(32) r1M (clk,rst,srcb2E,writedataM);
	flopr #(32) r2M (clk,rst,aluout2E,aluoutM);
	flopr #(5) r3M (clk,rst,writereg2E,writeregM);
	flopr #(2)	r4M (clk,rst,hilowrite2E,hilowriteM);
	flopr #(64) r5M (clk,rst,{hialuout2E,loaluout2E},{hialuoutM,loaluoutM});
	flopr #(32) r6M (clk,rst,pcE,pcM);
	flopr #(32) r7M (clk,rst,opE,opM);
	flopr #(1) r8M (clk,rst,balE,balM);
	flopr #(1) r9M (clk,rst,jalE,jalM);
	flopr #(1) r10M (clk,rst,jalrE,jalrM);

	memsel memsel (pcM,opM,aluoutM,writedataM,readdataM,selM,writedata2M,finaldataM,erroraddrM,laddrerrorM,saddrerrorM);


	// write back stage
	flopr #(32) r1W (clk,rst,aluoutM,aluoutW);
	flopr #(32) r2W (clk,rst,finaldataM,readdataW);
	flopr #(5) r3W (clk,rst,writeregM,writeregW);
	flopr #(2) r4W (clk,rst,hilowriteM,hilowriteW);
	flopr #(64) r5W (clk,rst,{hialuoutM,loaluoutM},{hialuoutW,loaluoutW});
	flopr #(32) r6W (clk,rst,pcM,pcW);
	flopr #(1) r7W (clk,rst,balM,balW);
	flopr #(1) r8W (clk,rst,jalM,jalW);
	flopr #(1) r9W (clk,rst,jalrM,jalrW);

	mux2 #(32) resmux (aluoutW,readdataW,memtoregW,resultW);
	
endmodule
