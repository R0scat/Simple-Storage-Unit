.section .note.GNU-stack,"",@progbits
.data
    memry: .space 1024
    formatPrintf: .asciz "%d\n" # default with endline
    formatPrintEndline: .asciz "\n" # prints just \n
    formatPrintDescF: .asciz "%d: "
    formatScanf: .asciz "%d"
    virgula: .ascii ", "
    descF: .long 5
    dim: .long 20
    nrOp: .space 4
    op: .space 4
    nrFisiere: .space 4
    getParanteza1: .asciz "(%d"
    getParanteza2: .asciz "%d)\n"
    getVirgula: .asciz ", "
    frecv: .space 1024 # only used in the print function
.text

# FUNCTIA FRECV MEMORY (debug exclusive)

printFrecv:
    push %eax
    push %ebx
    push %esi
    mov $frecv, %esi
    xor %ebx, %ebx
    xor %ecx, %ecx

printFrecvLoop:
    cmp $10, %ebx # cate elemente afiseaza!!! totalul ar trebui 1024 dar folosesc atata pt debug :P
    je printFrecvExit

    movb (%esi, %ebx, 1), %cl
    
    push %ecx
    push $formatPrintf
    call printf
    pop %eax
    pop %ecx

    inc %ebx
    jmp printFrecvLoop

printFrecvExit:
    pop %esi
    pop %ebx
    pop %eax
    ret

# FUNCTIA PRINT MEMORY (DEBUG EXCLUSIVE)

printMemory:
    push %ebx
    push %edi
    mov $memry, %edi
    xor %ebx, %ebx
    xor %ecx, %ecx

printMemoryLoop:
    cmp $1024, %ebx # cate elemente afiseaza!!! totalul ar trebui 1024 dar folosesc atata pt debug :P
    je printMemoryExit


    movb (%edi, %ebx, 1), %cl
    
    push %ecx
    push $formatPrintf
    call printf
    pop %eax
    pop %ecx

    inc %ebx
    jmp printMemoryLoop

printMemoryExit:
    pop %edi
    pop %ebx
    ret

# FUNCTIA ADD

addMain:
    push %ebp
    mov %esp, %ebp
    mov 12(%ebp), %eax # dim
    mov 8(%ebp), %ecx # descF
    push %edi
    lea memry, %edi # edi mentine vectorul
    push %esi 
    mov $0xFFFFFFFF, %esi # esi este -1

    # toate liniile astea de cod doar pt o impartire ca idee
    push %edx
    push %ebx

    mov $0, %edx
    mov $8, %ebx
    div %ebx # acum %eax retine === nrB si %edx retine restul
    cmp $0, %edx
    jne addChangeNrB
    jmp addMainPart2

addChangeNrB:
    add $1, %eax
    
addMainPart2:    
    pop %ebx
    pop %edx

    # fisier minim 2 blocuri
    cmp $1, %eax
    jle addMinimumSpace
    jmp addMainPart3

addMinimumSpace:
    mov $2, %eax

addMainPart3:
    push %edx
    xor %edx, %edx # indexul/ pozC
    push %ebx
    xor %ebx, %ebx

addMainLoop:
    cmp $1024, %edx
    je addExit
    # conditia start == -1 !! %esi retine startul --initializare comentata
    cmp $0xFFFFFFFF, %esi 
    jne addSecondFor

    movb (%edi, %edx, 1), %bl # retine val elementului curent
    cmp $0, %ebx
    je addMainIf
    jmp addMainLoopContinue

addMainIf: # daca nu e indeplinita conditia NU intra in if!! 
    push %ecx
    mov $1, %ecx # ok = 1
    push %ebx
    push %edx
    mov %edx, %ebx # ebx devine pozVerif
    add $1, %ebx # adauga 1 la pozVerif
    add %eax, %edx # edx retine pozC + nrB


addMainIfLoop:
    cmp %ebx, %edx # cmp pozVerif, pozC + nrB
    je addMainIfContinue

    cmpb $0, (%edi, %ebx, 1) # cmp memry[pozVerif], 0
    jne changeOk

addMainIfLoopInc:
    inc %ebx 
    jmp addMainIfLoop

changeOk: # intra aici doar prin addMainLoop pt ca am pus jmp mai sus
    mov $0, %ecx
    jmp addMainIfLoopInc

addMainIfContinue:
    pop %edx # sa retina primul pozC din nou
    cmp $1, %ecx
    je changeStart
    jmp addMainIfExit

changeStart:
    mov %edx , %esi # esi retine startul

addMainIfExit:
    pop %ebx
    pop %ecx

addMainLoopContinue:
    inc %edx
    jmp addMainLoop

addSecondFor:
    mov $0, %edx # edx devine i

addSecondLoop:
    cmp %edx, %eax 
    je addExit

    movb %cl, (%edi, %esi, 1)
    # urm 3 linii pt debug - sa vad ce este pus in vector mai exact
#     push %ebx
    # mov (%edi, %esi, 1), %ebx
#    pop %ebx

    inc %esi
    inc %edx
    jmp addSecondLoop

addExit:
    pop %ebx
    pop %edx
    pop %esi
    pop %edi
    pop %ebp
    ret

# FUNCTIA GET
# MOMENTAN INCOMPLETA!!!!!!! 
# CEVA GRESIT LA START??

getMain:
    push %ebp
    mov %esp, %ebp
    mov 8(%ebp), %edx # descF
    mov $0xFFFFFFFF, %eax # start
    push %ebx
    mov $0xFFFFFFFF, %ebx # stop 
    xor %ecx, %ecx # ecx = pozC
    push %edi
    mov $memry, %edi # pt vector

getFirstLoop:
    cmp $1024, %ecx
    je getSecond
    cmp $0xFFFFFFFF, %eax
    jne getSecond

    cmpb (%edi, %ecx, 1), %dl
    je getChangeStart
    jmp getFirsLoopInc

getChangeStart:
    mov %ecx, %eax

getFirsLoopInc:
    inc %ecx
    jmp getFirstLoop

getSecond:
    cmp $0xFFFFFFFF, %eax
    je nuExista
    mov %eax, %ecx

getSecondLoop:
    cmp $1024, %ecx
    je getIf
    cmp $0xFFFFFFFF, %ebx
    jne getPrint

    cmpb (%edi, %ecx, 1), %dl
    jne getChangeStop
    jmp getSecondLoopInc

getChangeStop:
    mov %ecx, %ebx
    sub $1, %ebx

getSecondLoopInc:
    inc %ecx
    jmp getSecondLoop

getPrint:
    mov %eax, %edx
    xor %eax, %eax # al == 0 needed apt ??? (am citit pe un site lol?)

getIf:
    cmp $1024, %ecx
    je fullMemory
    cmp $0xFFFFFFFF, %ebx
    je startEqualStop
    jmp getPrintContinue

startEqualStop:
    mov %edx, %ebx
    jmp getPrint

fullMemory:
    # xor %ecx, %ecx
    mov $1023, %ecx
    cmpb $0, (%edi, %ecx, 1)
    je notQuiteFull

    mov $1023, %ebx # stop = ultimul element
    jmp getPrint

notQuiteFull:
    mov $1022, %ebx
    jmp getPrint

nuExista:
    mov $0, %edx
    mov $0, %ebx

getPrintContinue:
    push %edx
    push $getParanteza1
    call printf
    pop %ecx
    pop %ecx

    push $getVirgula
    call printf
    pop %ecx

    push %ebx
    push $getParanteza2
    call printf
    pop %ecx
    pop %ecx

getExit:
    pop %edi
    pop %ebx
    pop %ebp
    ret

# FUNCTIA DELETE

deleteMain:
    push %ebp
    mov %esp, %ebp
    xor %ecx, %ecx # ecx = pozC
    push %edx
    mov 8(%ebp), %edx # edx = descF
    push %edi
    lea memry, %edi

deleteLoop:
    cmp $1024, %ecx 
    je deleteExit

    cmpb (%edi, %ecx, 1), %dl # memry[pozC] == descF?
    je deleteElement
    jmp deleteLoopInc

deleteElement:
    movb $0, (%edi, %ecx, 1) # delete ul propriu-zis

deleteLoopInc:
    inc %ecx
    jmp deleteLoop

deleteExit:
    pop %edi
    pop %edx
    pop %ebp
    ret

# FUNCTIA DEFRAGMENTATION

defragmentationMain:
    push %eax # i index
    push %ecx # j index
    push %edi # adresa de memorie a vectorului

    xor %eax, %eax
    xor %ecx, %ecx
    lea memry, %edi

defragLoop:
    cmp $1024, %eax
    je defragExit

    
    # linii pt debug
    push %ebx
    xor %ebx, %ebx
    movb (%edi, %eax, 1), %bl
    pop %ebx
    # end debug 

    cmpb $0, (%edi, %eax, 1)
    je defragSecond
    jmp defragLoopInc

defragSecond:
    mov %eax, %ecx 
    add $1, %ecx # j = i + 1

defragSecondLoop:
    cmp $1024, %ecx
    je defragLoopInc
    cmpb $0, (%edi, %eax, 1) # memry[i] == 0
    jne defragLoopInc

    cmpb $0, (%edi, %ecx, 1) # memry[j] != 0
    jne defragSwap
    jmp defragSecondLoopInc

defragSwap:
    push %ebx # ebx = aux
    xor %ebx, %ebx

    movb (%edi, %eax, 1), %bl # aux = memry[i]
    movb (%edi, %ecx, 1), %bh
    movb %bh, (%edi, %eax, 1) # memry[i] = memry[j]
    movb %bl, (%edi, %ecx, 1) # memry[j] = aux !!! AICI PRIMESTE SEGM FAULT

    pop %ebx

defragSecondLoopInc:
    inc %ecx
    jmp defragSecondLoop

defragLoopInc:
    inc %eax
    jmp defragLoop

defragExit:
    pop %edi
    pop %ecx
    pop %eax
    ret

# PRINT AS ASKED FUNCTION!!

printEverything:
    push %ecx
    push %eax
    push %esi
    push %edi
    xor %ecx, %ecx # indicele i
    xor %eax, %eax # k = lungimea finala a vect de frecv
    lea frecv, %esi
    lea memry, %edi # de parca nu o avea deja be fr 

# frecv trebuie initializat cu 0 pentru FIECARE APELARE!!
initFrecv:
    cmp $1024, %ecx
    je printEverythingStart

    movb $0, (%esi, %ecx, 1)

    inc %ecx
    jmp initFrecv

printEverythingStart:
    xor %ecx, %ecx

printEverythingLoop:
    cmp $1024, %ecx
    je printEverythingSecond

    push %ebx
    mov $1, %bl # %bl = ok
    push %edx
    xor %edx, %edx # edx = indicele j

printImbricatedLoop:
    cmp %eax, %edx
    je printEverythingLoopContinue
    movb (%edi, %ecx, 1), %bh # bh reg auxiliar
    cmpb %bh, (%esi, %edx, 1) # memry[i] == frecv[j]
    je printChangeOk
    jmp printImbricatedLoopInc

printChangeOk:
    mov $0, %ebx

printImbricatedLoopInc:
    inc %edx
    jmp printImbricatedLoop

printEverythingLoopContinue:
    cmp $1, %bl # actually negated the if statement in my C sketch for this to work lol
    jne printEverythingLoopInc
    cmpb $0, (%edi, %ecx, 1)
    je printEverythingLoopInc
    # ellse: 
    push %edx
    movb (%edi, %ecx, 1), %dl # memry[i] pastrat in auxiliar
    movb %dl, (%esi, %eax, 1) # frecv[k] = memry[i]
    
    # pt debug only
    movb (%esi, %eax, 1), %dl
    # end debug only

    add $1, %eax # k++

    # pt debug only
    movb (%esi, %eax, 1), %dl
    # end debug only
    pop %edx

printEverythingLoopInc:
    pop %edx
    pop %ebx
    inc %ecx
    jmp printEverythingLoop

printEverythingSecond:
    xor %ecx, %ecx
    /*push %edx
    mov %eax, %edx */
    # call printFrecv DEBUG

printEverythingSecondLoop: # the actual printing of the variables - takes every element in the frequency vector
    cmp %eax, %ecx 
    je printEverythingExit

    # descF:
    push %ecx
    push %eax
    push %ebx # to keep ebx

    xor %ebx, %ebx
    movb (%esi, %ecx, 1), %bl
    push %ebx
    push $formatPrintDescF
    call printf
    pop %ebx
    pop %ebx

    pop %ebx
    pop %eax
    pop %ecx

    # (start, stop)
    push %ecx  # to keep ecx 
    push %eax # to keep eax for sure 
    push %ebx # to keep ebx

    push (%esi, %ecx, 1)
    call getMain
    pop %ebx

    pop %ebx
    pop %eax
    pop %ecx

    inc %ecx
    jmp printEverythingSecondLoop

printEverythingExit:
    pop %edi
    pop %esi
    pop %eax
    pop %ecx
    ret

# GLOBAL MAIN

.global main

main:
    # initializez memoria cu 0
    mov $0, %eax # folosesc eax ca index
    lea memry, %edi

initiereLoop:
    cmp $1024, %eax 
    je continue

    movb $0, (%edi, %eax, 1)

    inc %eax
    jmp initiereLoop

    # de aici memoria este complet 0

continue:
    push $nrOp
    push $formatScanf
    call scanf 
    pop %eax
    pop %eax

    xor %eax, %eax # indicele i cu care merge prin for

nrOpLoop:
    push %eax
    cmp nrOp, %eax
    je exit

    push %eax # pop-ul asta NU este pt call, ci ca indexul sa isi pastreze valoarea
    
    push $op
    push $formatScanf
    call scanf
    pop %eax
    pop %eax

    pop %eax

    cmpl $1, op # ADD
    je addOp 
    cmpl $2, op # GET
    je getOp
    cmpl $3, op # DELETE
    je deleteOp
    cmpl $4, op # DEFRAG
    je defragOp

    jmp nrOpLoopInc

addOp:
    push $nrFisiere
    push $formatScanf
    call scanf
    pop %ecx
    pop %ecx
    
    xor %ebx, %ebx # ebx = fisier curent

loopAdd:
    cmp nrFisiere, %ebx
    je addOpExit

    push $descF
    push $formatScanf
    call scanf
    pop %ecx
    pop %ecx

    push $dim
    push $formatScanf
    call scanf
    pop %ecx
    pop %ecx

    push dim
    push descF
    call addMain
    pop %ecx
    pop %ecx

    # printing result:

    push descF
    push $formatPrintDescF
    call printf
    pop %ecx
    pop %ecx

    push descF
    call getMain
    pop %ecx
    
    inc %ebx
    jmp loopAdd

addOpExit:
    # call printEverything

    jmp nrOpLoopInc

getOp:
    push $descF
    push $formatScanf
    call scanf
    pop %ecx
    pop %ecx

    push descF
    call getMain
    pop %ecx

    jmp nrOpLoopInc

deleteOp:
    push $descF
    push $formatScanf
    call scanf
    pop %ecx
    pop %ecx

    push descF
    call deleteMain
    pop %ecx

    call printEverything
    
    jmp nrOpLoopInc

defragOp:
    call defragmentationMain

    call printEverything

    jmp nrOpLoopInc

nrOpLoopInc:
    # debug endline

#    push $formatPrintEndline
#    call printf
#    pop %ecx

    pop %eax
    inc %eax
    jmp nrOpLoop

exit:
    pushl $0
    call fflush
    popl %eax

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

# OBS: daca NU mai poate adauga elementul NU afisez nimic
