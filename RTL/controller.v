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
	input wire clk,rst,
	// decode stage
	input wire [5:0] opD,functD,rtD,
	output wire pcsrcD,branchD,
	input wire equalD,
	output wire jumpD,
	output wire balD,
	output wire [1:0] hilowriteD,
	
	// execute stage
	input wire flushE,
	input wire stallE,
	output wire memtoregE,
	output wire [1:0] alusrcE,
	output wire regdstE,regwriteE,	
	output wire [4:0] alucontrolE,

	// memory visit stage
	output wire memtoregM,memwriteM,
				regwriteM,
	// write back stage
	output wire memtoregW,regwriteW

    );
	
	// decode stage
	wire [3:0] aluopD;
	wire memtoregD,memwriteD;
	wire [1:0] alusrcD;
	wire regdstD,regwriteD;

	wire [4:0] alucontrolD;

	// execute stage
	wire memwriteE;

	maindec md(
		opD,functD,rtD,
		memtoregD,memwriteD,
		branchD,alusrcD,
		regdstD,regwriteD,
		jumpD,
		balD,
		aluopD,
		hilowriteD
		);
	aludec ad(functD,aluopD,alucontrolD);

	assign pcsrcD = branchD & equalD;

	flopenrc #(11) regE(
		clk,
		rst,
		~stallE,
		flushE,
		{memtoregD,memwriteD,alusrcD,regdstD,regwriteD,alucontrolD},
		{memtoregE,memwriteE,alusrcE,regdstE,regwriteE,alucontrolE}
		);
	
	flopr #(3) regM(
		clk,rst,
		{memtoregE,memwriteE,regwriteE},
		{memtoregM,memwriteM,regwriteM}
		);
	flopr #(2) regW(
		clk,rst,
		{memtoregM,regwriteM},
		{memtoregW,regwriteW}
		);

endmodule
