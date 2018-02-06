;����N!��0<N<20��

include emu8086.inc

data segment
    digit DB 18 DUP(0)      ;��λ��Ž�������18λ
ends

stack segment
    DW 128  DUP(0)
ends

code segment
start:
    mov AX, data
    mov DS, AX
    mov ES, AX

    call scan_num           ;����scan_num��ȡ�������ַ���CX
    mov AH,2                ;��ӡһ���س�
    mov DL,13
    int 21h
    mov DL,10
    int 21h
    
    mov digit,1             ;��λ����Ϊ1

calculate:
    mov BX,0

multiply:                   ;��digit��ÿһλ��CL
    mov AL,digit[BX]
    mul CL
    mov digit[BX],AL
    inc BX
    cmp BX,18               ;ѭ��18��
    jl multiply
    
    mov BX,0
adjust:                     ;�����λ
    mov AL,digit[BX]
    mov AH,0
    mov DL,10
    div DL
    mov digit[BX],AH
    add digit[BX+1],AL
    inc BX
    cmp BX,17               ;ѭ��17��
    jl adjust
    
    loop calculate          ;CL--
    
zero:
    mov DL,digit[BX]
    dec BX
    cmp DL,0
    je zero
    inc BX
print:
    mov DL,digit[BX]
    mov AH,2
    add DL,'0'
    int 21h
    dec BX
    cmp BX,0
    jge print

finish:
    mov AH, 1
    int 21h
    mov AX, 4c00h
    int 21h    
ends

DEFINE_SCAN_NUM

end start
