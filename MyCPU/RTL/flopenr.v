`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/09 00:58:10
// Design Name: 
// Module Name: flopenr
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


module flopenr #(parameter width = 8) (
	input wire clk,
	input wire rst,
	input wire en,
	input wire [width-1:0] d,
	output reg [width-1:0] q
    );

	always @ (posedge clk)
	begin
		if (rst)
			q <= 32'hbfc0_0000;
		else if (en)
			q <= d;
	end

endmodule
