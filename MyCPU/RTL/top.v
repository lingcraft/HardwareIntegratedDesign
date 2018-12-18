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
	input  wire clk,
	input  wire rst,
	output wire [31:0] writedata,
	output wire [31:0] dataaddr,
	output wire memwrite
	);

	wire [31:0] pc;
	wire [31:0] instr;
	wire [31:0] readdata;
	wire [39:0] ascii;
	wire [3:0] sel;

	mips mips (
		.clk		(clk		),
		.rst		(rst		),
		.pcF		(pc			),
		.instrF		(instr		),
		.memwriteM	(memwrite	),
		.aluoutM	(dataaddr	),
		.writedata2M(writedata	),
		.readdataM	(readdata	),
		.selM		(sel		)
	);

	instdec instdec (
		.instr 		(instr		),
		.ascii		(ascii		)
	);
	
	inst_mem imem (
		.clka		(~clk		),
		.addra		(pc			),
		.douta		(instr		)
	);

	data_mem dmem (
		.clka		(~clk		),
		.ena		(memwrite	),
		.wea		(sel		),
		.addra		(dataaddr	),
		.dina		(writedata	),
		.douta		(readdata	)
	);

endmodule
