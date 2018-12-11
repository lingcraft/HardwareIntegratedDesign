	.org 0x0
.global _start
   .set noat
_start:
	LUI $1 0x0101		# $1 = 0x01010000
	ORI $1 $1 0x0101 	# $1 = $1 or 0x0101 = 0x0101_0000 or 0x0101 = 0x0101_0101
	ORI $2 $1 0x1100 	# $2 = $1 or 0x1100 = 0x0101_0101 or 0x1100 = 0x0101_1101
	OR $1 $1 $2 		# $1 = $1 or $2 = 0x0101_0101 or 0x0101_1101 = 0x0101_1101
	ANDI $3 $1 0x00FE 	# $3 = $1 and 0x00FE = 0x0000_0000
	AND $1 $3 $1 		# $1 = $3 and $1 = 0x0000_0000
	XORI $4 $1 0xFF00 	# $4 = $1 xor 0xFF00 = 0x0000_FF00
	XOR $1 $4 $1 		# $1 = $4 xor $1 = 0x0000_FF00 or 0x0000_0000 = 0x0000_FF00
	NOR $1 $4 $1 		# $1 = $4 nor $1 = 0x0000_FF00 nor 0x0000_FF00 = 0xFFFF_00FF

