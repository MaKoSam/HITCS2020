	.file	"search.c"
	.text
	.globl	cosine_likely
	.type	cosine_likely, @function
cosine_likely:  //------------------------ Cosine_likely() ---------------------------------
.LFB14:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movl	$0, %eax
	xorpd	%xmm4, %xmm4
	movsd	%xmm4, 8(%rsp)
	movsd	%xmm4, (%rsp)
	movapd	%xmm4, %xmm3
	jmp	.L2
.L3:
	movslq	%eax, %rcx
	movsd	(%rdi,%rcx,8), %xmm2
	movapd	%xmm2, %xmm0
	mulsd	%xmm2, %xmm0
	addsd	%xmm0, %xmm3
	movsd	(%rsi,%rcx,8), %xmm1
	movapd	%xmm1, %xmm0
	mulsd	%xmm1, %xmm0
	addsd	(%rsp), %xmm0
	movsd	%xmm0, (%rsp)
	mulsd	%xmm2, %xmm1
	addsd	8(%rsp), %xmm1
	movsd	%xmm1, 8(%rsp)
	addl	$1, %eax
.L2:
	cmpl	%edx, %eax
	jl	.L3
	movsd	.LC1(%rip), %xmm0
	ucomisd	%xmm3, %xmm0
	ja	.L9
	ucomisd	(%rsp), %xmm0
	ja	.L10
	sqrtsd	%xmm3, %xmm0
	ucomisd	%xmm0, %xmm0
	jnp	.L5
	movapd	%xmm3, %xmm0
	call	sqrt
.L5:
	movsd	8(%rsp), %xmm5
	divsd	%xmm0, %xmm5
	movsd	%xmm5, 8(%rsp)
	sqrtsd	(%rsp), %xmm0
	ucomisd	%xmm0, %xmm0
	jnp	.L7
	movsd	(%rsp), %xmm0
	call	sqrt
.L7:
	movsd	8(%rsp), %xmm6
	divsd	%xmm0, %xmm6
	movapd	%xmm6, %xmm0
	jmp	.L4
.L9:
	xorpd	%xmm0, %xmm0
	jmp	.L4
.L10:
	xorpd	%xmm0, %xmm0
.L4:
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE14:
	.size	cosine_likely, .-cosine_likely
	.globl	search
	.type	search, @function
search: //------------------------- Search() function ------------------------------------
.LFB15:
	.cfi_startproc
	pushq	%r15                // get data[][DIM]
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14                // get data_len
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13                // get query[][DIM]
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12                // get query_len
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp                // save stack pointer %rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx                //
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp           //
	.cfi_def_cfa_offset 96
	movl	%ecx, %r12d         // save query_len to %ecx
	cmpl	%esi, %ecx          // compare query_len with data_len
	jg	.L18                    // if greater, then jmp to .L18, if false, then stay
	movq	%rdi, %r13          // save query[][DIM] to %rdi
	movq	%rdx, %r14          // save data_len to %rdx
	movl	$-1, 28(%rsp)       // iMaxPos = -1
	movl	$0, %ebp            // fMaxScore = 0
	xorpd	%xmm3, %xmm3        // clear %xmm3
	movsd	%xmm3, 16(%rsp)     // save iMaxPos to %xmm3
	subl	%ecx, %esi
	movl	%esi, %r15d         // save data[][DIM] to %esi
	jmp	.L14                    // jump to for-loop statemnt check
.L15:
	movslq	%ebx, %rsi
	salq	$8, %rsi
	leal	0(%rbp,%rbx), %edi
	movslq	%edi, %rdi
	salq	$8, %rdi
	addq	%r14, %rsi
	addq	%r13, %rdi
	movl	$32, %edx
	call	cosine_likely       // call for function cosine_likely()
	addsd	8(%rsp), %xmm0      // add return from cosine_likely to score
	movsd	%xmm0, 8(%rsp)      // save score
	addl	$1, %ebx            // j + 1
	jmp	.L17                    // jump to for-loop statement check
.L20:
	xorpd	%xmm2, %xmm2        // clear %xmm2
	movsd	%xmm2, 8(%rsp)      // save score
	movl	$0, %ebx            // score = 0
.L17:
	cmpl	%r12d, %ebx         // compare j with query_len
	jl	.L15                    // jump inside next for-loop
	cvtsi2sd	%r12d, %xmm0
	movsd	8(%rsp), %xmm1      //
	divsd	%xmm0, %xmm1        // score / query_len
	ucomisd	16(%rsp), %xmm1     // if score > fMaxScore
	jbe	.L16                    // false, jump to next loop
	movl	%ebp, 28(%rsp)      // save score to fMaxScore
	movsd	%xmm1, 16(%rsp)     // save i to iMaxPos
.L16:
	addl	$1, %ebp            // i + 1
.L14:
	cmpl	%ebp, %r15d         // compare i with data_len - query_len
	jge	.L20                    // jump to for-loop
	movl	28(%rsp), %eax
	jmp	.L13                    // jump away from for-loop, exit
.L18:                           //IF query_len > data_len is true then,
	movl	$-1, %eax           //return -1 as search
.L13:
	addq	$40, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp                // get the stack pointer
	.cfi_def_cfa_offset 40
	popq	%r12                // remove query_len
	.cfi_def_cfa_offset 32
	popq	%r13                // remove query[][DIM]
	.cfi_def_cfa_offset 24
	popq	%r14                // remove data_len
	.cfi_def_cfa_offset 16
	popq	%r15                // remove data[][DIM]
	.cfi_def_cfa_offset 8
	ret                         // return from search()
	.cfi_endproc
.LFE15:
	.size	search, .-search
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"data len: "
.LC3:
	.string	"%d"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC4:
	.string	"Please input %d %1d-dimension data:\n"
	.section	.rodata.str1.1
.LC5:
	.string	"%lf"
.LC6:
	.string	"input data is:"
.LC7:
	.string	"%lf\t"
.LC8:
	.string	"query len: "
	.section	.rodata.str1.8
	.align 8
.LC9:
	.string	"Please input %d %1d-dimension vectors:\n"
	.section	.rodata.str1.1
.LC10:
	.string	"input query is:"
.LC11:
	.string	"\nbegin search..."
	.section	.rodata.str1.8
	.align 8
.LC12:
	.string	"Find query in data at pos: %d\n"
	.section	.rodata.str1.1
.LC13:
	.string	"Do not find query in data!"
	.text
	.globl	main
	.type	main, @function
main:
.LFB16:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movl	$0, 12(%rsp)
	movl	$0, 8(%rsp)
	movq	$0, end(%rip)
	movq	$0, end+8(%rip)
	movq	$0, start(%rip)
	movq	$0, start+8(%rip)
	jmp	.L23
.L24:
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	leaq	12(%rsp), %rsi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	__isoc99_scanf
.L23:
	movl	12(%rsp), %edi
	testl	%edi, %edi
	jle	.L24
	movslq	%edi, %rdi
	salq	$8, %rdi
	call	malloc
	movq	%rax, %r12
	movl	$32, %edx
	movl	12(%rsp), %esi
	movl	$.LC4, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %ebx
	jmp	.L25
.L26:
	movslq	%ebx, %rax
	leaq	(%r12,%rax,8), %rsi
	movl	$.LC5, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	addl	$1, %ebx
.L25:
	movl	12(%rsp), %eax
	sall	$5, %eax
	cmpl	%ebx, %eax
	jg	.L26
	movl	$.LC6, %edi
	call	puts
	movl	$0, %ebx
	jmp	.L27
.L28:
	movslq	%ebx, %rax
	movsd	(%r12,%rax,8), %xmm0
	movl	$.LC7, %edi
	movl	$1, %eax
	call	printf
	addl	$1, %ebx
.L27:
	movl	12(%rsp), %eax
	sall	$5, %eax
	cmpl	%ebx, %eax
	jg	.L28
	movl	$10, %edi
	call	putchar
	jmp	.L29
.L30:
	movl	$.LC8, %edi
	movl	$0, %eax
	call	printf
	leaq	8(%rsp), %rsi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	__isoc99_scanf
.L29:
	movl	8(%rsp), %edi
	testl	%edi, %edi
	jle	.L30
	movslq	%edi, %rdi
	salq	$8, %rdi
	call	malloc
	movq	%rax, %rbp
	movl	$32, %edx
	movl	8(%rsp), %esi
	movl	$.LC9, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %ebx
	jmp	.L31
.L32:
	movslq	%ebx, %rax
	leaq	0(%rbp,%rax,8), %rsi
	movl	$.LC5, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	addl	$1, %ebx
.L31:
	movl	8(%rsp), %eax
	sall	$5, %eax
	cmpl	%ebx, %eax
	jg	.L32
	movl	$.LC10, %edi
	call	puts
	movl	$0, %ebx
	jmp	.L33
.L34:
	movslq	%ebx, %rax
	movsd	0(%rbp,%rax,8), %xmm0
	movl	$.LC7, %edi
	movl	$1, %eax
	call	printf
	addl	$1, %ebx
.L33:
	movl	8(%rsp), %eax
	sall	$5, %eax
	cmpl	%ebx, %eax
	jg	.L34
	movl	$10, %edi
	call	putchar
	movl	$.LC11, %edi
	call	puts
	movl	8(%rsp), %ecx
	movq	%rbp, %rdx
	movl	12(%rsp), %esi
	movq	%r12, %rdi
	call	search
	testl	%eax, %eax
	js	.L35
	movl	%eax, %esi
	movl	$.LC12, %edi
	movl	$0, %eax
	call	printf
	jmp	.L36
.L35:
	movl	$.LC13, %edi
	call	puts
.L36:
	movq	%r12, %rdi
	call	free
	movq	%rbp, %rdi
	call	free
	movl	$0, %eax
	addq	$16, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE16:
	.size	main, .-main
	.comm	end,16,16
	.comm	start,16,16
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	3654794683
	.long	1037794527
	.ident	"GCC: (GNU) 4.8.5 20150623 (Red Hat 4.8.5-36)"
	.section	.note.GNU-stack,"",@progbits
