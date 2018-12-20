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

module divdec(
	input wire divreadyE,
	input wire [4:0] alucontrolE,
	input wire [1:0] hilowriteE,
	output wire divstartE,
	output wire divsignalE,
	output wire signeddivsignalE,
	output wire [1:0] hilowrite2E
    );
	
	assign divstartE = (alucontrolE == `DIV_CONTROL || alucontrolE == `DIVU_CONTROL) && (divreadyE == 1'b0) ? 1'b1:1'b0;

	assign divsignalE = ((alucontrolE == `DIV_CONTROL) || (alucontrolE == `DIVU_CONTROL));

	assign signeddivsignalE = (alucontrolE == `DIV_CONTROL) ? 1'b1:
							  (alucontrolE == `DIVU_CONTROL) ? 1'b0:
							  1'bx;
							  
	assign hilowrite2E = (divsignalE && divreadyE) ? 2'b11:
						 (divsignalE && !divreadyE) ? 2'b00:
						 hilowriteE;

endmodule
