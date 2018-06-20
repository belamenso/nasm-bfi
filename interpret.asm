section .data

; cat:
; program: db ",+[-.,+]",0
; hello world:

tape: times 30000 db 0      ; bf tape
ptr: dd 0                   ; current tape pointer

section .text

extern putchar, getchar
global interpret

interpret:
    push ebp
    mov ebp, esp

    mov dword[ptr], tape    ; initialize pointer
    
    mov ecx, dword[ebp + 8] ; ecx - address of currently executed char
    mov eax, 0              ; eax - currently execured char (in al)
.loop:                      ; main loop recognizing and parsing a char
    mov al, byte[ecx]
    cmp eax, 0
    je .exit

.PLUS:
    cmp eax, '+'
    jne .MINUS
    mov edx, dword[ptr]
    inc byte[edx]
    jmp .doneRecognizingChar

.MINUS:
    cmp eax, '-'
    jne .LEFT_POINTY_BRACKET
    mov edx, dword[ptr]
    dec byte[edx]
    jmp .doneRecognizingChar

.LEFT_POINTY_BRACKET:
    cmp eax, '<'
    jne .RIGHT_POINTY_BRACKET
    dec dword[ptr]
    jmp .doneRecognizingChar

.RIGHT_POINTY_BRACKET:
    cmp eax, '>'
    jne .LEFT_BRACKET
    inc dword[ptr]
    jmp .doneRecognizingChar
    
.LEFT_BRACKET:
; if (*ptr == 0) {
;     int *level = new int; *level = 0;
;     while (true) {
;         c++;
;         if (*c == '[') level++;
;         else if (*c == ']') {
;             if (*level == 0) break;
;             else *level--;
;         }
;     }
;     free level;
; }
    cmp eax, '['
    jne .RIGHT_BRACKET
    mov edx, dword[ptr]
    cmp byte[edx], 0
    jnz .doneRecognizingChar;
    sub esp, 4
    mov dword[esp], 0
.searchRBLoop:
    inc ecx
    mov al, byte[ecx]
    cmp eax, '['
    jne .searchRB_notLB
    inc dword[esp]
.searchRB_notLB:
    cmp eax, ']'
    jne .searchRB_nothing
    cmp dword[esp], 0
    jne .searchRB_levelNotZero
    jmp .searchRB_end
.searchRB_levelNotZero:
    dec dword[esp]
.searchRB_nothing:
    jmp .searchRBLoop
.searchRB_end:
    add esp, 4
    jmp .doneRecognizingChar

.RIGHT_BRACKET:
; if (*ptr != 0) {
;     int *level = new int; *level = 0;
;     while (true) {
;         c--;
;         if (*c == ']') level++;
;         else if (*c == '[') {
;             if (*level == 0) break;
;             else *level--;
;         }
;     }
;     free level;
; }
    cmp eax, ']'
    jne .DOT
    mov edx, dword[ptr]
    cmp byte[edx], 0
    jz .doneRecognizingChar;
    sub esp, 4
    mov dword[esp], 0
.searchLBLoop:
    dec ecx
    mov al, byte[ecx]
    cmp eax, ']'
    jne .searchLB_notRB
    inc dword[esp]
.searchLB_notRB:
    cmp eax, '['
    jne .searchLB_nothing
    cmp dword[esp], 0
    jne .searchLB_levelNotZero
    jmp .searchLB_end ; done
.searchLB_levelNotZero:
    dec dword[esp]
.searchLB_nothing:
    jmp .searchLBLoop
.searchLB_end:
    add esp, 4
    jmp .doneRecognizingChar

.DOT:
    cmp eax, '.'
    jne .COMMA
    call printChar
    jmp .doneRecognizingChar

.COMMA:
    cmp eax, ','
    jne .doneRecognizingChar
    call readChar
    
.doneRecognizingChar:
    inc ecx
    jmp .loop

.exit:
    mov esp, ebp
    pop ebp
    ret

printChar:
    mov edx, dword[ptr]
    push eax
    push ecx
    
    mov edx, dword[ptr]
    mov eax, 0
    mov al, byte[edx]
    push eax
    call putchar
    add esp, 4
    
    pop ecx
    pop eax
    ret

readChar:
    push eax
    push ecx
    
    call getchar
    mov ecx, dword[ptr]
    mov byte[ecx], al
    
    pop ecx
    pop eax
    ret

