`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 13:50:53
// Design Name: 
// Module Name: top
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


module top(
	input wire clk,rst,
	output wire[31:0] writedata,dataadr,
	output wire memwrite
    );

	wire [31:0] pc,instr,readdata;
	wire [39:0] ascii;

	mips mips(clk,rst,pc,instr,memwrite,dataadr,writedata,readdata);
	instdec instdec(instr,ascii);
	
	inst_mem imem(~clk,pc,instr);
	data_mem dmem(~clk,{3'b0,memwrite},dataadr,writedata,readdata);

endmodule
