	.file	"assgn_1.c"			#C file name
	.section	.rodata			#read-only data section
	.align 8					#align with 8-byte boundary
.LC0:							#label of 1st printf
	.string	"Number of iterations to estimate PI: "
.LC1:							#label of 1st scanf
	.string	"%ld"
	.align 8
.LC2:							#label of second printf
	.string	"\nPI: %10.8lf (using Infinite Series)"
	.align 8
.LC3:							#label of third printf
	.string	"\tPI: %10.8lf (using Monte Carlo method)\n\n"
	.text						#code starting point
	.globl	main				#main is global
	.type	main, @function		#main is a function
main:							#label for main function
.LFB2:
	.cfi_startproc
	pushq	%rbp				#save base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp			#set new base pointer to stack base pointer
	.cfi_def_cfa_register 6
	subq	$48, %rsp			#set aside 48 bytes on stack
	movl	$.LC0, %edi			#
	movl	$0, %eax
	call	printf
	leaq	-24(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	monteCarlo
	movsd	%xmm0, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	iSeries
	movsd	%xmm0, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, -40(%rbp)
	movsd	-40(%rbp), %xmm0
	movl	$.LC2, %edi
	movl	$1, %eax
	call	printf
	movq	-8(%rbp), %rax
	movq	%rax, -40(%rbp)
	movsd	-40(%rbp), %xmm0
	movl	$.LC3, %edi
	movl	$1, %eax
	call	printf
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.globl	iSeries
	.type	iSeries, @function
iSeries:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	$0, %eax
	movq	%rax, -16(%rbp)
	movl	$1, -4(%rbp)
	jmp	.L4
.L7:
	movl	-4(%rbp), %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L5
	movl	-4(%rbp), %eax
	addl	%eax, %eax
	subl	$1, %eax
	cvtsi2sd	%eax, %xmm0
	movsd	.LC5(%rip), %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	movsd	-16(%rbp), %xmm1
	subsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	jmp	.L6
.L5:
	movl	-4(%rbp), %eax
	addl	%eax, %eax
	subl	$1, %eax
	cvtsi2sd	%eax, %xmm0
	movsd	.LC5(%rip), %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	movsd	-16(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
.L6:
	addl	$1, -4(%rbp)
.L4:
	movl	-4(%rbp), %eax
	cltq
	cmpq	-24(%rbp), %rax
	jle	.L7
	movq	-16(%rbp), %rax
	movq	%rax, -32(%rbp)
	movsd	-32(%rbp), %xmm0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	iSeries, .-iSeries
	.globl	monteCarlo
	.type	monteCarlo, @function
monteCarlo:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movl	$0, -8(%rbp)
	movl	$12345, %edi
	call	srand
	movl	$1, -4(%rbp)
	jmp	.L10
.L13:
	call	rand
	cvtsi2sd	%eax, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	call	rand
	cvtsi2sd	%eax, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-16(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	mulsd	-16(%rbp), %xmm1
	movsd	-24(%rbp), %xmm0
	mulsd	-24(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	movsd	.LC7(%rip), %xmm1
	ucomisd	%xmm0, %xmm1
	jb	.L11
	addl	$1, -8(%rbp)
.L11:
	addl	$1, -4(%rbp)
.L10:
	movl	-4(%rbp), %eax
	cltq
	cmpq	-40(%rbp), %rax
	jle	.L13
	cvtsi2sd	-8(%rbp), %xmm0
	cvtsi2sdq	-40(%rbp), %xmm1
	divsd	%xmm1, %xmm0
	movsd	.LC5(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -48(%rbp)
	movsd	-48(%rbp), %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	monteCarlo, .-monteCarlo
	.section	.rodata
	.align 8
.LC5:
	.long	0
	.long	1074790400
	.align 8
.LC6:
	.long	4290772992
	.long	1105199103
	.align 8
.LC7:
	.long	0
	.long	1072693248
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-11)"
	.section	.note.GNU-stack,"",@progbits
