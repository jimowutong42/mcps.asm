;Êý¾Ý¶Î
data segment
    filename db "Sample.txt", 0
    text db 1024 dup(0)
    nums db 1024 dup(0)
ends

;¶ÑÕ»¶Î
stack segment
    DW 128 DUP(0)
ends

;´úÂë¶Î
code segment
start:                      ;ÉèÖÃ¶Î¼Ä´æÆ÷
    mov ax, data
    mov ds, ax
    mov es, ax

openfile:
    mov al, 0 
    mov dx, offset filename
    mov ah, 3dh
    int 21h
readfile:
    mov bx, ax
    mov cx, 1024
    mov dx, offset text
    mov ah, 3fh
    int 21h
printtext:
    mov si, ax
    mov text[si], '$'
    mov ah, 9
    int 21h
    
    mov ah, 2               ;»»ÐÐ
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    mov bx, 0

read_line:
    mov si, 0
    mov cl, text[si]
    cmp cl, 13
    je  next_line
    cmp cl, '-'
    je  is_back
    cmp cl, 48
    jge is_0?

is_back:
    sub si, 1
    jmp next
is_0?:
    cmp cl, 122
    jle is_0z
    jmp next
is_0z:
    cmp cl, 97
    jge is_az
    cmp cl, 90
    jle is_0Z
    jmp next
is_0Z:
    cmp cl, 65
    jge is_AZ
    cmp cl, 57
    jle is_09
    jmp next

is_az:
    mov nums[si], cl
    jmp next
is_AZ:
    mov nums[si], cl
    jmp next
is_09:
    mov nums[si], cl
    jmp next

next:
    inc si
    jmp read_line
    
next_line:
    
    
done:
    mov ah, 1               ;µÈ´ýÊäÈë
    int 21h
    mov ax, 4c00h
    int 21h
ends

end start
