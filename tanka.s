hexchar: .ascii  "0123456789abcdef"

.globl	func
func:
	movl	$func, %ecx	# 5
	mov	$0x64, %al
f1:
	mov	%ecx, %ebx
	push	%eax
	nop
	nop			# 7
	call	my_hexdump	# 5
	mov	$0x20, %al
	call	my_putchar	# 7
	pop	%eax
	inc	%ecx
	dec	%al
	jnz	f1
	ret			# 7

.globl	my_hexdump
my_hexdump:
	mov	(%ebx),%edx
	sar	$0x4, %edx	# 5
	movl	$hexchar, %eax
	nop
	nop			# 7
	and	$0xf, %dx
	nop			# 5
	add	%dx, %ax
	movl	(%eax),%eax
	nop
	nop			# 7
	call	my_putchar
	jmp	my_put_lower_bit # 7
fff:
	ret

my_put_lower_bit:
	mov	(%ebx),%edx
	and	$0xf, %edx	# 5
	movl	$hexchar, %eax
	nop
	nop			# 7
	add	%dx, %ax
	movl	(%eax),%eax	# 5
	call	my_putchar
	jmp	fff		# 7
	nop
	nop
	nop
	nop
	nop
	nop
	nop			# 7

.globl	my_putchar
my_putchar:
        sub	$0x10, %esp
	mov	%eax,(%esp)
	mov	%esp,%eax
        movl	$0x1, 0xc(%esp)
        movl	%eax, 0x8(%esp)
        movl	$0x1, 0x4(%esp)
        mov	$0x4, %ax
        int	$0x80
       	add	$0x10, %esp
	ret

