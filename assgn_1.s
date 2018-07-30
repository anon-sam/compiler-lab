
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
	subq	$48, %rsp			#set space for 48 bytes on stack
	movl	$.LC0, %edi			#stores string of printf in %edi
	movl	$0, %eax			#indicates no float parameters passed
	call	printf				#calls printf,argument is in %edi
	leaq	-24(%rbp), %rax			#directs address of -24(%rbp) to %rax
	movq	%rax, %rsi			#stores the above in %rsi
	movl	$.LC1, %edi			#stores string of scanf in %edi
	movl	$0, %eax			#eax=0 no float arguments
	call	__isoc99_scanf			#calls scanf(%edi,&%rsi),return value is in %eax
	movq	-24(%rbp), %rax			#put value at %rbp-24 (obtained in scanf)
	movq	%rax, %rdi			#to %rdi through %rax
	call	monteCarlo			#calls MonteCarlo 'function'
	movsd	%xmm0, -40(%rbp)		#rbp-40=%xmm0=pi1
	movq	-40(%rbp), %rax			#rax=rbp-40
	movq	%rax, -8(%rbp)			#rbp-8=rax=pi1
	movq	-24(%rbp), %rax			#rax=rbp-24
	movq	%rax, %rdi			#rdi=rax now rdi=n
	call	iSeries				#calls iSeries 'function' with argument n
	movsd	%xmm0, -40(%rbp)		#rbp-40=xmm0=pi2
	movq	-40(%rbp), %rax			#rax=rbp-40
	movq	%rax, -16(%rbp)			#rbp-16=rax=pi2
	movq	-16(%rbp), %rax			#rax=rbp-16=pi2
	movq	%rax, -40(%rbp)			#rbp-40=rax=pi2
	movsd	-40(%rbp), %xmm0		#xmm0=rbp-40
	movl	$.LC2, %edi			#stores string to be printed in edi
	movl	$1, %eax			#eax=1 there is a float argument passed to printf
	call	printf				#prints pi from iSeries
	movq	-8(%rbp), %rax			#rax=pi1
	movq	%rax, -40(%rbp)			#rbp-40=pi1
	movsd	-40(%rbp), %xmm0		#xmm0=pi1
	movl	$.LC3, %edi			#stores string to be printed in edi
	movl	$1, %eax			#there is a float argument passed to printf
	call	printf				#prints pi from montecarlo
	movl	$0, %eax			#eax=0 no float arguments
	leave					#resets rbp
	.cfi_def_cfa 7, 8
	ret					#returns from main->return 0
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.globl	iSeries				#iSeries is a
	.type	iSeries, @function		#global function
iSeries:
.LFB3:						#start of iSeries
	.cfi_startproc
	pushq	%rbp			#pushes base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp		#saves stack base pointer
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)		#rbp-24=n
	movl	$0, %eax		#eax=0
	movq	%rax, -16(%rbp)		#rbp-16=0 (pi)
	movl	$1, -4(%rbp)		#rbp-4=1 (i)
	jmp	.L4
.L7:
	movl	-4(%rbp), %eax		#eax=i
	andl	$1, %eax		#eax=0 if even else 1
	testl	%eax, %eax		#tests eax
	jne	.L5			#jumps to L5 if eax is odd i.e i%2!=0
	movl	-4(%rbp), %eax		#eax=i
	addl	%eax, %eax		#eax=2i
	subl	$1, %eax		#eax=2i-1
	cvtsi2sd	%eax, %xmm0	#xmm0=2i-1
	movsd	.LC5(%rip), %xmm1	#xmm1=4
	divsd	%xmm0, %xmm1		#xmm1=(double)4/2i-1
	movapd	%xmm1, %xmm0		#xmm0=xmm1
	movsd	-16(%rbp), %xmm1	#xmm1=pi
	subsd	%xmm0, %xmm1		#xmm1=pi-4/2i-1
	movapd	%xmm1, %xmm0		#xmm0=xmm1
	movsd	%xmm0, -16(%rbp)	#rbp-16(pi)=pi-4/2i-1
	jmp	.L6
.L5:
	movl	-4(%rbp), %eax		#eax=i
	addl	%eax, %eax		#eax=2i
	subl	$1, %eax		#eax=2i-1
	cvtsi2sd	%eax, %xmm0	#xmm0=2i-1
	movsd	.LC5(%rip), %xmm1	#xmm1=4
	divsd	%xmm0, %xmm1		#xmm1=(double)4/2i-1
	movapd	%xmm1, %xmm0		#xmm0=xmm1
	movsd	-16(%rbp), %xmm1	#xmm1=pi
	addsd	%xmm1, %xmm0		#xmm0=pi+4/2i-1
	movsd	%xmm0, -16(%rbp)	#pi=pi+4/2i-1
.L6:
	addl	$1, -4(%rbp)		#i++
.L4:
	movl	-4(%rbp), %eax		#eax=rbp-4 (i)
	cltq				#rax=i
	cmpq	-24(%rbp), %rax		#jump to L7 if
	jle	.L7			#rax<=rbp-24 i.e i<=n
	movq	-16(%rbp), %rax		#rax=rbp-16(pi)
	movq	%rax, -32(%rbp)		#rbp-32=pi
	movsd	-32(%rbp), %xmm0	#xmm0=pi
	popq	%rbp			#pops base ponter
	.cfi_def_cfa 7, 8
	ret				#returns to main->return pi
	.cfi_endproc
.LFE3:
	.size	iSeries, .-iSeries
	.globl	monteCarlo		#monteCarlo is a global function
	.type	monteCarlo, @function
monteCarlo:				#start of monteCarlo
.LFB4:
	.cfi_startproc
	pushq	%rbp			#pushes base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp		#saves stack pointer
	.cfi_def_cfa_register 6
	subq	$48, %rsp		#allocates space on stack
	movq	%rdi, -40(%rbp)		#saves argument (input) on stack rbp-40=n
	movl	$0, -8(%rbp)		#rbp-8=0  (count)
	movl	$12345, %edi		#sets seed for srand=12345
	call	srand			#srand()
	movl	$1, -4(%rbp)		#rbp-4=1   (i)
	jmp	.L10			#jumps to L10
.L13:
	call	rand			#rand()
	cvtsi2sd	%eax, %xmm0	#%xmm0=(double)rand()
	movsd	.LC6(%rip), %xmm1	#stores rand_max in %xmm1
	divsd	%xmm1, %xmm0		#divide %xmm0 by %xmm1
	movsd	%xmm0, -16(%rbp)	#rbp-16=(double)rand()/rand_max
	call	rand			#repeats
	cvtsi2sd	%eax, %xmm0	#143
	movsd	.LC6(%rip), %xmm1	#through
	divsd	%xmm1, %xmm0		#147
	movsd	%xmm0, -24(%rbp)	#rbp-16 is x and rbp-24 is y
	movsd	-16(%rbp), %xmm0	#%xmm0=x
	movapd	%xmm0, %xmm1		#%xmm1=x
	mulsd	-16(%rbp), %xmm1	#%xmm1=x*x
	movsd	-24(%rbp), %xmm0	#xmm0=y
	mulsd	-24(%rbp), %xmm0	#%xmm0=y*y
	addsd	%xmm1, %xmm0		#%xmm0=x*x+y*y
	movsd	.LC7(%rip), %xmm1	#%xmm1=1
	ucomisd	%xmm0, %xmm1		#jumps to .L11(i++) if %xmm1(value =1) is less than %xmm0
	jb	.L11			# i.e count++  only if x*x+y*y<=1
	addl	$1, -8(%rbp)		#(rbp-8)++ ->count++
.L11:
	addl	$1, -4(%rbp)		#i++
.L10:
	movl	-4(%rbp), %eax			#%eax=i in for loop
	cltq					#promotes to 64bit
	cmpq	-40(%rbp), %rax			#jumps to .L13
	jle	.L13				#if %rax is le rbp-40(input)(i.e. if i<=n)
	cvtsi2sd	-8(%rbp), %xmm0		#%xmm0=count
	cvtsi2sdq	-40(%rbp), %xmm1	#%xmm1 stores input
	divsd	%xmm1, %xmm0			#%xmm0/=%xmm1->count/=n(converted to double in above lines)
	movsd	.LC5(%rip), %xmm1		#%xmm1=4.0
	mulsd	%xmm1, %xmm0			#%xmm0*=%xmm1->count/n*4
	movsd	%xmm0, -48(%rbp)		#rbp-48=(double)count/n*4.0
	movq	-48(%rbp), %rax			#rax(return value)=rbp-48
	movq	%rax, -48(%rbp)			#rbp-48=rax
	movsd	-48(%rbp), %xmm0		#%xmm0=rbp-48
	leave					#undoes push and mov by montecarlo
	.cfi_def_cfa 7, 8
	ret					#returns to main->return (double)count/n*4.0
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
