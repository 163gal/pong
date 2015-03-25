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

 mov $0x01, %al
 movb %al, color
 mov $50, %ax
 movw %ax, width
 mov $50, %al
 movb %al, height
 call draw_rect

 jmp .

draw_rect:
 mov $0x00, %ax
 movb yaxis, %al
 mov $320, %bx
 mul %bx
 mov %ax, %di
 addw xaxis, %di # Upperleft point - Start point
 mov $0xA000, %ax # Video memory
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
 mov $0x00, %ax
 movw %ax, xaxis
 movb %al, yaxis
 movb %al, color
 mov $320, %ax
 movw %ax, width
 mov $200, %al
 movb %al, height
 call draw_rect

done:
 ret

xaxis: .word 160
yaxis: .byte 100
width: .word 5
height: .byte 5
color: .byte 0

.org 510
.word 0xAA55
