[org 0x0100]
jmp start
x_pos: dw 0
y_pos: dw 0
foodposition: dw 0
gameName: db 'SNAKE GAME'
GroupMember1: db '22F-8766| Azam'
GroupMember2: db'22F-3440 | Tayyab'
GAMEINSTUCT: db 'Instructions: Use Arrows Key to Move Snake, Press Enter to Continue'
GameOver: db 'Game Over'
currScore: db '0'
score: db 'Score: '
snake: db 02,'@','@','@','@'
snake_length: dw 5
direction: db 2
delaytime: dd 0
;/////////////////
clearscreen:
    push es
    push ax
    push di
    push cx
    mov ax,0xb800 ; video memory address
    mov es,ax
    mov ax,0x0720 ; color code and space ASCII
    mov di,0
    nextchar:
        mov [es:di],ax
        add di,2
        cmp di,4000
        jne nextchar

    ;popping all values
    pop cx
    pop di
    pop ax
    pop es
    ret
;=======PRINT WELCOME MSSG======
welcomeMsg:
pusha
mov ah, 0x13 ; service 13 - print string
mov al, 1 ; subservice 01 – update cursor
mov bh, 0 ; output on page 0
mov bl, 10 ; normal attrib
mov dx, 0x050D ; row 10 column 3
mov cx, 10 ; length of string
push cs
pop es ; segment of string
mov bp, gameName ; offset of string
int 0x10
mov ah, 0x13 ; service 13 - print string
mov al, 1 ; subservice 01 – update cursor
mov bh, 0 ; output on page 0
mov bl, 7 ; normal attrib
mov dx, 0x0B0D ; row 10 column 3
mov cx, 14 ; length of string
push cs
pop es ; segment of string
mov bp, GroupMember1 ; offset of string
int 0x10
mov dx, 0x0C0D
mov cx, 17
mov bp, GroupMember2
int 0x10
	popa
    ret
;///////////////////
Instruction:
	pusha
	
mov ah, 0x13 ; service 13 - print string
mov al, 1 ; subservice 01 – update cursor
mov bh, 0 ; output on page 0
mov bl, 7 ; normal attrib
mov dx, 0x0A03 ; row 10 column 3
mov cx, 67 ; length of string
push cs
pop es ; segment of string
mov bp, GAMEINSTUCT ; offset of string
int 0x10

	popa
 ret
;//////////////////////////////////////////
; draw_snake: Draws the snake on the screen
; Input:
;   [bp + 6]: Address of the snake characters
;   [bp + 4]: Address of snake_locations
; Output:
;   Updates the screen with the snake representation
draw_snake:
    push bp
    mov bp, sp
   pusha

    mov si, [bp + 6]        
    mov cx, 5      
    mov di, 1500
    mov ax, 0xb800
    mov es, ax

    mov bx, [bp +4]
    mov ah, 0x04
    snake_next_part:
        mov al, [si]
        mov [es:di], ax
        mov [bx], di
        inc si
        add bx, 2

        add di, 2
        loop snake_next_part

    popa
    pop bp
    ret 6
;////////////////////////
printScore:
push bp
mov bp, sp
push ax
push bx
push cx
push si
push di
push es

s:
mov ah, 0x13 ; BIOS interrupt service 13 - print string
mov al, 1 ; Subservice 01 – update cursor
mov bh, 0 ; Output on page 0
mov bl, 7 ; Normal attribute
mov dx, 0x0103 ; Row 10, Column 3
mov cx, 7 ; Length of the score string

push cs ; Push code segment to get the segment of the string
pop es ; Pop it into ES
mov bp, score ; Offset of the score string
int 0x10 ; Call BIOS interrupt to print the score string

mov dx, 0x010A ; Row 01, Column 10
mov cx, 1 ; Length of the currScore string

push cs ; Push code segment to get the segment of the string
pop es ; Pop it into ES
mov bp, currScore ; Offset of the currScore string
int 0x10 ; Call BIOS interrupt to print the currScore string

pop es ; Restore registers from the stack
pop di
pop si
pop cx
pop bx
pop ax
pop bp
ret 2 ; Return, removing 2 bytes from the stack (arguments)
;///////////////////////////////////////////////////////
move_snake_left:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    ;snake itself parts colision check
    mov bx, [bp + 4]   ; snake locations         
    mov dx, [bx] ; snake head

    mov cx, [bp + 8]; len of snake
    dec cx
    sub dx, 2 ; dx = 1978
    check_left_colision:
        cmp dx, [bx]
        je no_left_movement
        add bx, 2
        loop check_left_colision
    left_movement:
    mov si, [bp + 6]            ;snake 
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    sub dx, 2
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x07
    mov al, [si]
    mov [es:di],ax             ;snake head placed

    mov cx, [bp + 8]
    mov di, [bx]
    inc si
    mov ah, 0x07
    mov al, [si]
    mov [es:di],ax
    left_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        
        loop left_location_sort
    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax
    jmp end1
    no_left_movement:
    call exitGame
    end1:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;///////////////////////////////////////////////
move_snake_up:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
     ;snake_parts colision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]
    dec cx

    sub dx, 160

    check_up_colision:
        cmp dx, [bx]
        je no_up_movement
        add bx, 2
        loop check_up_colision

    upward_movement:
    mov si, [bp + 6]            ;snake 
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    sub dx, 160
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x07		;snake color for head
    mov al, [si]
    mov [es:di],ax             ;snake head placed

    mov cx, [bp + 8]
    mov di, [bx]
    inc si
    mov ah, 0x07		;snake color
    mov al, [si]
    mov [es:di],ax
    up_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        
        loop up_location_sort

    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax
    jmp end2

    no_up_movement:
    call exitGame
    end2:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;//////////////////////////////////////////////
move_snake_down:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
     ;snake_parts colision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]
    dec cx
    add dx, 160
    check_down_colision:
        cmp dx, [bx]
        je no_down_movement
        add bx, 2
        loop check_down_colision

    downward_movement:
    mov si, [bp + 6]            ;snake 
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    add dx, 160
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x07
    mov al, [si]
    mov [es:di], ax             ;snake head placed

    mov cx, [bp + 8]            ;snake length
    mov di, [bx]
    inc si
    mov ah, 0x07
    mov al, [si]
    mov [es:di],ax
    down_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        loop down_location_sort
    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax
    jmp end3

    no_down_movement:
    call exitGame
    end3:

    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;-///////////////////////////////////
move_snake_right:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    ;snake_parts colision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]
    dec cx
    add dx, 2
    check_right_colision:
        cmp dx, [bx]
        je no_right_movement
        add bx, 2
        loop check_right_colision

    right_movement:
    mov si, [bp + 6]            ;snake 
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    add dx, 2
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x07
    mov al, [si]
    mov [es:di], ax             ;snake head placed

    mov cx, [bp + 8]            ;snake length
    mov di, [bx]
    inc si
    mov ah, 0x07
    mov al, [si]
    mov [es:di],ax
    right_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        
        loop right_location_sort
    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax
    jmp end4
    no_right_movement:
    call exitGame
    end4:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;//////////////////////////////////////
check_death:
    push ax
    push di
    push cx

    mov ax, [snake_locations]
    cmp ax, 160
    jb finished
    mov di, 160              
    mov cx, 24

    check1: 
        cmp ax, di
        je finished
        add di, 158
        cmp ax, di
        je finished
        add di, 2

        loop check1 
    
    mov di,3840
    cmp ax, di
    ja finished
    jmp else

    finished:
    call exitGame
    else:
        pop cx
        pop di
        pop ax
    ret
;////////////////////////////////////
; Play Game Routine
play_game:
    ; Initial setup
    call clearscreen          ; Clear the screen
    call welcomeMsg           ; Display welcome message
    mov ah,00                 ; Set interrupt AH to 00
    int 16h                   ; Wait for user input 
    call clearscreen          ; Clear the screen again
    call Instruction          ; Display game instructions
    mov ah,00                 ; Set interrupt AH to 00
    int 16h                   ; Wait for user input 

    ; Game initialization
    call clearscreen          
    call draw_border           ; Draw the game border

    ; Draw initial snake and food
    push word [snake_length]
    mov bx, snake
    push bx
    mov bx, snake_locations
    push bx
    call draw_snake           ; Draw the snake
    call displayFood          ; Display food on the screen

    ; Main game loop
    repeat:
    push 164                   ; Print the score
    call printScore
    cmp byte[currScore],'5'    ; Check if current score is 5 or more
    jae leve1                  ; Jump to leve1 if true
    mov dword[delaytime],120000 ; Set delay time
    leve1: 
    mov dword[delaytime],120000 ; Set delay time

    delay:
        dec dword[delaytime]   ; Delay loop
        cmp dword[delaytime],0
        jne delay

    mov ah, 01h               ; Check for keyboard input
    int 16h
    jz noKey                   ; Jump to noKey if no key pressed
    mov ah,0
    int 16h                   ; Read the key

    ; Check arrow key input
    cmp ah,0x48 ; up arrow
    je up
    cmp ah,0x4B ; left arrow
    je left
    cmp ah,0x4D ; right arrow
    je right
    cmp ah,0x50 ; down arrow
    je down
    cmp ah, ' '
    jne repeat                 ; Repeat loop if key is not space
    mov ah,0x4c
    int 21h                    ; Exit program

    ; Handle no key pressed scenario
    noKey:
        cmp byte[direction], 0 ; Check current direction
        je up
        cmp byte[direction], 1 ; Check current direction
        je down
        cmp byte[direction], 2 ; Check current direction
        je left
        cmp byte[direction], 3 ; Check current direction
        je right

    ; Move snake based on direction
    up:
       mov byte[direction],0
        push word [snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_up
 		jmp new

    down:
        mov byte[direction],1
        push word [snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_down
		jmp new

    left:
        mov byte[direction],2
        push word [snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_left
		jmp new

    right:
        mov byte[direction],3
        push word [snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_right

	new:
         call check_death       ; Check for snake collision with itself or borders
          push ax
          mov ax,word[foodposition]
          cmp ax,[snake_locations]
          jne f
          call displayFood      ; Display new food
          add word[snake_length],1 ; Increase snake length
          add byte[currScore],1 ; Increase the score

        f:
        pop ax
        jmp repeat              ; Repeat the main game loop

    exit:
        pop bx
        pop ax
        ret
;/////////////////////////////////////////
displayFood:
push bp
push bx
push ax
push cx
push dx
push es
push di

l1:
MOV AH, 00h ; interrupts to get system time
INT 1AH ; CX:DX now hold number of clock ticks since midnight

mov ax, dx
xor dx, dx
mov cx, 25
div cx

mov word[x_pos],dx

MOV AH, 00h ; interrupts to get system time
INT 1AH ; CX:DX now hold number of clock ticks since midnight

mov ax, dx
xor dx, dx
mov cx, 80
div cx ; here dx contains the remainder of the division - from 0 to 9

mov word[y_pos],dx

mov ax,[x_pos]
mov bx,80
mul bx
add ax,[y_pos]
shl ax,1
cmp ax,3840
jg l1

cmp ax,190
jb l1

mov word[foodposition],ax
mov di,ax
mov ax,0xb800
mov es,ax
 mov ax,0x050A
mov [es:di],ax


pop di
pop es
pop dx
pop cx
pop ax
pop bx
pop bp
ret
;/////////////////////////////
draw_border:
	push ax
	push bx
	push es
	push di
	push si
	push cx

	mov ax,0xb800
	mov es,ax
	mov di,0

	mov cx,80
	mov ah,0x04
	mov al,'='
	top_border:
		mov [es:di],ax
		add di,2
		loop top_border

	mov cx,80
	mov di,3840
	mov al,'='
	bottom_border:
		mov [es:di],ax
		add di,2
		loop bottom_border

	mov cx,24
	mov al,'|'
	mov di,160
	left_border:
		mov [es:di],ax
		add di,160
		loop left_border

	mov cx,24
	mov al,'|'
	mov di,158
	right_border:
		mov [es:di],ax
		add di,160
		loop right_border

	pop cx
	pop si
	pop di
	pop es
	pop bx
		pop ax
    ret
;////////////////////////////////////////
exitGame:
call clearscreen
   pusha
    mov ah, 0x13      ; BIOS interrupt service 13 - print string
    mov al, 1         ; Subservice 01 – update cursor
    mov bh, 0         ; Output on page 0
    mov bl, 7         ; Normal attribute
    mov dx, 0x0A0D    ; Row 10, Column 3
    mov cx, 9       ; Length of the Game Over string
    push cs          ; Push code segment to get the segment of the string
    pop es          ; Pop it into ES
    mov bp, GameOver  ; Offset of the Game Over string
    int 0x10         ; Call BIOS interrupt to print the Game Over string

    popa
    mov ax, 0x4c00
    int 0x21
    ret
;//////////////////////////////////////////
start:
call play_game
mov ax,0x4c00
int 0x21
snake_locations: dw 0
snake_locations: dw 0