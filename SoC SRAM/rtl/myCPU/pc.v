`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/20 05:16:41
// Design Name: 
// Module Name: pc
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


module pc #(parameter width = 32)(
	input wire clk,
	input wire rst,
	input wire en,
	input wire clr,
	input wire [width-1:0] d,
	input wire [width-1:0] sd,
	output reg [width-1:0] q
    );

	always @ (posedge clk or posedge rst)
	begin
		if (rst)
			q <= 32'hbfc0_0000;
		else if (clr)
            q <= sd;
        else if (en)
			q <= d;
	end

endmodule
