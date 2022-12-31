    .data

	.section	.rodata
    .align   8      # align addresses to multiple of 8
.L7:
    .quad   .L1     # case 31
    .quad   .L2     # case 32 
    .quad   .L2     # case 33 (same as case 32)
    .quad   .L6     # default case
    .quad   .L3     # case 35
    .quad   .L4     # case 36
    .quad   .L5     # case 37

format1:    .string "first pstring length: %d, second pstring length: %d\n"

format2:    .string " %c %c"

format3:    .string "old char: %c, new char: %c, first string: %s, second string: %s\n"

format4:    .string " %d %d"

format5:    .string "length: %d, string: %s\n"

format6:    .string "compare result: %d\n"

format7:    .string "invalid option!\n"

    .text	
	.globl  run_func
	.type   run_func, @function	
run_func:
    pushq	%rbp		    # save the old base pointer
	movq	%rsp,	%rbp	# create the new frame pointer

    pushq   %rsi    # save the first pstring 
    pushq   %rdx    # save the second pstring

    leaq    -31(%rdi), %rdi # rdi -= 30
    cmpq    $7, %rdi
    ja      .L6             # if >, go to the defualt case
    jmp     *.L7(,%rdi,8)   # goto jt[case]

.L8:
    movq	%rbp, %rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp		# restore old frame pointer (the caller function frame)
    ret

.L1:
    movq    8(%rsp), %rdi
    call    pstrlen         # calculate second string's len
    pushq   %rax            # save the second string's length on the stack

    movq    8(%rsp), %rdi
    call    pstrlen         # calculate first string's len

    movq    $format1, %rdi   
    movq    %rax, %rdx
    popq    %rsi
    xorq    %rax, %rax
    call    printf  # print them

    jmp     .L8

.L2:
    # allocate 16 bytes on the stack, both for alignment and for the 2 chars
    subq    $16, %rsp

    movq    $format2, %rdi
    leaq    8(%rsp), %rsi
    leaq    (%rsp), %rdx
    xorq    %rax, %rax
    call    scanf           # read 2 chars from the user
    
    movq    24(%rsp), %rdi
    movzbq  8(%rsp), %rsi
    movzbq  (%rsp), %rdx
    call    replaceChar    
    pushq   %rax            # replace the old char with the new char in the first pstring, 
                            # and save the pstring's address on the stack

    movq    24(%rsp), %rdi
    movzbq  16(%rsp), %rsi
    movzbq  8(%rsp), %rdx
    call    replaceChar     # replace the old char with the new char in the second pstring

    movq    %rax, %r8       # get the second pstring's address
    popq    %rcx            # get the first pstring's address

    xorq    %rax, %rax
    movq    $format3, %rdi
    movzbq  8(%rsp), %rsi
    movzbq  (%rsp), %rdx
    incq    %rcx
    incq    %r8
    call    printf          # print the results

    jmp    .L8

.L3:
    subq    $16, %rsp       # allocate 16 bytes on the stack

    movq    $format4, %rdi
    leaq    8(%rsp), %rsi
    leaq    (%rsp), %rdx
    xorq    %rax, %rax
    call    scanf           # read 2 integers from the user, representing indices

    movq    24(%rsp), %rdi
    movq    16(%rsp), %rsi
    movq    8(%rsp), %rdx
    movq    (%rsp), %rcx
    call    pstrijcpy       # copy the second pstring to the first pstring, from the first index to the second index
    pushq   %rax            # save the destination pstring's address on the stack

    movq    %rax, %rdi
    call    pstrlen         # calculate the destination pstring's length

    movq    $format5, %rdi
    movq    %rax, %rsi
    popq    %rdx
    incq    %rdx
    xorq    %rax, %rax
    call    printf          # print the length and the string

    movq    16(%rsp), %rdi
    call    pstrlen         # calculate the source pstring's length

    movq    $format5, %rdi
    movq    %rax, %rsi
    movq    16(%rsp), %rdx
    incq    %rdx
    xorq    %rax, %rax
    call    printf          # print the length and the string

    jmp    .L8
    
.L4:
    movq    8(%rsp), %rdi
    call    swapCase        # use the swapCase function on the first pstring
    pushq   %rax            # save the pstring's address on the stack

    movq    (%rsp), %rdi
    call    pstrlen         # calculate the first pstring's length

    movq    $format5, %rdi
    movq    %rax, %rsi
    popq    %rdx
    incq    %rdx
    xorq    %rax, %rax
    call    printf          # print the length and the string
    
    movq    (%rsp), %rdi
    call    swapCase        # use the swapCase function on the second pstring
    pushq   %rax            # save the pstring's address on the stack

    movq    (%rsp), %rdi
    call    pstrlen         # calculate the second pstring's length

    movq    $format5, %rdi
    movq    %rax, %rsi
    popq    %rdx
    incq    %rdx
    xorq    %rax, %rax
    call    printf          # print the length and the string

    jmp    .L8

.L5:
    subq    $16, %rsp       # allocate 16 bytes on the stack

    movq    $format4, %rdi
    leaq    8(%rsp), %rsi
    leaq    (%rsp), %rdx
    xorq    %rax, %rax
    call    scanf           # read 2 integers from the user, representing indices

    movq    24(%rsp), %rdi
    movq    16(%rsp), %rsi
    movq    8(%rsp), %rdx
    movq    (%rsp), %rcx
    call    pstrijcmp       # compare the two pstrings, from the first index to the second index

    movq    $format6, %rdi
    movq    %rax, %rsi
    xorq    %rax, %rax
    call    printf          # print the result

    jmp    .L8

.L6:    
    movq    $format7, %rdi
    xorq    %rax, %rax
    call    printf          # print the default case

    jmp     .L8
