;���ݶ�
data segment

ends

;��ջ��
stack segment
    DW 128 DUP(0)
ends

;�����
code segment
start:                  ;���öμĴ���
    mov ax, data
    mov ds, ax
    mov es, ax

input:
    mov ah, 1
    int 21h
    mov bl, al          ;bl ����
    sub bl, '0'
    int 21h
    mov bh, al          ;bh ��ĸ

    mov ah, 2           ;����
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

print1:
    mov cl, 1           ;cl ��ǰÿ�д�ӡ��
    mov ch, 0           ;ch ��ǰ�еĴ�ӡ��

print1_line:
    inc ch
    cmp ch, cl
    jg  print1_enter    ;ch>cl����
    mov ah, 2
    mov dl, bh
    int 21h
    jmp print1_line

print1_enter:
    mov ah, 2           ;����
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    mov ch, 0           ;��ǰ�еĴ�ӡ������
    inc cl              ;��ǰÿ�д�ӡ��+1
    cmp cl, bl
    jg  print2          ;cl>bl��print2
    jmp print1_line

print2:
    mov cl, bl          ;cl ��ǰ��Ӧ��ӡ��
    mov ch, 0           ;ch ��ǰ�еĴ�ӡ��
    mov dh, bl          ;dh ��ǰ��Ӧ��ӡ�Ŀո�����+1��

print2_line:
    inc ch
    sub dh, 1
    cmp dh, 0
    jg  print2_blank    ;dh>0���ӡ�ո�
    cmp ch, cl
    jg  print2_enter    ;ch>cl����
    mov ah, 2
    mov dl, bh
    int 21h
    jmp print2_line
print2_blank:
    mov ah, 2           ;�ո�
    mov dl, 32
    int 21h
    jmp print2_line

print2_enter:
    mov ah, 2           ;����
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    mov ch, 0           ;��ǰ�еĴ�ӡ������
    inc cl              ;��ǰ��Ӧ��ӡ��+1
    mov dh, bl
    add dh, bl
    sub dh, cl          ;���㵱ǰ��Ӧ��ӡ�Ŀո�����+1��
    cmp dh, 1
    jl  done            ;dh<1��done
    jmp print2_line

done:
    mov ah, 1           ;�ȴ�����
    int 21h
    mov ax, 4c00h
    int 21h
ends

end start
