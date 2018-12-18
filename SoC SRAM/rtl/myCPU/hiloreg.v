`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/12 11:26:03
// Design Name: 
// Module Name: hilo_reg
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


module hiloreg(
	input wire clk,rst,
	input wire [1:0] we,
	input wire [31:0] hiin,loin,
	output wire [31:0] hiout,loout
    );

	reg [31:0] hidata,lodata;
	
	always @ (negedge clk)
	begin
		if(rst) 
		begin
			hidata <= 32'b0;
			lodata <= 32'b0;
		end 
		else
		begin
			if (we[1])
				hidata <= hiin;
			if (we[0])
				lodata <= loin;
		end
	end

	assign hiout = hidata;
	assign loout = lodata;

endmodule
