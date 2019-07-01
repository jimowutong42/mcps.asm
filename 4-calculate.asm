;编程计算任一整数加减运算表达式，
;其中，表达式长度不超过1024个字节，
;从键盘输入，可带括号，操作数为字数据

include 'emu8086.inc'

;数据段
data segment
    string DB 1025 DUP(0)
ends

;堆栈段
stack segment
    DW 2048 DUP(0)
ends

;代码段
code segment
start:
    mov AX, data
    mov DS, AX
    mov ES, AX

    lea DI, string
    mov DX, 1025
    call get_string ;读取字符串
    lea SI, string  ;SI = 字符串地址

calculate:
    mov AX, 0       ;当前操作数
    mov BX, 0       ;结果
    mov CX, 43      ;'+' ;上一操作码
cmp_jmp:
    cmp [SI], 43    ;'+'
    je  op_plus
    cmp [SI], 45    ;'-'
    je  op_minus
    cmp [SI], 40    ;'('
    je  op_leftb
    cmp [SI], 41    ;')'
    je  op_rightb
    cmp [SI], 0     ;EOL
    je  finish
    jmp number
    
finish:             ;完成最后一次运算
    cmp CX, 0
    je  print
    cmp CX, 43      ;'+' / '-'
    je  op_plus
    jmp op_minus
op_plus:            ;'+'
    cmp CX, 43
    jne op_minus
    add BX, AX
    cmp [SI], 41    ;')'
    je return
    mov AX, 0       ;AX置零
    mov CL, [SI]    ;暂存操作码到CX
    mov CH, 0
    jmp next_char
op_minus:           ;'-'
    cmp CX, 45
    jne op_plus
    sub BX, AX
    cmp [SI], 41    ;')'
    je return
    mov AX, 0       ;AX置零
    mov CL, [SI]    ;暂存操作码到CX
    mov CH, 0
    jmp next_char
op_leftb:           ;'('
    push BX         ;暂存结果
    push CX         ;暂存操作码
    inc SI
    call calculate  ;计算括号内表达式结果
    pop CX          ;取出之前的操作码
    pop BX          ;取出之前的结果
    jmp next_char
op_rightb:          ;')'
    cmp CX, 43
    je op_plus
    cmp CX, 45
    je op_minus
return:
    mov AX, BX      ;保存括号内表达式结果到AX
    ret             ;返回
number:
    mov DX, 10
    mul DX
    mov DL, [SI]
    mov DH, 0
    sub DX, 48      ;'0'
    add AX, DX      ;AX = AX * 10 + DX

next_char:
    inc SI
    jmp cmp_jmp
    
print:
    ;换行
    mov AH, 2
    mov DL, 13
    int 21h
    mov DL, 10
    int 21h
    ;打印BX
    mov AX, BX
    call print_num
    ;换行
    mov AH, 2
    mov DL, 13
    int 21h
    mov DL, 10
    int 21h
    
    mov AH, 1
    int 21h
    mov AX, 4c00h
    int 21h
ends

DEFINE_GET_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

end start
