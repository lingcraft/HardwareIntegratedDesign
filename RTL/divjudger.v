`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/12 18:13:31
// Design Name: 
// Module Name: divjudger
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

`include "defines.vh"

module divjudger(
	input wire divready,
	input wire [4:0] alucontrolE,
	output wire divstart,
	output wire divsignalE,
	output wire signeddivsignalE
    );
	
	assign divstart = (alucontrolE == `DIV_CONTROL || alucontrolE == `DIVU_CONTROL) && (divready == 1'b0) ? 1'b1 : 1'b0;

	assign divsignalE = ((alucontrolE == `DIV_CONTROL) || (alucontrolE == `DIVU_CONTROL));

	assign signeddivsignalE = (alucontrolE == `DIV_CONTROL) ? 1'b1:
							  (alucontrolE == `DIVU_CONTROL) ? 1'b0:
							  1'bx;

endmodule
