;数据段
data segment

ends

;堆栈段
stack segment
    DW 128 DUP(0)
ends

;代码段
code segment
start:                  ;设置段寄存器
    mov ax, data
    mov ds, ax
    mov es, ax

input:
    mov ah, 1
    int 21h
    mov bl, al          ;bl 数字
    sub bl, '0'
    int 21h
    mov bh, al          ;bh 字母

    mov ah, 2           ;换行
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

print1:
    mov cl, 1           ;cl 当前每行打印数
    mov ch, 0           ;ch 当前行的打印数

print1_line:
    inc ch
    cmp ch, cl
    jg  print1_enter    ;ch>cl则换行
    mov ah, 2
    mov dl, bh
    int 21h
    jmp print1_line

print1_enter:
    mov ah, 2           ;换行
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    mov ch, 0           ;当前行的打印数置零
    inc cl              ;当前每行打印数+1
    cmp cl, bl
    jg  print2          ;cl>bl则print2
    jmp print1_line

print2:
    mov cl, bl          ;cl 当前行应打印数
    mov ch, 0           ;ch 当前行的打印数
    mov dh, bl          ;dh 当前行应打印的空格数（+1）

print2_line:
    inc ch
    sub dh, 1
    cmp dh, 0
    jg  print2_blank    ;dh>0则打印空格
    cmp ch, cl
    jg  print2_enter    ;ch>cl则换行
    mov ah, 2
    mov dl, bh
    int 21h
    jmp print2_line
print2_blank:
    mov ah, 2           ;空格
    mov dl, 32
    int 21h
    jmp print2_line

print2_enter:
    mov ah, 2           ;换行
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    mov ch, 0           ;当前行的打印数置零
    inc cl              ;当前行应打印数+1
    mov dh, bl
    add dh, bl
    sub dh, cl          ;计算当前行应打印的空格数（+1）
    cmp dh, 1
    jl  done            ;dh<1则done
    jmp print2_line

done:
    mov ah, 1           ;等待输入
    int 21h
    mov ax, 4c00h
    int 21h
ends

end start
