	org	100h
section .data
	bitmask				db				0Fh
	msg					db				"We attack at dawn", '$'
	prompt     			db        		"String to encrypt: ", CR, 10, '$'
	afenc				db				"The message after encryption is: ", CR, 10, '$'
	afdec				db				"The message after decryption is: ", CR, 10, '$'

section .bss
	encode	resb	80
	decode	resb	80
	buffer  resb    80
	CR      equ     13
	NULL    equ     0

section .text

	mov	ah, 9	;print prompt
	mov	dx, prompt	;what to print
	int			21h						;print it.

;input a char from kbd into string1
    mov     cx, 0
    cld         		       ;process string left to right
    mov     di, buffer        ;string1 is destination
    mov     ah, 1             ;read char fcn
    int     21h               ;read it

INSTRING:
        cmp     al, CR            ;is char = CR?
        je      endInString         ;if so, we're done
        inc     cx
        stosb                     ;store char just read into string1
        int     21h               ;read next char
        jmp     INSTRING            ;loop until done
endInString:
        mov     byte [di], NULL   ;store ASCII null char
        mov     dx, buffer        ;dx is the address arg to print
        call    print             ;print string1
        call    print2

print:
        mov     si, buffer            ;set up for lodsb
        lodsb                     ;read first char into al
        mov     ah, 2             ;display char fcn
        int		21h
 
        
print2:
        mov     si, buffer            ;set up for lodsb
        lodsb                     ;read first char into al
        mov     ah, 2             ;display char fcn
        int		21h


	mov	si, 0
	
	mov	ah, 9
	mov	dx, afenc
	int 21h

	
CODER:
	cmp	byte [si+msg], '$'
	je	ENDCODER
	mov	al, [si+msg]
	xor	al, [bitmask]
	mov	[si+encode], al
	inc	si
	jmp	CODER

ENDCODER:
	mov	byte [si+encode], '$'
	mov	ah, 9
	mov	dx, encode
	int	21h
	mov	si, 0


	mov	ah, 9
	mov	dx, afdec
	int	21h
	mov	ax, 4C00h

_while:
	cmp	byte[si+encode], '$'
	je	_endwhile
	mov	al, [si+encode]
	xor	al, [bitmask]
	mov	[si+decode], al
	inc	si
	jmp	_while

_endwhile:
	mov	byte [si+decode], '$'
	mov	ah, 2
	mov	dl, 13
	int	21h
	mov	dl, 10
	int	21h
	mov	ah, 9
	mov	dx, decode
	int	21h
	mov	ax, 4C00h
	int	21h
	mov	ax, 4C00h
	int	21h
