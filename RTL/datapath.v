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
	input wire clk,rst,

	// fetch stage
	output wire [31:0] pcF,
	input wire [31:0] instrF,

	// decode stage
	input wire pcsrcD,branchD,
	input wire jumpD,
	output wire equalD,
	output wire [5:0] opD,functD,
	// hilo reg
	input wire [1:0] hilowriteD,

	// execute stage
	input wire memtoregE,
	input wire [1:0] alusrcE,
	input wire regdstE,
	input wire regwriteE,
	input wire [4:0] alucontrolE,
	output wire flushE,
	output wire stallE,

	// memory visit stage
	input wire memtoregM,
	input wire regwriteM,
	output wire [31:0] aluoutM,writedataM,
	input wire [31:0] readdataM,

	// write back stage
	input wire memtoregW,
	input wire regwriteW
    );
	
	// fetch stage
	wire stallF;

	// FD
	wire [31:0] pcnextFD,pcnextbrFD,pcplus4F,pcbranchD;

	// decode stage
	wire [31:0] pcplus4D,instrD;
	wire forwardaD,forwardbD;
	wire [4:0] rsD,rtD,rdD,saD;
	wire flushD,stallD;
	wire [31:0] signimmD,signimmshD;
	wire [31:0] zeroimmD;
	wire [31:0] srcaD,srca2D,srcbD,srcb2D;
	// hilo reg
	wire [31:0] hioutD,looutD;

	// execute stage
	wire [1:0] forwardaE,forwardbE;
	wire [1:0] forwardhiloE;
	wire [4:0] rsE,rtE,rdE,saE;
	wire [4:0] writeregE;
	wire [31:0] signimmE;
	wire [31:0] zeroimmE;
	wire [31:0] srcaE,srca2E,srcbE,srcb2E,srcb3E;
	wire [31:0] aluoutE;
	// hilo reg
	wire [1:0] hilowriteE;
	wire [31:0] hioutE,looutE;
	wire [31:0] hiout2E,loout2E;
	wire [31:0] hialuoutE,loaluoutE;
	wire overflow;
	wire [31:0] hidivoutE,lodivoutE;
	wire [31:0] hialuout2E,loaluout2E;
	wire divsignalE;
	wire divstartE;
	wire divreadyE;

	// memory visit stage
	wire [4:0] writeregM;
	// hilo reg
	wire [1:0] hilowriteM;
	wire [31:0] hialuoutM,loaluoutM;

	// write back stage
	wire [4:0] writeregW;
	wire [31:0] aluoutW,readdataW,resultW;
	// hilo reg
	wire [1:0] hilowriteW;
	wire [31:0] hialuoutW,loaluoutW;

	// hazard detection
	hazard h(
		// fetch stage
		stallF,
		// decode stage
		rsD,rtD,
		branchD,
		forwardaD,forwardbD,
		stallD,
		// execute stage
		rsE,rtE,
		writeregE,
		regwriteE,
		memtoregE,
		hilowriteE,
		forwardaE,forwardbE,forwardhiloE,
		flushE,
		stallE,
		divstartE,
		// memory visit stage
		writeregM,
		regwriteM,
		memtoregM,
		hilowriteM,
		// write back stage
		writeregW,
		regwriteW,
		hilowriteW
		);

	// next PC logic (operates in fetch an decode)
	mux2 #(32) pcbrmux(pcplus4F,pcbranchD,pcsrcD,pcnextbrFD);
	mux2 #(32) pcmux(pcnextbrFD,
		{pcplus4D[31:28],instrD[25:0],2'b00},
		jumpD,pcnextFD);

	// regfile (operates in decode and writeback)
	regfile rf(clk,regwriteW,rsD,rtD,writeregW,resultW,srcaD,srcbD);
	hiloreg hilo(clk,rst,hilowriteW,hialuoutW,loaluoutW,hioutD,looutD);


	// fetch stage logic
	flopenr #(32) pcreg(clk,rst,~stallF,pcnextFD,pcF);
	adder pcadd1(pcF,32'b100,pcplus4F);


	// decode stage
	flopenr #(32) r1D(clk,rst,~stallD,pcplus4F,pcplus4D);
	flopenrc #(32) r2D(clk,rst,~stallD,flushD,instrF,instrD);
	signext se(instrD[15:0],signimmD);
	zeroext ze(instrD[15:0],zeroimmD);
	sl2 immsh(signimmD,signimmshD);
	adder pcadd2(pcplus4D,signimmshD,pcbranchD);
	mux2 #(32) forwardamux(srcaD,aluoutM,forwardaD,srca2D);
	mux2 #(32) forwardbmux(srcbD,aluoutM,forwardbD,srcb2D);
	eqcmp comp(srca2D,srcb2D,equalD);

	assign opD = instrD[31:26];
	assign functD = instrD[5:0];
	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];
	assign saD = instrD[10:6]; 


	// execute stage
	flopenrc #(32) r1E(clk,rst,~stallE,flushE,srcaD,srcaE);
	flopenrc #(32) r2E(clk,rst,~stallE,flushE,srcbD,srcbE);
	flopenrc #(32) r3E(clk,rst,~stallE,flushE,signimmD,signimmE);
	flopenrc #(5) r4E(clk,rst,~stallE,flushE,rsD,rsE);
	flopenrc #(5) r5E(clk,rst,~stallE,flushE,rtD,rtE);
	flopenrc #(5) r6E(clk,rst,~stallE,flushE,rdD,rdE);
	flopenrc #(32) r7E(clk,rst,~stallE,flushE,zeroimmD,zeroimmE);
	flopenrc #(5) r8E(clk,rst,~stallE,flushE,saD,saE);

	flopenrc #(2) r9E(clk,rst,~stallE,flushE,hilowriteD,hilowriteE);
	flopenrc #(64) r10E(clk,rst,~stallE,flushE,{hioutD,looutD},{hioutE,looutE});

	mux3 #(32) forwardaemux(srcaE,resultW,aluoutM,forwardaE,srca2E);
	mux3 #(32) forwardbemux(srcbE,resultW,aluoutM,forwardbE,srcb2E);
	mux3 #(32) forwardhimux(hioutE,hialuoutM,hialuoutW,forwardhiloE,hiout2E);
	mux3 #(32) forwardlomux(looutE,loaluoutM,loaluoutW,forwardhiloE,loout2E);
	// mux2 #(32) srcbmux(srcb2E,signimmE,alusrcE,srcb3E);
	mux3 #(32) srcbmux(srcb2E,signimmE,zeroimmE,alusrcE,srcb3E);
	alu alu(srca2E,srcb3E,saE,alucontrolE,hiout2E,loout2E,aluoutE,hialuoutE,loaluoutE,overflow);
	mux2 #(5) wrmux(rtE,rdE,regdstE,writeregE);

	divjudger divjudge(divreadyE,alucontrolE,divstartE,divsignalE,signeddivsignalE);
	divider division(clk,rst,signeddivsignalE,srca2E,srcb3E,divstartE,1'b0,{hidivoutE,lodivoutE},divreadyE);
	mux2 #(32) hidiv(hialuoutE,hidivoutE,divsignalE,hialuout2E);
	mux2 #(32) lodiv(loaluoutE,lodivoutE,divsignalE,loaluout2E);


	// memory visit stage
	flopr #(32) r1M(clk,rst,srcb2E,writedataM);
	flopr #(32) r2M(clk,rst,aluoutE,aluoutM);
	flopr #(5) r3M(clk,rst,writeregE,writeregM);

	flopr #(2)	r4M(clk,rst,hilowriteE,hilowriteM);
	// flopr #(64) r5M(clk,rst,{hialuoutE,loaluoutE},{hialuoutM,loaluoutM});
	flopr #(64) r5M(clk,rst,{hialuout2E,loaluout2E},{hialuoutM,loaluoutM});


	// write back stage
	flopr #(32) r1W(clk,rst,aluoutM,aluoutW);
	flopr #(32) r2W(clk,rst,readdataM,readdataW);
	flopr #(5) r3W(clk,rst,writeregM,writeregW);

	flopr #(2) r4W(clk,rst,hilowriteM,hilowriteW);
	flopr #(64) r5W(clk,rst,{hialuoutM,loaluoutM},{hialuoutW,loaluoutW});

	mux2 #(32) resmux(aluoutW,readdataW,memtoregW,resultW);
	
endmodule
