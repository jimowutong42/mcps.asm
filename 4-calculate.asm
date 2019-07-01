;��̼�����һ�����Ӽ�������ʽ��
;���У����ʽ���Ȳ�����1024���ֽڣ�
;�Ӽ������룬�ɴ����ţ�������Ϊ������

include 'emu8086.inc'

;���ݶ�
data segment
    string DB 1025 DUP(0)
ends

;��ջ��
stack segment
    DW 2048 DUP(0)
ends

;�����
code segment
start:
    mov AX, data
    mov DS, AX
    mov ES, AX

    lea DI, string
    mov DX, 1025
    call get_string ;��ȡ�ַ���
    lea SI, string  ;SI = �ַ�����ַ

calculate:
    mov AX, 0       ;��ǰ������
    mov BX, 0       ;���
    mov CX, 43      ;'+' ;��һ������
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
    
finish:             ;������һ������
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
    mov AX, 0       ;AX����
    mov CL, [SI]    ;�ݴ�����뵽CX
    mov CH, 0
    jmp next_char
op_minus:           ;'-'
    cmp CX, 45
    jne op_plus
    sub BX, AX
    cmp [SI], 41    ;')'
    je return
    mov AX, 0       ;AX����
    mov CL, [SI]    ;�ݴ�����뵽CX
    mov CH, 0
    jmp next_char
op_leftb:           ;'('
    push BX         ;�ݴ���
    push CX         ;�ݴ������
    inc SI
    call calculate  ;���������ڱ��ʽ���
    pop CX          ;ȡ��֮ǰ�Ĳ�����
    pop BX          ;ȡ��֮ǰ�Ľ��
    jmp next_char
op_rightb:          ;')'
    cmp CX, 43
    je op_plus
    cmp CX, 45
    je op_minus
return:
    mov AX, BX      ;���������ڱ��ʽ�����AX
    ret             ;����
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
    ;����
    mov AH, 2
    mov DL, 13
    int 21h
    mov DL, 10
    int 21h
    ;��ӡBX
    mov AX, BX
    call print_num
    ;����
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
