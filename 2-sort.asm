;���ʵ�������㷨��
;��ĳ�ļ���txt��ʽ���е��޷���������������
;�������������Ļ�����ݵĸ���������1024��

;���ݶ�
data segment
    filename DB "2-sort.txt", 0
    text DB 10000 DUP(0)
    num DW 1024 DUP(0)
ends

;��ջ��
stack segment
    DW 128 DUP(0)
ends

;�����
code segment
start:
;���öμĴ���
    mov AX, data
    mov DS, AX
    mov ES, AX

;��2-sort.txt,����AX=�ļ�����
    mov AL, 0               ;AL=0��,AL=1д,AL=3��/д
    mov DX, offset filename ;DS:DX = ��ַ
    mov AH, 3dh
	int 21h
;��ȡ�ļ�
	mov BX, AX              ;BX = �ļ�����
	mov CX, 10000           ;��ȡ���ֽ���
	mov DX, offset text     ;DS:DX = ��ַ
	mov AH, 3fh
	int 21h
;�ر��ļ�                    ;BX = �ļ�����
	mov AH, 3eh
	int 21h
	
;������ȡ���ֽڣ�������ת��Ϊint
	mov SI, 0               ;�ı�ָ��
	mov DI, 0               ;����ָ��
	mov AX, 0               ;����

loop0:
	mov CL, text[SI]
	mov CH, 0
	cmp CX, 48
    jl not_num              ;ASCII�� < 48��������
	sub CX, 48
	mov DX, 10
	mul DX
	add AX, CX
	inc SI
	jmp loop0

not_num:
    cmp CX, 10
    je not_new_num
    mov num[DI], AX         ;����num����
    add DI, 2
    cmp CX, 0
    je bubble_sort

not_new_num:
	inc SI
	mov AX, 0
	jmp loop0
	
bubble_sort:                ;ð������
    mov CX, DI              ;ѭ������ * 2
    mov SI, 0               ;i = 0
    mov DI, 0               ;j = 0
loop_i:                     ;���ѭ��
    mov AX, num[SI]         ;AX = num[i]
loop_j:                     ;�ڲ�ѭ��
    mov BX, num[DI]         ;BX = num[j]
    cmp AX, BX
    jle continue
    mov DX, AX              ;AX > BX, ����
    mov AX, BX
    mov BX, DX
    mov num[DI],BX          ;�������������������
    mov num[SI],AX
continue:
    add DI, 2               ;j = j + 2
    cmp DI, CX
    jb  loop_j
    add SI, 2               ;i = i + 2
    mov DI, SI              ;j = i
    cmp SI, CX
    jb  loop_i

;��ӡ����õ�����
print:
    mov SI, 0
    mov DI, CX
loop1:
    cmp SI, DI
    jge finish
    mov AX, num[SI]
    mov CX, 10
    mov BX, 0
loop2:
    mov DX, 0
    div CX
    push DX
    inc BX
    cmp AX, 0
    jg  loop2
loop3:
    pop DX
    dec BX
    add DX, 48
    mov AH, 2
    int 21h
    cmp BX, 0
    jg  loop3
    mov DL, 13
    int 21h
    mov DL, 10
    int 21h
    add SI,2
    jmp loop1
    
finish:
    mov ah, 1               ;�ȴ�����
    int 21h
    mov ax, 4c00h
    int 21h
ends

end start
