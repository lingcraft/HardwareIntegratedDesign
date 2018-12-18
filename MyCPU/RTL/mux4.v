`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/18 23:59:04
// Design Name: 
// Module Name: mux4
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


module mux4 #(parameter width = 8) (
	input wire [width-1:0] d0,
	input wire [width-1:0] d1,
	input wire [width-1:0] d2,
	input wire [width-1:0] d3,
	input wire [1:0] s,
	output wire [width-1:0] y
    );

	assign y = (s == 2'b00) ? d0:
			   (s == 2'b01) ? d1:
			   (s == 2'b10) ? d2:
               (s == 2'b11) ? d3:d0;
endmodule
