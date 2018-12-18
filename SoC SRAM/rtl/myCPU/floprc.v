`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/09 00:58:10
// Design Name: 
// Module Name: floprc
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


module floprc #(parameter width = 8) (
	input wire clk,
	input wire rst,
	input wire clear,
	input wire [width-1:0] d,
	output reg [width-1:0] q
    );

	always @ (posedge clk or posedge rst)
	begin
		if (rst)
			q <= 0;
		else if (clear)
			q <= 0;
		else
			q <= d;
	end

endmodule
