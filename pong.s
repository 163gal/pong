.code16
.text
.org 0x00
.global _start


_start:
 mov $0x00, %ax
 mov %ax, %ds
 mov $0x00, %ah
 mov $0x10, %al
 int $0x10
 mov $xaxis, %cx # X axis
 mov $yaxis, %dx # Y axis
 call draw_ball
 #call clear
 mov $0, %cx
 mov $0, %dx
 call draw_ball
 jmp .

draw_ball:
 mov %dx, %bx
 add $5, %bx
 push %bx
 mov %cx, %bx
 add $5, %bx
 dball:
  push %bx
  mov $0x0C, %ah
  mov $0x0F, %al
  mov $0x00, %bh
  int $0x10
  pop %bx
  cmp %cx, %bx
  je nl_ball
  add $1, %cx
  jmp dball
 nl_ball:
  pop %ax
  push %ax
  cmp %dx, %ax
  je done
  add $1, %dx
  sub $5, %cx
  jmp dball

clear:
 mov $0, %cx
 mov $0, %dx
 mov $640, %bx
 push %bx
 mov $350, %bx
 dblack:
  push %bx
  mov $0x0C, %ah
  mov $0x00, %al
  mov $0x00, %bh
  int $0x10
  pop %bx
  cmp %cx, %bx
  je nl_black
  add $1, %cx
  jmp dblack
 nl_black:
  pop %ax
  push %ax
  cmp %dx, %ax
  je done
  add $1, %dx
  mov $0, %cx
  jmp dblack

done:
 ret

xaxis: .int 320
yaxis: .int 175

.org 510
.word 0xAA55
