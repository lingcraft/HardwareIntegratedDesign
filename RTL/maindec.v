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
	input wire [5:0] funct,
	output wire memtoreg,
	output wire memwrite,
	output wire branch,
	output wire [1:0] alusrc,
	output wire regdst,
	output wire regwrite,
	output wire jump,
	output wire [3:0] aluop,
	output wire [1:0] hilowrite
    );

	reg [13:0] controls;

	assign {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,hilowrite,aluop} = controls;

	always @ (*)
	begin
		case (op)
			`R_TYPE:
			begin
				case (funct)
					// 数据移动
					`MFHI:	controls <= {10'b1_1_00_0_0_0_0_00, `R_TYPE_OP};
					`MFLO:	controls <= {10'b1_1_00_0_0_0_0_00, `R_TYPE_OP};
					`MTHI:	controls <= {10'b0_0_00_0_0_0_0_10, `R_TYPE_OP};
					`MTLO:	controls <= {10'b0_0_00_0_0_0_0_01, `R_TYPE_OP};

					// 乘除法
					`MULT:	controls <= {10'b0_0_00_0_0_0_0_11, `R_TYPE_OP};
					`MULTU:	controls <= {10'b0_0_00_0_0_0_0_11, `R_TYPE_OP};
					`DIV:	controls <= {10'b0_0_00_0_0_0_0_11, `R_TYPE_OP};
					`DIVU:	controls <= {10'b0_0_00_0_0_0_0_11, `R_TYPE_OP};
					
					// 逻辑运算、移位、算术运算(乘除法除外)
					default: controls <= {10'b1_1_00_0_0_0_0_00, `R_TYPE_OP};
				endcase
			end

			// 逻辑运算(I型)
			`ANDI:  controls <= {10'b1_0_10_0_0_0_0_00, `ANDI_OP};
			`XORI:	controls <= {10'b1_0_10_0_0_0_0_00, `XORI_OP};
			`LUI:	controls <= {10'b1_0_10_0_0_0_0_00, `LUI_OP};
			`ORI:	controls <= {10'b1_0_10_0_0_0_0_00, `ORI_OP};

			// 算术运算(I型)
			`ADDI:	controls <= {10'b1_0_10_0_0_0_0_00, `ADDI_OP};
			`ADDIU:	controls <= {10'b1_0_10_0_0_0_0_00, `ADDIU_OP};
			`SLTI:	controls <= {10'b1_0_10_0_0_0_0_00, `SLTI_OP};
			`SLTIU: controls <= {10'b1_0_10_0_0_0_0_00, `SLTIU_OP};

			`LW: 	controls <= {10'b1_0_01_0_0_1_0_00, `MEM_OP};
			`SW: 	controls <= {10'b0_0_01_0_1_0_0_00, `MEM_OP};
			`BEQ: 	controls <= {10'b0_0_00_1_0_0_0_00, `USELESS_OP};
			`ADDI: 	controls <= {10'b1_0_01_0_0_0_0_00, `ADDI_OP};
			`J: 	controls <= {10'b0_0_00_0_0_0_1_00, `USELESS_OP};

			default:controls <= 14'b0;
		endcase
	end

endmodule
