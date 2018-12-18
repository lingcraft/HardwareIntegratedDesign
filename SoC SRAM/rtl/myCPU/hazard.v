`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/09 01:26:18
// Design Name: 
// Module Name: hazard
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


module hazard(
	// fetch stage
	output wire stallF,
	// decode stage
	input  wire [4:0] rsD,
	input  wire [4:0] rtD,
	input  wire branchD,
	output wire [1:0] forwardaD,
	output wire [1:0] forwardbD,
	output wire stallD,
	output wire forwardb2D,
	// execute stage
	input  wire [4:0] rsE,
	input  wire [4:0] rtE,
	input  wire [4:0] rdE,
	input  wire [4:0] writeregE,
	input  wire regwriteE,
	input  wire memtoregE,
	input  wire [1:0] hilowriteE,
	output wire [1:0] forwardaE,
	output wire [1:0] forwardbE,
	output wire [1:0] forwardhiloE,
	output wire flushE,
	output wire stallE,
	input  wire divstart,
	// memory visit stage
	input  wire [4:0] writeregM,
	input  wire regwriteM,
	input  wire memtoregM,
	input  wire [1:0] hilowriteM,
	// write back stage
	input  wire [4:0] writeregW,
	input  wire regwriteW,
	input  wire [1:0] hilowriteW
    );

	wire lwstallD;
	wire branchstallD;

	assign forwardaD = (rsD && (rsD == writeregE) && regwriteE) ? 2'b01:
					   (rsD && (rsD == writeregM) && regwriteM) ? 2'b10:
					   (rsD && (rsD == writeregW) && regwriteW) ? 2'b11:2'b00;

	assign forwardbD = (rtD && (rtD == writeregE) && regwriteE) ? 2'b01:
					   (rtD && (rtD == writeregM) && regwriteM) ? 2'b10:
					   (rtD && (rtD == writeregW) && regwriteW) ? 2'b11:2'b00;

	assign forwardaE = (rsE && (rsE == writeregM) && regwriteM) ? 2'b01:
					   (rsE && (rsE == writeregW) && regwriteW) ? 2'b10:2'b00;

	assign forwardbE = (rtE && (rtE == writeregM) && regwriteM) ? 2'b01:
					   (rtE && (rtE == writeregW) && regwriteW) ? 2'b10:2'b00;

	assign forwardhiloE = (!hilowriteE && hilowriteM) ? 2'b01:
						  (!hilowriteE && hilowriteW) ? 2'b10:2'b00;



	assign lwstallD = memtoregE && ((rtE == rsD) || (rtE == rtD));

	assign branchstallD = branchD && 
			(regwriteE &&
			((writeregE == rsD) || (writeregE == rtD))|| 
			memtoregM &&
			((writeregM == rsD) || (writeregM == rtD)));

	assign stallF = lwstallD || branchstallD || divstart;
	assign stallD = lwstallD || branchstallD || divstart;
	assign flushE = lwstallD || branchstallD;
	assign stallE = divstart;

endmodule
