;��1~36����Ȼ������˳�����һ��6*6�Ķ�ά������
; 01 02 03 04 05 06
; 07 08 09 10 11 12
; 13 14 15 16 17 18
; 19 20 21 22 23 24
; 25 26 27 28 29 30
; 31 32 33 34 35 36
;Ȼ���ӡ������������°�����
; 01
; 07 08
; 13 14 15
; 19 20 21 22
; 25 26 27 28 29
; 31 32 33 34 35 36

;���ݶ�
data segment
    arr DB 36 DUP(0)    ;����36��1Byte��Ԫ ����arr
ends

;��ջ��
stack segment
    DW 128 DUP(0)       ;����128��2Bytes��Ԫ ��ջ
ends

;�����
code segment
start:                  ;���öμĴ���
    mov AX, data
    mov DS, AX
    mov ES, AX

;��ʼ��arr����Ϊ1~36
    mov AX, 0
init:
    mov DI, AX
    mov arr[DI], AL
    inc AX
    cmp AX, 37
    je  initok          ;AX==37����תinitok
    jmp init            ;initѭ��
    
initok:
    xor BX, BX          ;BX������

print:
;�ж��Ƿ�����������
    mov AX, BX
    mov CL, 6
    div CL              ;��AL������AH��01/6=0...1
    inc BX
    cmp AL, AH
    jl  notprint        ;��AL<����AH,��һ�����Ͳ����

;����10��ֱ������λ�͵�λ
    mov AX, BX
    mov CL, 10
    div CL
    mov CX, AX          ;CXҪ��ӡ����
    mov DL, CL          ;DL=CL��λ
    add DL, '0'
    mov AH, 2
    int 21h
    mov DL, CH          ;DL=CHʮλ
    add DL, '0'
    int 21h
    mov DL, ' '
    int 21h

notprint:
;�ж��Ƿ���6�ı������ǵĻ�����
    mov CL, 6
    mov AX, BX
    div CL
    cmp AH, 0
    jne notnewline      ;������������
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
    mov AH, 1           ;�ȴ�����
    int 21h
    mov AX, 4c00h
    int 21h
ends

end start
