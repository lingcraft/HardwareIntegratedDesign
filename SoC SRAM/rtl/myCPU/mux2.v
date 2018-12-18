`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/18 13:22:15
// Design Name: 
// Module Name: mux2
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


module mux2 #(parameter width = 8) (
	input wire [width-1:0] d0,
	input wire [width-1:0] d1,
	input wire s,
	output wire [width-1:0] y
    );

	assign y = s ? d1:d0;
	
endmodule
