`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/23 22:57:01
// Design Name: 
// Module Name: eqcmp
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

module eqcmp(
	input wire [31:0] a,b,
	input wire [5:0] op,
	input wire [5:0] rt,
	output reg y
    );

	always @ (*)
	begin
	 	case (op)
	 		`BEQ:	y <= (a == b);
	 		`BNE:	y <= (a != b);
	 		`BGTZ:	y <= (!a[31] && a != `ZeroWord);
	 		`BLEZ:	y <= (a[31] && a == `ZeroWord);
	 		`REGIMM_INST:
	 		begin
	 			case (rt)
	 				`BLTZ:  y <= (a[31]);
	 				`BLTZAL: y <= (a[31]);
	 				`BGEZ:	 y <= (!a[31]);
	 				`BGEZAL: y <= (!a[31]);
	 				default: y <= 1'b0;
	 			endcase
	 		end
	 		default: y <= 1'b0;
 		endcase
	end 

endmodule
