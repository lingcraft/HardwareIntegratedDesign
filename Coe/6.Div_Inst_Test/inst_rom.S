   .org 0x0
   .global _start
_start:
   ori  $2,$0,0xffff                  
   sll  $2,$2,16
   ori  $2,$2,0xfff1           	# $2 = -15
   ori  $3,$0,0x11             	# $3 = 3

   div $2,$3             		# hi = 0xfffffff1            
								# lo = 0x0
   divu $2,$3            		# hi = 0x00000003
								# lo = 0x0f0f0f0e
   div  $3,$2            		# hi = 2
								# lo = 0xffffffff

