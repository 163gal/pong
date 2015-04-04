.code16
.text
.org 0x00
.global _start


_start:
 mov $0x00, %ax
 mov %ax, %ds # Init memory address

 mov $0x00, %ah
 mov $0x13, %al # 320x200 256 colors (Colorful! :D)
 int $0x10 # Set video mode

 call flip_screen

 mov $0x36, %al
 out %al, $0x40 # Tell the PIT to set channel 0 (System timer)
 
 mov $39772, %ax # 30Hz (1193182/30)
 out %al, $0x40 # Send low byte
 mov %ah, %al # It doesn't work sending %ah?
 out %al, $0x40 #  Send high byte

 mov $0x01, %ah
 mov $0x00, %cx
 mov $0x00, %dx
 int $0x1A
 
 mov $0x00, %ah
 int $0x1A
 movw %cx, timeh
 movw %dx, timel

loop:
 call clear
 addw $1, xaxis
 addb $1, yaxis
 mov $0x01, %al
 mov %al, color
 mov $10, %ax
 mov %ax, width
 mov $8, %al
 mov %al, height
 call draw_rect
 call flip_screen
 
 wpar:
	 wcomp:
	   mov $0x00, %ah
	   int $0x1A
	   cmp %dx, timel
	   je wcomp
	 movw %dx, timel
	 mov $3, %bl
	 cmp %bl, timel
	 jne wpar
	 mov $0x01, %ah
 mov $0x00, %cx
 mov $0x00, %dx
 int $0x1A
 
 mov $0x00, %ah
 int $0x1A
 movw %cx, timeh
 movw %dx, timel
  jmp loop
 
 

 jmp .

draw_rect:
 mov $0x00, %ax
 movb yaxis, %al
 mov $320, %bx
 mul %bx
 mov %ax, %di
 addw xaxis, %di # Upperleft point - Start point
 movw buffer_addr, %ax # Video buffer
 mov %ax, %es

 mov $0x00, %bx # Current X coord
 mov $0x00, %cx # Current Y coord

 drect:
  movw width, %dx
  cmp %bx, %dx
  je nl_rect
  movb color, %al
  movb %al, %es:(%di)
  add $0x01, %bx
  add $0x01, %di
  jmp drect

 nl_rect:
  mov $0x00, %dx
  movb height, %dl
  cmp %cx, %dx
  je done
  add $0x01, %cx
  mov $0x00, %bx
  add $320, %di
  subw width, %di
  jmp drect

clear:
 push xaxis # Saves every variable in the stack
 mov yaxis, %al
 push %ax
 mov color, %al
 push %ax
 push width
 mov height, %al
 push %ax

 mov $0x00, %ax
 movw %ax, xaxis
 movb %al, yaxis
 movb %al, color
 mov $320, %ax
 movw %ax, width
 mov $200, %al
 movb %al, height
 call draw_rect

 pop %ax # Restore every variable
 mov %al, height
 pop width
 pop %ax
 mov %al, color
 pop %ax
 mov %al, yaxis
 pop xaxis

 ret

flip_screen:
 mov $0x0000, %di
 fliploop:
  movw buffer_addr, %ax # Buffer memory
  mov %ax, %es
  mov %es:(%di), %bx
  movw $0xA000, %ax # Video memory
  mov %ax, %es
  mov %bx, %es:(%di)
  add $0x01, %di
  cmp $0xFA00, %di
  je done
  jmp fliploop

done:
 ret

xaxis: .word 0
yaxis: .byte 0
width: .word 5
height: .byte 5
color: .byte 0
buffer_addr: .word 0x1000
timel: .word 0
timeh: .word 0
tm: .int 0

.org 510
.word 0xAA55
