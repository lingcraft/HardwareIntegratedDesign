`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: controller
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


module controller(
	input  wire clk,
	input  wire rst,
	// decode stage
	input  wire [5:0] opD,
	input  wire [5:0] functD,
	input  wire [4:0] rsD,
	input  wire [4:0] rtD,
	output wire [1:0] hilowriteD,
	output wire pcsrcD,
	output wire branchD,
	input  wire equalD,
	output wire balD,
	output wire jD,
	output wire jalD,
	output wire jrD,
	output wire jalrD,
	output wire syscallD,
	output wire breakD,
	output wire eretD,
	output wire invalidityD,
	// execute stage
	input  wire flushE,
	input  wire stallE,
	output wire memtoregE,
	output wire [1:0] alusrcE,
	output wire regdstE,
	output wire regwriteE,	
	output wire [4:0] alucontrolE,
	input  wire overflow,
	// memory visit stage
	output wire memtoregM,
	output wire memwriteM,
	output wire	regwriteM,
	output wire cp0writeM,
	input  wire flushM,
	// write back stage
	output wire memtoregW,
	output wire regwriteW,
	input  wire flushW
    );
	
	// decode stage
	wire [3:0] aluopD;
	wire memtoregD;
	wire memwriteD;
	wire [1:0] alusrcD;
	wire regdstD;
	wire regwriteD;
	wire [4:0] alucontrolD;
	wire cp0writeD;
	// execute stage
	wire memwriteE;
	wire cp0writeE;

	maindec maindec (
		.op 		(opD		),
		.funct 		(functD		),
		.rs			(rsD		),
		.rt 		(rtD 		),
		.aluop 		(aluopD		),
		.alusrc 	(alusrcD	),
		.hilowrite 	(hilowriteD	),
		.regwrite 	(regwriteD	),
		.regdst 	(regdstD	),
		.memwrite 	(memwriteD	),
		.memtoreg 	(memtoregD	),
		.branch 	(branchD	),
		.bal 		(balD		),
		.j 			(jD			),
		.jal 		(jalD 		),
		.jr 		(jrD 		),
		.jalr 		(jalrD 		),
		.cp0write	(cp0writeD	),
		.syscall 	(syscallD	),
		.break		(breakD		),
		.eret		(eretD		),
		.invalidity (invalidityD)
	);

	aludec aludec (
		.funct 		(functD		),
		.aluop 		(aluopD		),
		.alucontrol	(alucontrolD)
	);

	assign pcsrcD = branchD & equalD;

	flopenrc #(12) regE (
		clk,
		rst,
		~stallE,
		flushE,
		{memtoregD,memwriteD,alusrcD,regdstD,regwriteD,alucontrolD,cp0writeD},
		{memtoregE,memwriteE,alusrcE,regdstE,regwriteE,alucontrolE,cp0writeE}
	);
	
	floprc #(4) regM (
		clk,rst,flushM,
		{memtoregE,memwriteE,regwriteE & ~overflow,cp0writeE},
		{memtoregM,memwriteM,regwriteM,cp0writeM}
	);

	floprc #(2) regW (
		clk,rst,flushW,
		{memtoregM,regwriteM},
		{memtoregW,regwriteW}
	);

endmodule
