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
	input  wire [4:0] rtD,
	output wire pcsrcD,
	output wire branchD,
	input  wire equalD,
	output wire balD,
	output wire jumpD,
	output wire jalD,
	output wire jrD,
	output wire jalrD,
	output wire [1:0] hilowriteD,
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
	// write back stage
	output wire memtoregW,
	output wire regwriteW
    );
	
	// decode stage
	wire [3:0] aluopD;
	wire memtoregD;
	wire memwriteD;
	wire [1:0] alusrcD;
	wire regdstD;
	wire regwriteD;
	wire [4:0] alucontrolD;
	// execute stage
	wire memwriteE;

	maindec md (
		.op 		(opD		),
		.funct 		(functD		),
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
		.jump 		(jumpD		),
		.jal 		(jalD 		),
		.jr 		(jrD 		),
		.jalr 		(jalrD 		)
	);

	aludec ad (
		.funct 		(functD		),
		.aluop 		(aluopD		),
		.alucontrol	(alucontrolD)
	);

	assign pcsrcD = branchD & equalD;

	flopenrc #(11) regE (
		clk,
		rst,
		~stallE,
		flushE,
		{memtoregD,memwriteD,alusrcD,regdstD,regwriteD,alucontrolD},
		{memtoregE,memwriteE,alusrcE,regdstE,regwriteE,alucontrolE}
	);
	
	flopr #(3) regM (
		clk,rst,
		{memtoregE,memwriteE,regwriteE & ~overflow},
		{memtoregM,memwriteM,regwriteM}
	);

	flopr #(2) regW (
		clk,rst,
		{memtoregM,regwriteM},
		{memtoregW,regwriteW}
	);

endmodule
