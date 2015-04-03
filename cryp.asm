	org	100h
section .data
msg	db	"We attack at dawn", '$'
key	db	0Fh

section .bss
encode	resb	20
decode	resb	20

section .text
	mov	si, 0
while:
	cmp	byte [si+msg], '$'
	je	endwhile
	mov	al, [si+msg]
	xor	al, [key]
	mov	[si+encode], al
	inc	si
	jmp	while
endwhile:
	mov	byte [si+encode], '$'
	mov	ah, 9
	mov	dx, encode
	int	21h
	mov	si, 0
_while:
	cmp	byte[si+encode], '$'
	je	_endwhile
	mov	al, [si+encode]
	xor	al, [key]
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
	