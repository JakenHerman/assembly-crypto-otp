	org 100h

section .bss

	buffer		resb		80
	NULL		equ			0
	charret		equ			13

section	.data

	prompt		db		"What is your secret message? ", charret, 10, '$'
	enctxt		db		"The encrypted message is: ", charret, 10, '$'
	dectxt		db		"The message after decryption is: ", charret, 10, '$'
	
section	.text

	mov			cx, 0
	cld
	mov			di, buffer
	mov			ah, 1
	int			21h
INSTRING:
	cmp			al, charret
	je			INSTRINGEND
	inc			cx
	stosb
	int			21h
	jmp			INSTRING
INSTRINGEND:
	mov			byte [di], NULL
	jmp			CODER

CODER:
	cmp			al, NULL		;if the character is null, we're done
	je			ENDCODER
	xor			buffer, 0Fh
	lodsb						;read next character
	jmp			CODER			;loop until done
