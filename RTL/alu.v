`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/14 22:19:49
// Design Name: 
// Module Name: calculate
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

module alu(
	input wire [31:0] a,
	input wire [31:0] b,
	input wire [4:0] sa,
	input wire [4:0] alucontrol,
	input wire [31:0] hialuin,
	input wire [31:0] loaluin,
	output reg [31:0] y,
	output reg [31:0] hialuout,
	output reg [31:0] loaluout
	//output wire overflow,
	//output wire zero
    );

	always @ (*)
	begin
		case (alucontrol)
			// 逻辑运算指令
			`AND_CONTROL:	y <= a & b;
			`OR_CONTROL: 	y <= a | b;
			`XOR_CONTROL:	y <= a ^ b;
			`NOR_CONTROL:	y <= ~(a | b);
			`LUI_CONTROL:	y <= {b[15:0], 16'b0};

			// 移位指令
			`SLL_CONTROL:	y <= b << sa;
			`SRL_CONTROL:	y <= b >> sa;
			`SRA_CONTROL:	y <= b >> sa | ({32{b[31]}} << (6'd32 - {1'b0,sa}));
			`SLLV_CONTROL:	y <= b << a[4:0];
			`SRLV_CONTROL:	y <= b >> a[4:0];
			`SRAV_CONTROL:	y <= b >> a[4:0] | ({32{b[31]}} << (6'd32 - {1'b0,a[4:0]}));

			// 数据移动指令
			`MFHI_CONTROL:	y <= hialuin;
			`MFLO_CONTROL:	y <= loaluin;
			`MTHI_CONTROL:	hialuout <= a;
			`MTLO_CONTROL:	loaluout <= a; 

			// 3'b100: y <= a & ~b;
			// 3'b101: y <= a | ~b;
			`ADD_CONTROL: y <= a + b;
			`SUB_CONTROL: y <= a - b;
			`SLT_CONTROL: y <= (a < b);
			default: y <= 32'b0;
		endcase
	end

	//assign zero = (y == 32'b0);
	//assign overflow = 1'b0;
endmodule
