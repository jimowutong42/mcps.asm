;编程实现排序算法，
;对某文件（txt格式）中的无符号整数进行排序，
;排序结果输出到屏幕（数据的个数不超过1024）

;数据段
data segment
    filename DB "2-sort.txt", 0
    text DB 10000 DUP(0)
    num DW 1024 DUP(0)
ends

;堆栈段
stack segment
    DW 128 DUP(0)
ends

;代码段
code segment
start:
;设置段寄存器
    mov AX, data
    mov DS, AX
    mov ES, AX

;打开2-sort.txt,返回AX=文件代号
    mov AL, 0               ;AL=0读,AL=1写,AL=3读/写
    mov DX, offset filename ;DS:DX = 地址
    mov AH, 3dh
	int 21h
;读取文件
	mov BX, AX              ;BX = 文件代号
	mov CX, 10000           ;读取的字节数
	mov DX, offset text     ;DS:DX = 地址
	mov AH, 3fh
	int 21h
;关闭文件                    ;BX = 文件代号
	mov AH, 3eh
	int 21h
	
;分析读取的字节，将数字转化为int
	mov SI, 0               ;文本指针
	mov DI, 0               ;数字指针
	mov AX, 0               ;数字

loop0:
	mov CL, text[SI]
	mov CH, 0
	cmp CX, 48
    jl not_num              ;ASCII码 < 48则不是数字
	sub CX, 48
	mov DX, 10
	mul DX
	add AX, CX
	inc SI
	jmp loop0

not_num:
    cmp CX, 10
    je not_new_num
    mov num[DI], AX         ;存入num数组
    add DI, 2
    cmp CX, 0
    je bubble_sort

not_new_num:
	inc SI
	mov AX, 0
	jmp loop0
	
bubble_sort:                ;冒泡排序
    mov CX, DI              ;循环次数 * 2
    mov SI, 0               ;i = 0
    mov DI, 0               ;j = 0
loop_i:                     ;外层循环
    mov AX, num[SI]         ;AX = num[i]
loop_j:                     ;内层循环
    mov BX, num[DI]         ;BX = num[j]
    cmp AX, BX
    jle continue
    mov DX, AX              ;AX > BX, 交换
    mov AX, BX
    mov BX, DX
    mov num[DI],BX          ;将交换后的数存入数组
    mov num[SI],AX
continue:
    add DI, 2               ;j = j + 2
    cmp DI, CX
    jb  loop_j
    add SI, 2               ;i = i + 2
    mov DI, SI              ;j = i
    cmp SI, CX
    jb  loop_i

;打印排序好的数组
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
    mov ah, 1               ;等待输入
    int 21h
    mov ax, 4c00h
    int 21h
ends

end start
