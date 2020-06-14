	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 10, 15	sdk_version 10, 15, 4
	.globl	_precalculate           ## -- Begin function precalculate
	.p2align	4, 0x90
_precalculate:                          ## @precalculate
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	xorl	%eax, %eax
	cmpl	%esi, %ecx
	jg	LBB0_13
## %bb.1:
	movl	%r8d, %r9d
	testl	%esi, %esi
	jle	LBB0_7
## %bb.2:
	movl	%esi, %r11d
	xorl	%esi, %esi
	movq	_dataSq@GOTPCREL(%rip), %r10
	jmp	LBB0_3
	.p2align	4, 0x90
LBB0_6:                                 ##   in Loop: Header=BB0_3 Depth=1
	movsd	%xmm0, (%r10,%rsi,8)
	incq	%rsi
	addq	$256, %rdi              ## imm = 0x100
	cmpq	%r11, %rsi
	je	LBB0_7
LBB0_3:                                 ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB0_5 Depth 2
	xorpd	%xmm0, %xmm0
	testl	%r8d, %r8d
	jle	LBB0_6
## %bb.4:                               ##   in Loop: Header=BB0_3 Depth=1
	xorl	%eax, %eax
	.p2align	4, 0x90
LBB0_5:                                 ##   Parent Loop BB0_3 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movsd	(%rdi,%rax,8), %xmm1    ## xmm1 = mem[0],zero
	mulsd	%xmm1, %xmm1
	addsd	%xmm1, %xmm0
	incq	%rax
	cmpq	%rax, %r9
	jne	LBB0_5
	jmp	LBB0_6
LBB0_7:
	movl	$1, %eax
	testl	%ecx, %ecx
	jle	LBB0_13
## %bb.8:
	movl	%ecx, %ecx
	xorl	%esi, %esi
	movq	_querySq@GOTPCREL(%rip), %r10
	jmp	LBB0_9
	.p2align	4, 0x90
LBB0_12:                                ##   in Loop: Header=BB0_9 Depth=1
	movsd	%xmm0, (%r10,%rsi,8)
	incq	%rsi
	addq	$256, %rdx              ## imm = 0x100
	cmpq	%rcx, %rsi
	je	LBB0_13
LBB0_9:                                 ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB0_11 Depth 2
	xorpd	%xmm0, %xmm0
	testl	%r8d, %r8d
	jle	LBB0_12
## %bb.10:                              ##   in Loop: Header=BB0_9 Depth=1
	xorl	%edi, %edi
	.p2align	4, 0x90
LBB0_11:                                ##   Parent Loop BB0_9 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movsd	(%rdx,%rdi,8), %xmm1    ## xmm1 = mem[0],zero
	mulsd	%xmm1, %xmm1
	addsd	%xmm1, %xmm0
	incq	%rdi
	cmpq	%rdi, %r9
	jne	LBB0_11
	jmp	LBB0_12
LBB0_13:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_cosine_likely          ## -- Begin function cosine_likely
	.p2align	4, 0x90
_cosine_likely:                         ## @cosine_likely
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	xorps	%xmm0, %xmm0
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_search                 ## -- Begin function search
	.p2align	4, 0x90
_search:                                ## @search
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movl	$-1, %eax
	subl	%ecx, %esi
	jl	LBB2_3
## %bb.1:
	cvtsi2sd	%ecx, %xmm2
	xorpd	%xmm1, %xmm1
	xorpd	%xmm0, %xmm0
	divsd	%xmm2, %xmm0
	incl	%esi
	xorl	%ecx, %ecx
	movl	$-1, %eax
	.p2align	4, 0x90
LBB2_2:                                 ## =>This Inner Loop Header: Depth=1
	ucomisd	%xmm1, %xmm0
	cmoval	%ecx, %eax
	movapd	%xmm0, %xmm2
	maxsd	%xmm1, %xmm2
	incl	%ecx
	movapd	%xmm2, %xmm1
	cmpl	%ecx, %esi
	jne	LBB2_2
LBB2_3:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3               ## -- Begin function main
LCPI3_0:
	.quad	4517329193108106637     ## double 9.9999999999999995E-7
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movl	$0, -48(%rbp)
	movl	$0, -44(%rbp)
	movq	_end@GOTPCREL(%rip), %rax
	movq	$0, (%rax)
	movq	$0, 8(%rax)
	movq	_start@GOTPCREL(%rip), %rax
	movq	$0, (%rax)
	movq	$0, 8(%rax)
	leaq	L_.str(%rip), %r14
	leaq	L_.str.1(%rip), %r12
	leaq	-48(%rbp), %r15
	.p2align	4, 0x90
LBB3_1:                                 ## =>This Inner Loop Header: Depth=1
	movq	%r14, %rdi
	xorl	%eax, %eax
	callq	_printf
	movq	%r12, %rdi
	movq	%r15, %rsi
	xorl	%eax, %eax
	callq	_scanf
	movslq	-48(%rbp), %rbx
	testq	%rbx, %rbx
	jle	LBB3_1
## %bb.2:
	movq	%rbx, %rdi
	shlq	$8, %rdi
	callq	_malloc
	movq	%rax, %r12
	leaq	L_.str.2(%rip), %rdi
	movl	%ebx, %esi
	movl	$32, %edx
	xorl	%eax, %eax
	callq	_printf
	cmpl	$0, -48(%rbp)
	jle	LBB3_5
## %bb.3:
	leaq	L_.str.3(%rip), %r13
	movq	%r12, %r14
	xorl	%ebx, %ebx
	.p2align	4, 0x90
LBB3_4:                                 ## =>This Inner Loop Header: Depth=1
	movq	%r13, %rdi
	movq	%r14, %rsi
	xorl	%eax, %eax
	callq	_scanf
	incq	%rbx
	movslq	-48(%rbp), %rax
	shlq	$5, %rax
	addq	$8, %r14
	cmpq	%rax, %rbx
	jl	LBB3_4
LBB3_5:
	leaq	L_str(%rip), %rdi
	callq	_puts
	cmpl	$0, -48(%rbp)
	jle	LBB3_8
## %bb.6:
	xorl	%ebx, %ebx
	leaq	L_.str.5(%rip), %r14
	.p2align	4, 0x90
LBB3_7:                                 ## =>This Inner Loop Header: Depth=1
	movsd	(%r12,%rbx,8), %xmm0    ## xmm0 = mem[0],zero
	movq	%r14, %rdi
	movb	$1, %al
	callq	_printf
	incq	%rbx
	movslq	-48(%rbp), %rax
	shlq	$5, %rax
	cmpq	%rax, %rbx
	jl	LBB3_7
LBB3_8:
	movl	$10, %edi
	callq	_putchar
	movl	-44(%rbp), %ebx
	testl	%ebx, %ebx
	jg	LBB3_11
## %bb.9:
	leaq	L_.str.7(%rip), %r14
	leaq	L_.str.1(%rip), %r13
	leaq	-44(%rbp), %r15
	.p2align	4, 0x90
LBB3_10:                                ## =>This Inner Loop Header: Depth=1
	movq	%r14, %rdi
	xorl	%eax, %eax
	callq	_printf
	movq	%r13, %rdi
	movq	%r15, %rsi
	xorl	%eax, %eax
	callq	_scanf
	movl	-44(%rbp), %ebx
	testl	%ebx, %ebx
	jle	LBB3_10
LBB3_11:
	movl	%ebx, %eax
	shll	$5, %eax
	movslq	%eax, %rdi
	shlq	$3, %rdi
	callq	_malloc
	movq	%rax, %r14
	leaq	L_.str.8(%rip), %rdi
	movl	%ebx, %esi
	movl	$32, %edx
	xorl	%eax, %eax
	callq	_printf
	cmpl	$0, -44(%rbp)
	jle	LBB3_14
## %bb.12:
	leaq	L_.str.3(%rip), %r15
	movq	%r14, %r13
	xorl	%ebx, %ebx
	.p2align	4, 0x90
LBB3_13:                                ## =>This Inner Loop Header: Depth=1
	movq	%r15, %rdi
	movq	%r13, %rsi
	xorl	%eax, %eax
	callq	_scanf
	incq	%rbx
	movslq	-44(%rbp), %rax
	shlq	$5, %rax
	addq	$8, %r13
	cmpq	%rax, %rbx
	jl	LBB3_13
LBB3_14:
	leaq	L_str.14(%rip), %rdi
	callq	_puts
	cmpl	$0, -44(%rbp)
	jle	LBB3_17
## %bb.15:
	xorl	%ebx, %ebx
	leaq	L_.str.5(%rip), %r15
	.p2align	4, 0x90
LBB3_16:                                ## =>This Inner Loop Header: Depth=1
	movsd	(%r14,%rbx,8), %xmm0    ## xmm0 = mem[0],zero
	movq	%r15, %rdi
	movb	$1, %al
	callq	_printf
	incq	%rbx
	movslq	-44(%rbp), %rax
	shlq	$5, %rax
	cmpq	%rax, %rbx
	jl	LBB3_16
LBB3_17:
	movl	$10, %edi
	callq	_putchar
	leaq	L_str.15(%rip), %rdi
	callq	_puts
	movl	-48(%rbp), %esi
	movl	-44(%rbp), %ecx
	movq	%r12, %rdi
	movq	%r14, %rdx
	movl	$32, %r8d
	callq	_precalculate
	cmpl	$1, %eax
	jne	LBB3_21
## %bb.18:
	movl	-48(%rbp), %esi
	movl	-44(%rbp), %ecx
	movq	%r12, %rdi
	movq	%r14, %rdx
	callq	_search
	testl	%eax, %eax
	js	LBB3_20
## %bb.19:
	leaq	L_.str.11(%rip), %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	_printf
	jmp	LBB3_23
LBB3_21:
	leaq	L_str.16(%rip), %rdi
	jmp	LBB3_22
LBB3_20:
	leaq	L_str.17(%rip), %rdi
LBB3_22:
	callq	_puts
LBB3_23:
	movq	_start@GOTPCREL(%rip), %r15
	movq	%r15, %rdi
	xorl	%esi, %esi
	callq	_gettimeofday
	movq	_end@GOTPCREL(%rip), %rbx
	movq	%rbx, %rdi
	xorl	%esi, %esi
	callq	_gettimeofday
	movq	(%rbx), %rax
	subq	(%r15), %rax
	cvtsi2sd	%rax, %xmm1
	movl	8(%rbx), %eax
	subl	8(%r15), %eax
	xorps	%xmm0, %xmm0
	cvtsi2sd	%eax, %xmm0
	mulsd	LCPI3_0(%rip), %xmm0
	addsd	%xmm1, %xmm0
	leaq	L_.str.13(%rip), %rdi
	movb	$1, %al
	callq	_printf
	movq	%r12, %rdi
	xorl	%eax, %eax
	callq	_free
	movq	%r14, %rdi
	xorl	%eax, %eax
	callq	_free
	xorl	%eax, %eax
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.comm	_dataSq,40,4            ## @dataSq
	.comm	_querySq,40,4           ## @querySq
	.comm	_end,16,3               ## @end
	.comm	_start,16,3             ## @start
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"data len: "

L_.str.1:                               ## @.str.1
	.asciz	"%d"

L_.str.2:                               ## @.str.2
	.asciz	"Please input %d %1d-dimension data:\n"

L_.str.3:                               ## @.str.3
	.asciz	"%lf"

L_.str.5:                               ## @.str.5
	.asciz	"%lf\t"

L_.str.7:                               ## @.str.7
	.asciz	"query len: "

L_.str.8:                               ## @.str.8
	.asciz	"Please input %d %1d-dimension vectors:\n"

L_.str.11:                              ## @.str.11
	.asciz	"Find query in data at pos: %d\n"

L_.str.13:                              ## @.str.13
	.asciz	"\n\nspeed test finish, use time:%lfs\n\n"

L_str:                                  ## @str
	.asciz	"input data is:"

L_str.14:                               ## @str.14
	.asciz	"input query is:"

L_str.15:                               ## @str.15
	.asciz	"\nbegin search..."

L_str.16:                               ## @str.16
	.asciz	"Do not find query in data!"

L_str.17:                               ## @str.17
	.asciz	"Do not find query in data!"


.subsections_via_symbols
