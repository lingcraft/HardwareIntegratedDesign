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
	output wire [31:0] writedata2M,
	input  wire [31:0] readdataM,
	output wire [3:0] selM 
	);
	
	// decode stage
	wire [5:0] opD;
	wire [5:0] functD;
	wire [4:0] rsD;
	wire [4:0] rtD;
	wire [1:0] hilowriteD;
	wire pcsrcD;
	wire branchD;
	wire equalD;
	wire balD;
	wire jD;
	wire jalD;
	wire jrD;
	wire jalrD;
	wire syscallD;
	wire breakD;
	wire eretD;
	wire invalidityD;

	// execute stage
	wire regdstE;
	wire [1:0] alusrcE;
	wire memtoregE;
	wire regwriteE;
	wire [4:0] alucontrolE;
	wire flushE;
	wire stallE;
	wire overflow;

	// memory visit stage
	wire memtoregM;
	wire regwriteM;
	wire cp0writeM;
	wire flushM;
	wire exceptionoccur;

	// write back stage
	wire memtoregW;
	wire regwriteW;
	wire [31:0] pcW;
	wire [4:0] writeregW;
	wire [31:0] resultW;
	wire flushW;
	
	controller controller (
		.clk			(clk			),
		.rst 			(rst			),
		// decode stage
		.opD 			(opD			),
		.functD			(functD			),
		.rsD 			(rsD 			),
		.rtD			(rtD			),
		.hilowriteD		(hilowriteD		),
		.pcsrcD			(pcsrcD			),
		.branchD		(branchD		),
		.equalD			(equalD			),
		.balD			(balD			),
		.jD				(jD				),
		.jalD			(jalD			),
		.jrD			(jrD			),
		.jalrD			(jalrD			),
		.syscallD		(syscallD		),
		.breakD			(breakD			),
		.eretD			(eretD			),
		.invalidityD	(invalidityD	),
		// execute stage
		.flushE			(flushE			),
		.stallE			(stallE			),
		.memtoregE		(memtoregE		),
		.alusrcE		(alusrcE		),
		.regdstE		(regdstE		),
		.regwriteE		(regwriteE		),	
		.alucontrolE	(alucontrolE	),
		.overflow		(overflow		),
		// memory visit stage
		.memtoregM		(memtoregM		),
		.memwriteM		(memwriteM		),
		.regwriteM		(regwriteM		),
		.cp0writeM		(cp0writeM		),
		.flushM			(flushM			),
		// write back stage
		.memtoregW		(memtoregW		),
		.regwriteW		(regwriteW		),
		.flushW			(flushW			)
	);

	datapath datapath (
		.clk			(clk			),
		.rst 			(rst 			),
		// fetch stage
		.pcF			(pcF			),
		.instrF			(instrF			),
		// decode stage
		.pcsrcD			(pcsrcD			),
		.branchD		(branchD		),
		.equalD			(equalD			),
		.balD			(balD			),
		.jD				(jD				),
		.jalD 			(jalD 			),
		.jrD 			(jrD 			),
		.jalrD 			(jalrD			),
		.opD			(opD			),
		.functD			(functD			),
		.rsD 			(rsD 			),
		.rtD			(rtD			),
		.hilowriteD		(hilowriteD		),
		.syscallD		(syscallD		),
		.breakD			(breakD			),
		.eretD			(eretD			),
		.invalidityD	(invalidityD	),
		// execute stage
		.memtoregE		(memtoregE		),
		.alusrcE 		(alusrcE		),
		.regdstE 		(regdstE		),
		.regwriteE 		(regwriteE		),
		.alucontrolE	(alucontrolE	),
		.flushE			(flushE			),
		.stallE			(stallE			),
		.overflow		(overflow		),
		// memory visit stage
		.memtoregM		(memtoregM		),
		.regwriteM		(regwriteM		),
		.aluoutM		(aluoutM		),
		.writedata2M	(writedata2M	),
		.readdataM		(readdataM		),
		.selM			(selM			),
		.cp0writeM		(cp0writeM		),
		.flushM			(flushM			),
		.exceptionoccur	(exceptionoccur	),
		// write back stage
		.memtoregW		(memtoregW		),
		.regwriteW		(regwriteW		),
		.pcW			(pcW			),
		.writeregW		(writeregW		),
		.resultW		(resultW		),
		.flushW			(flushW			)
	);
	
endmodule
