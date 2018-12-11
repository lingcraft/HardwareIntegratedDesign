`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/31 20:50:35
// Design Name: 
// Module Name: maindec
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

module maindec(
	input wire [5:0] op,
	output wire memtoreg,
	output wire memwrite,
	output wire branch,
	output wire [1:0] alusrc,
	output wire regdst,
	output wire regwrite,
	output wire jump,
	output wire [3:0] aluop
    );

	reg [11:0] controls;

	assign {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,aluop} = controls;

	always @ (op)
	begin
		case (op)
			`R_TYPE:controls <= {8'b1_1_00_0_0_0_0, `R_TYPE_OP};
			// 逻辑运算
			`ANDI:  controls <= {8'b1_0_10_0_0_0_0, `ANDI_OP};
			`XORI:	controls <= {8'b1_0_10_0_0_0_0, `XORI_OP};
			`LUI:	controls <= {8'b1_0_10_0_0_0_0, `LUI_OP};
			`ORI:	controls <= {8'b1_0_10_0_0_0_0, `ORI_OP};

			`LW: 	controls <= {8'b1_0_01_0_0_1_0, `MEM_OP};
			`SW: 	controls <= {8'b0_0_01_0_1_0_0, `MEM_OP};
			`BEQ: 	controls <= {8'b0_0_00_1_0_0_0, `USELESS_OP};
			`ADDI: 	controls <= {8'b1_0_01_0_0_0_0, `ADDI_OP};
			`J: 	controls <= {8'b0_0_00_0_0_0_1, `USELESS_OP};
		endcase
	end


endmodule
