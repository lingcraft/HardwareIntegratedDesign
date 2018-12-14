`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


module mips(
	input  wire clk,
	input  wire rst,
	output wire [31:0] pcF,
	input  wire [31:0] instrF,
	output wire memwriteM,
	output wire [31:0] aluoutM,
	output wire [31:0] writedataM,
	input  wire [31:0] readdataM 
	);
	
	wire [5:0] opD;
	wire [5:0] functD;
	wire [5:0] rtD;
	wire pcsrcD;
	wire branchD;
	wire equalD;
	wire balD;
	wire jumpD;
	wire jalD;
	wire jrD;
	wire jalrD;
	wire [1:0] hilowriteD;

	wire regdstE;
	wire [1:0] alusrcE;
	wire memtoregE;
	wire regwriteE;
	wire [4:0] alucontrolE;
	wire flushE;
	wire stallE;

	wire memtoregM;
	wire regwriteM;

	wire memtoregW;
	wire regwriteW;
	
	controller c(
		.clk		(clk		),
		.rst 		(rst		),
		// decode stage
		.opD 		(opD		),
		.functD		(functD		),
		.rtD		(rtD		),
		.pcsrcD		(pcsrcD		),
		.branchD	(branchD	),
		.equalD		(equalD		),
		.balD		(balD		),
		.jumpD		(jumpD		),
		.jalD		(jalD		),
		.jrD		(jrD		),
		.jalrD		(jalrD		),
		.hilowriteD	(hilowriteD	),
		// execute stage
		.flushE		(flushE		),
		.stallE		(stallE		),
		.memtoregE	(memtoregE	),
		.alusrcE	(alusrcE	),
		.regdstE	(regdstE	),
		.regwriteE	(regwriteE	),	
		.alucontrolE(alucontrolE),
		// memory visit stage
		.memtoregM	(memtoregM	),
		.memwriteM	(memwriteM	),
		.regwriteM	(regwriteM	),
		// write back stage
		.memtoregW	(memtoregW	),
		.regwriteW	(regwriteW	)
	);

	datapath dp(
		.clk		(clk		),
		.rst 		(rst 		),
		// fetch stage
		.pcF		(pcF		),
		.instrF		(instrF		),
		// decode stage
		.pcsrcD		(pcsrcD		),
		.branchD	(branchD	),
		.equalD		(equalD		),
		.balD		(balD		),
		.jumpD		(jumpD		),
		.jalD 		(jalD 		),
		.jrD 		(jrD 		),
		.jalrD 		(jalrD		),
		.opD		(opD		),
		.functD		(functD		),
		.rtD		(rtD		),
		.hilowriteD	(hilowriteD	),
		// execute stage
		.memtoregE	(memtoregE	),
		.alusrcE 	(alusrcE	),
		.regdstE 	(regdstE	),
		.regwriteE 	(regwriteE	),
		.alucontrolE(alucontrolE),
		.flushE		(flushE		),
		.stallE		(stallE		),
		// memory visit stage
		.memtoregM	(memtoregM	),
		.regwriteM	(regwriteM	),
		.aluoutM	(aluoutM	),
		.writedataM	(writedataM	),
		.readdataM	(readdataM	),
		// write back stage
		.memtoregW	(memtoregW	),
		.regwriteW	(regwriteW	)
	);
	
endmodule
