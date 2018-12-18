`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/18 13:30:10
// Design Name: 
// Module Name: flopr
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


module flopr #(parameter width = 8) (
	input wire clk,
	input wire rst,
	input wire [width-1:0] d,
	output reg [width-1:0] q 
    );

	always @ (posedge clk or posedge rst)
	begin
		if (rst)
			q <= 0;
		else
			q <= d;
	end

endmodule
