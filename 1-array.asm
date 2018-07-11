;把1~36的自然数按行顺序存入一个6*6的二维数组中
; 01 02 03 04 05 06
; 07 08 09 10 11 12
; 13 14 15 16 17 18
; 19 20 21 22 23 24
; 25 26 27 28 29 30
; 31 32 33 34 35 36
;然后打印出该数组的左下半三角
; 01
; 07 08
; 13 14 15
; 19 20 21 22
; 25 26 27 28 29
; 31 32 33 34 35 36

;数据段
data segment
    arr DB 36 DUP(0)    ;定义36个1Byte单元 数组arr
ends

;堆栈段
stack segment
    DW 128 DUP(0)       ;定义128个2Bytes单元 堆栈
ends

;代码段
code segment
start:                  ;设置段寄存器
    mov AX, data
    mov DS, AX
    mov ES, AX

;初始化arr数组为1~36
    mov AX, 0
init:
    mov DI, AX
    mov arr[DI], AL
    inc AX
    cmp AX, 37
    je  initok          ;AX==37则跳转initok
    jmp init            ;init循环
    
initok:
    xor BX, BX          ;BX计数器

print:
;判断是否是左下三角
    mov AX, BX
    mov CL, 6
    div CL              ;商AL，余数AH，01/6=0...1
    inc BX
    cmp AL, AH
    jl  notprint        ;商AL<余数AH,下一个数就不输出

;除以10后分别输出高位和低位
    mov AX, BX
    mov CL, 10
    div CL
    mov CX, AX          ;CX要打印的数
    mov DL, CL          ;DL=CL个位
    add DL, '0'
    mov AH, 2
    int 21h
    mov DL, CH          ;DL=CH十位
    add DL, '0'
    int 21h
    mov DL, ' '
    int 21h

notprint:
;判断是否是6的倍数，是的话则换行
    mov CL, 6
    mov AX, BX
    div CL
    cmp AH, 0
    jne notnewline      ;不换行则跳过
    mov AH, 2
    mov DL, 10
    int 21h
    mov DL, 13
    int 21h

notnewline:
    cmp BX, 36
    je done
    jmp print

done:
    mov AH, 1           ;等待输入
    int 21h
    mov AX, 4c00h
    int 21h
ends

end start
