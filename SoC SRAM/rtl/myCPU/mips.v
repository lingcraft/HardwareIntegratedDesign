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
	// input  wire clk,
	// input  wire rst,
	// output wire [31:0] pcF,
	// input  wire [31:0] instrF,
	// output wire memwriteM,
	// output wire [31:0] aluoutM,
	// output wire [31:0] writedata2M,
	// input  wire [31:0] readdataM,
	// output wire [3:0] selM
	input  wire clk,
	input  wire resetn,
	input  wire [5:0] int,

	output wire inst_sram_en,
	output wire [3:0] inst_sram_wen,
	output wire [31:0] inst_sram_addr,
	output wire [31:0] inst_sram_wdata,
	input  wire [31:0] inst_sram_rdata,

	output wire data_sram_en,
	output wire [3:0] data_sram_wen,
	output wire [31:0] data_sram_addr,
	output wire [31:0] data_sram_wdata,
	input  wire [31:0] data_sram_rdata,

	output wire [31:0] debug_wb_pc,
	output wire [3:0] debug_wb_rf_wen,
	output wire [4:0] debug_wb_rf_wnum,
	output wire [31:0] debug_wb_rf_wdata
	);
	
	wire [31:0] pcF;
	wire [31:0] instrF;
	wire memwriteM;
	wire [31:0] aluoutM;
	wire [31:0] writedata2M;
	wire [31:0] readdataM;
	wire [3:0] selM;
	wire [4:0] writeregW;
	wire [31:0] pcW;
	wire [31:0] resultW;

	assign rst = resetn;
	assign inst_sram_en = 1'b1;
	assign inst_sram_wen = 1'b0;
	assign inst_sram_addr = pcF;
	assign inst_sram_wdata = 32'b0;
	assign instrF = inst_sram_rdata;

	assign data_sram_en = memwriteM;
	assign data_sram_wen = selM;
	assign data_sram_addr = aluoutM;
	assign data_sram_wdata = writedata2M;
	assign readdataM = data_sram_rdata;

	assign debug_wb_pc = pcW;
	assign debug_wb_rf_wen = (regwriteW == 1) ? 4'b1111 : 4'b0000;
	assign debug_wb_rf_wnum = writeregW;
	assign debug_wb_rf_wdata = resultW;
	
	wire [5:0] opD;
	wire [5:0] functD;
	wire [4:0] rtD;
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
	wire overflow;

	wire memtoregM;
	wire regwriteM;

	wire memtoregW;
	wire regwriteW;
	
	controller c (
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
		.overflow	(overflow	),
		// memory visit stage
		.memtoregM	(memtoregM	),
		.memwriteM	(memwriteM	),
		.regwriteM	(regwriteM	),
		// write back stage
		.memtoregW	(memtoregW	),
		.regwriteW	(regwriteW	)
	);

	datapath dp (
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
		.overflow	(overflow	),
		// memory visit stage
		.memtoregM	(memtoregM	),
		.regwriteM	(regwriteM	),
		.aluoutM	(aluoutM	),
		.writedata2M(writedata2M),
		.readdataM	(readdataM	),
		.selM		(selM		),
		// write back stage
		.pcW		(pcW		),
		.memtoregW	(memtoregW	),
		.regwriteW	(regwriteW	),
		.writeregW	(writeregW	),
		.resultW	(resultW	)
	);
	
endmodule
