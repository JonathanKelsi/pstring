	.data

	.section	.rodata	
format1:	.string		"%d"

format2:	.string		"%s"

	.text	
	.globl	run_main
	.type	run_main, @function	
run_main:
	pushq	%rbp		# save the old frame pointer
	movq	%rsp, %rbp	# create the new frame pointer

	subq	$528, %rsp	# allocate memory for two pstrings and user input (with respect to stack alignment)

	movq    $format1, %rdi
    leaq    8(%rsp), %rsi
    xorq    %rax, %rax
    call    scanf			# read an integer from the user, representing the length of the first pstring

	movzbq	8(%rsp), %rax
	movb	%al, 272(%rsp)	# store the length of the first its length field 

	movq    $format2, %rdi
    leaq    273(%rsp), %rsi
    xorq    %rax, %rax
    call    scanf			# read a string from the user, representing the first pstring

	movq    $format1, %rdi
    leaq    8(%rsp), %rsi
    xorq    %rax, %rax
    call    scanf			# read an integer from the user, representing the length of the second pstring

	movzbq	8(%rsp), %rax
	movb	%al, 16(%rsp)	# store the length of the first its length field 

	movq    $format2, %rdi
    leaq    17(%rsp), %rsi
    xorq    %rax, %rax
    call    scanf			# read a string from the user, representing the second pstring

	movq	$0, (%rsp)
	movq    $format1, %rdi
    leaq    (%rsp), %rsi
    xorq    %rax, %rax
    call    scanf			# read the user's choice of function

	movl	(%rsp), %edi
	leaq	272(%rsp), %rsi
	leaq	16(%rsp), %rdx
	call	run_func		# call the function that the user chose	

	movq	$0, %rax	# return value is zero
	movq	%rbp, %rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp		# restore old frame pointer (the caller function frame).
	ret		# return to caller function (OS).
