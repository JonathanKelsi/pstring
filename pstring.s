	.data

	.section	.rodata
error:          .string     "invalid input!\n"

    .text	
	.globl  pstrlen
	.type   pstrlen, @function
pstrlen:
    pushq	%rbp		    # save the old frame pointer
	movq	%rsp,	%rbp	# create the new frame pointer

    movzbq  (%rdi), %rax    # the return value is the first byte of the struct (the string's length)

    movq	%rbp, %rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp		# restore old frame pointer (the caller function frame)
    ret


    .globl	replaceChar
	.type	replaceChar, @function	
replaceChar:
    pushq	%rbp		    # save the old frame pointer
	movq	%rsp,	%rbp	# create the new frame pointer
    
    movq    %rdi, %rax  # the return value is the pointer passed

    movzbq  (%rdi), %r8 # save the length of the string
    xorq    %r9, %r9     # initialize a counter for number of iterations passed 

.L1:
	cmpq    %r8, %r9    # if we've finished iterating over the string, exit the loop
	je		.L2

	inc 	%r9    # increment the counter
    inc     %rdi   # point to the next character of the string

    cmpb    (%rdi), %sil    # check if that charcter is the given char we want to replace
    jne     .L1             # if it's not, then continue to the next iteration
    movb    %dl, (%rdi)     # if it is, replace it
    jmp     .L1             # go on to the next iteration

.L2:
    movq	%rbp, %rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp		# restore old frame pointer (the caller function frame)
	ret
    
    
    .globl  pstrijcpy
	.type	pstrijcpy, @function	
pstrijcpy:
    pushq	%rbp		    # save the old frame pointer
	movq	%rsp,	%rbp	# create the new frame pointer

    cmpb    %cl, (%rdi)     # check that the second index is smaller than the first size
    jbe      .L4

    cmpb    %cl, (%rsi)     # ...and the seconds size
    jbe      .L4

    movzbq  %dl, %rax       # create a counter starting at the first index
    
.L3:
	cmpb    %cl, %al        # check if we've passed the other index  
	ja		.L5

    leaq    1(%rsi, %rax), %r8      # load the (address of the) i-th charcter from the source string
    movb    (%r8), %dl              # save that character 
    movb    %dl, 1(%rdi, %rax)      # copy it to the destination string 

    inc     %al    # increase the counter by 1     
    jmp     .L3      

.L4:
    # save %rdi on the stack, with respect to stack alignment
    subq    $16, %rsp
    movq    %rdi, (%rsp)

    # handle errors
    movq    $0, %rax
    movq    $error, %rdi
    call    printf

    # restore %rdi from the stack
    movq    (%rsp), %rdi

.L5:
    movq    %rdi, %rax    # the destination string's address is the return value
    movq	%rbp, %rsp	  # restore the old stack pointer - release all used memory.
	popq	%rbp		  # restore old frame pointer (the caller function frame)
	ret


    .globl  swapCase
	.type	swapCase, @function
swapCase:
    pushq	%rbp		    # save the old frame pointer
	movq	%rsp,	%rbp	# create the new frame pointer

    movq     %rdi, %rax  # the return value is the pointer passed

    movzbq  (%rdi), %r8 # save the length of the string
    movq    $0, %r9     # create a counter for number of iterations passed 

.L6:
	cmpq    %r8, %r9    # if we've finished iterating over the string, exit the loop
	je		.L8

	inc		%r9    # increment the counter
    inc     %rdi   # point to the next char of the string

    cmpb    $122, (%rdi)    # if the char has a ASCII value bigger than 'z', continue to next char 
    ja      .L6

    cmpb    $97, (%rdi)     # if the char has a ASCII value smaller than 'a', further investigation is needed
    jb      .L7

    # otherwise, change the char to its uppercase counterpart, and continue to the next char
    movb    (%rdi), %cl
    subb    $32, %cl
    movb    %cl, (%rdi)
    jmp     .L6

.L7:
    cmpb    $90, (%rdi) # if the character has a ASCII value bigger than 'Z', continue to next char 
    ja      .L6

    cmpb    $65, (%rdi) # if the character has a ASCII value smaller than 'A', continue to next char
    jb      .L6

    # otherwise, change it to its lowercase counterpart, and continue to the next char
    movb    (%rdi), %cl
    addb    $32, %cl
    movb    %cl, (%rdi)
    jmp     .L6

.L8:
    movq	%rbp, %rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp		# restore old frame pointer (the caller function frame)
	ret


    .globl  pstrijcmp
	.type	pstrijcmp, @function	
pstrijcmp:
    pushq	%rbp		    # save the old frame pointer
	movq	%rsp,	%rbp	# create the new frame pointer

    cmpb    %cl, (%rdi)    # check that the second index is smaller than the first size
    jbe     .L13

    cmpb    %cl, (%rsi)    # ...and the seconds size
    jbe     .L13

    movzbq  %dl, %rax      # create a counter starting at the first index
    
.L9:
	cmpb    %cl, %al      # if we've passed the other index, it means the sub-strings are equal
	ja		.L10

    leaq    1(%rdi, %rax), %r8      # load the (address of the) i-th charcter from the first string
    movb    (%r8), %dl             # save that character

    leaq    1(%rsi, %rax), %r8      # load the (address of the) i-th charcter from the second string
    movb    (%r8), %r8b             # save that character 

    cmpb    %r8b, %dl
    ja      .L11    # if the first sub-string is lexicographically bigger, return 1
    jb      .L12    # if the second sub-string is lexicographically bigger, return -1
   
    inc     %al    # increase the counter by 1     
    jmp     .L9      

.L10:
    xorq    %rax, %rax
    movq	%rbp, %rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp		# restore old frame pointer (the caller function frame)    
	ret

.L11:
    movq    $1, %rax
    movq	%rbp, %rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp		# restore old frame pointer (the caller function frame)
    ret

.L12:
    movq    $-1, %rax
    movq	%rbp, %rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp		# restore old frame pointer (the caller function frame)
    ret

.L13:
    # handle errors
    xorq    %rax, %rax
    movq    $error, %rdi
    call    printf

    movq    $-2, %rax
    movq	%rbp, %rsp	# restore the old stack pointer - release all used memory.
	popq	%rbp		# restore old frame pointer (the caller function frame)
    ret
    
