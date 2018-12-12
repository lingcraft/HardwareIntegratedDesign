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
	input wire [4:0] rsD,
	input wire [4:0] rtD,
	input wire branchD,
	output wire forwardaD,
	output wire forwardbD,
	output wire stallD,
	// execute stage
	input wire [4:0] rsE,
	input wire [4:0] rtE,
	input wire [4:0] writeregE,
	input wire regwriteE,
	input wire memtoregE,
	input wire [1:0] hilowriteE,
	output reg [1:0] forwardaE,
	output reg [1:0] forwardbE,
	output wire [1:0] forwardhiloE,
	output wire flushE,
	output wire stallE,
	input wire divstart,
	// memory visit stage
	input wire [4:0] writeregM,
	input wire regwriteM,
	input wire memtoregM,
	input wire [1:0] hilowriteM,
	// write back stage
	input wire [4:0] writeregW,
	input wire regwriteW,
	input wire [1:0] hilowriteW
    );

	wire lwstallD;
	wire branchstallD;

	assign forwardaD = (rsD && (rsD == writeregM) && regwriteM);
	assign forwardbD = (rtD && (rtD == writeregM) && regwriteM);
	assign forwardhiloE = (!hilowriteE && hilowriteM) ? 2'b01:
						  (!hilowriteE && hilowriteW) ? 2'b10:
						  2'b00;

	always @ (*)
	begin
		forwardaE = 2'b00;
		forwardbE = 2'b00;
		if (rsE)
		begin
			if ((rsE == writeregM) && regwriteM)
				forwardaE = 2'b10;
			else if ((rsE == writeregW) && regwriteW)
				forwardaE = 2'b01;
		end
		if (rtE)
		begin
			if ((rtE == writeregM) && regwriteM)
				forwardbE = 2'b10;
			else if ((rtE == writeregW) && regwriteW)
				forwardbE = 2'b01;
		end
	end

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
