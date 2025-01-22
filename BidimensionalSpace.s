.section .note.GNU-stack,"",@progbits
.data
    memry: .zero 1048576 # = 2^20 deci lucrez pe biti
    auxMemry: .zero 1048576
    formatPrintWithSpace: .asciz "%d "
    formatPrintEndline: .asciz "\n"
    formatPrint0: .asciz "((0, 0), (0, 0))\n"
    formatPrintGet: .asciz "((%d, %d), (%d, %d))\n"
    formatPrintDescF: .asciz "%d: "
    formatScanf: .asciz "%d"
    # ultimaLinie: .zero 4 # long initializat la start cu 0!
    auxUltimaLinie: .zero 4 
    descF: .long 5
    dim: .long 2000
    nrB: .space 4 # folosit doar pt debug rn
    linieGet: .space 4
    getPrimulStop: .space 4
    nrOp: .space 4
    op: .space 4
    nrFisiere: .space 4
.text

# FUNCTIE PRINT DE DEBUG 

printMemory:
    push %eax
    push %ecx
    push %ebx
    push %edx
    lea memry, %edi # edi va avea mereu valoarea primei adrese de mem.
    xor %eax, %eax

printMemoryLineLoop:
    cmp $1024, %eax  
    je printMemoryExit

    xor %ecx, %ecx

printMemoryColumnLoop:
    cmp $1024, %ecx 

    # inmultirea indexului de linie cu 1024:
    push %eax
    xor %edx, %edx
    mov $1024, %ebx 
    mul %ebx

    # adunarea cu indexul de coloana:
    mov %ecx, %ebx # ebx are aceeasi val ca indexul de coloana
    add %eax, %ebx # ebx = i * 1024 + j
    pop %eax 
    
    push %eax
    push %ecx

    movb (%edi, %ebx, 1), %dl
    push %edx
    push $formatPrintWithSpace
    call printf
    pop %ebx
    pop %ebx

    pop %ecx
    pop %eax

printMemoryColumnLoopInc:
    inc %ecx
    jmp printMemoryColumnLoop

printMemoryLineLoopInc:
    push %eax # astea sunt aici pt ca printf ul hates me
    push %ecx

    push $formatPrintEndline
    call printf
    pop %ebx

    pop %ecx
    pop %eax

    inc %eax 
    jmp printMemoryLineLoop

printMemoryExit:
    push %eax
    push %ecx

    push $formatPrintEndline
    call printf
    pop %ebx

    pop %ecx
    pop %eax
    
    pop %edx
    pop %ebx
    pop %ecx
    pop %eax
    ret

# FUNCTIE SPECIALA PENTRU AUXMEMORY DEBUG !!!!
# DEBUG! !!!!!!!!

printAuxMemory:
    push %eax
    push %ecx
    push %ebx
    push %edx
    push %edi

    lea auxMemry, %edi # edi va avea mereu valoarea primei adrese de mem.
    xor %eax, %eax

printAuxMemoryLineLoop:
    cmp $16, %eax  
    je printAuxMemoryExit

    xor %ecx, %ecx

printAuxMemoryColumnLoop:
    cmp $16, %ecx 
    je printAuxMemoryLineLoopInc

    # inmultirea indexului de linie cu 1024:
    push %eax
    xor %edx, %edx
    mov $16, %ebx 
    mul %ebx

    # adunarea cu indexul de coloana:
    mov %ecx, %ebx # ebx are aceeasi val ca indexul de coloana
    add %eax, %ebx # ebx = i * 1024 + j
    pop %eax 
    
    push %eax
    push %ecx

    movb (%edi, %ebx, 1), %dl
    push %edx
    push $formatPrintWithSpace
    call printf
    pop %ebx
    pop %ebx

    pop %ecx
    pop %eax

printAuxMemoryColumnLoopInc:
    inc %ecx
    jmp printAuxMemoryColumnLoop

printAuxMemoryLineLoopInc:
    push %eax 
    push %ecx

    push $formatPrintEndline
    call printf
    pop %ebx

    pop %ecx
    pop %eax

    inc %eax 
    jmp printAuxMemoryLineLoop

printAuxMemoryExit:
    push %eax
    push %ecx

    push $formatPrintEndline
    call printf
    pop %ebx

    pop %ecx
    pop %eax
    
    pop %edi
    pop %edx
    pop %ebx
    pop %ecx
    pop %eax
    ret

# FUNCTIE DE PRINTARE A INTREGII MATRICE ASA CUM CERE ENUNTUL !!!!

printEverything:
    push %ecx
    push %eax
    push %esi
    push %edi
    xor %ecx, %ecx # indicele i
    xor %eax, %eax # k = lungimea finala a vect de frecv
    lea auxMemry, %esi
    lea memry, %edi # de parca nu o avea deja be fr 

# frecv trebuie initializat cu 0 pentru FIECARE APELARE!!

printEverythingStart:
    xor %ecx, %ecx

printEverythingLoop:
    cmp $1048576, %ecx
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
    cmp $1, %bl 
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
    # call printAuxMemory # DEBUG

printEverythingSecondLoop: # the actual printing of the variables - takes every element in the frequency vector
    cmp %eax, %ecx 
    je resetAux

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

resetAux:
    movl $0, auxUltimaLinie
    xor %ecx, %ecx

resetAuxLoop:
    cmp $1048576, %ecx
    je printEverythingExit

    movb $0, (%esi, %ecx, 1)

    inc %ecx
    jmp resetAuxLoop

printEverythingExit:
    # call printAuxMemory # pt debug 

    pop %edi
    pop %esi
    pop %eax
    pop %ecx
    ret


# FUNCTIE AJUTATOARE DE AFLARE INDEX

calculeazaIndex:
    push %ebp
    mov %esp, %ebp

    mov 12(%ebp), %eax # linie
    mov 8(%ebp), %ecx # coloana
    
    push %eax
    push %edx
    push %ecx

    xor %edx, %edx
    mov $1024, %ebx 
    mul %ebx

    # adunarea cu indexul de coloana:
    mov %ecx, %ebx # ebx are aceeasi val ca indexul de coloana
    add %eax, %ebx # ebx = i * 1024 + j

    # DECI A CALCULAT INDEXUL IN REG %ebx !!!!

calculeazaIndexExit:
    pop %ecx
    pop %edx
    pop %eax
    pop %ebp
    ret


# FUNCTIA ADD

addMain:
    push %ebp
    mov %esp, %ebp
    # mov 12(%ebp), %ecx # descF
    mov 8(%ebp), %eax # dim
    lea memry, %edi # edi mentine memry
    push %ebx 
    mov $0, %ebx # ebx = adaugat

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

    mov %eax, %edx
    # de aici edx = nrB

    # fisier minim 2 blocuri
    cmp $1, %edx
    jle addMinimumSpace
    jmp addMainPart3

addMinimumSpace:
    mov $2, %edx

addMainPart3:
    mov $0, %eax # indexul/ linie

addLineLoop:
    cmp $1024, %eax 
    je addExit
    cmp $0, %ebx # adaugat == 0?
    jne addExit

    mov $0xFFFFFFFF, %esi # esi = start
    xor %ecx, %ecx

addFindStartLoop:
    cmp $1024, %ecx # ecx = j ALSO 
    cmp $0xffffffff, %esi
    jne addLineLoopPart2

    push %ebx # functia calculeazaIndex facuta sa pastreze indexul in ebx

    push %eax # linie
    push %ecx # coloana
    call calculeazaIndex
    pop %ecx
    pop %eax

    # PT DEBUG ONLY
    push %eax
    movb (%edi, %ebx, 1), %al
    pop %eax
    # END DEBUG ONLY

    cmpb $0, (%edi, %ebx, 1)
    je addChangeStart
    pop %ebx # ebx reprimeste valoarea "adaugat"
    jmp addFindStartLoopInc

addChangeStart:
    pop %ebx # ebx reprimeste valoarea "adaugat"
    mov %ecx, %esi # startul devine j

addFindStartLoopInc:
    inc %ecx
    jmp addFindStartLoop

addLineLoopPart2:
    cmp $0xFFFFFFFF, %esi # daca pe linia respectiva nu s-a gasit nicio pozitie libera trece la urm linie
    je addLineLoopInc

    mov %esi, %ecx
    add $1, %ecx # ecx = j = start + 1

    push %ebx # pastreaza valoarea adaugat
    push %edx # salvez nrB 
    add %esi, %edx # edx = nrB + start
    # add $1, %edx # edx = nrB + start + 1

    cmp $1024, %edx
    jle addCheckIfFitting # daca nu sare aici inseamna ca nu are loc pe linie
    pop %edx # nu e nevoie de folosirea registrilor salvati precedent asa ca se reiau
    pop %ebx
    jmp addLineLoopInc

addContinueColumnLoop:
    add $1, %ecx
    mov $0xFFFFFFFF, %esi
    pop %edx
    pop %ebx
    jmp addFindStartLoop

addCheckIfFitting:
    # deja am %ecx = start + 1 = j
    mov $1, %ebx # ebx = ok

addCheckIfFittingLoop:
    cmp $0, %ebx
    je addContinueColumnLoop
    cmp %edx, %ecx # j == start + nrb? # + 1?
    je addFillArray

    push %ebx # ca sa pastrez ok-ul

    push %eax # linie
    push %ecx # coloana 
    call calculeazaIndex
    pop %ecx
    pop %eax

    # PT DEBUG ONLY
    push %eax
    movb (%edi, %ebx, 1), %al
    pop %eax
    # END DEBUG ONLY

    cmpb $0, (%edi, %ebx, 1)
    jne addChangeOk
    pop %ebx # peste asta poate sarii --> daca nu sare reprimeste ok
    jmp addCheckIfFittingLoopInc

addChangeOk:
    pop %ebx # reprimeste ok / si peste asta poate sarii DAR NU IN AMBELE CAZURI IEI
    mov $0, %ebx # ok = 0 

addCheckIfFittingLoopInc:
    inc %ecx
    jmp addCheckIfFittingLoop

addFillArray:
    pop %edx # edx = nrB din nou

    xor %ecx, %ecx # j = 0

    cmp $1, %ebx
    je addFillArrayLoop
    pop %ebx # reprimeste adaugat
    jmp addFillArrayContinue

addFillArrayLoop:
#   pop %ebx # reprimeste adaugat

    cmp %edx, %ecx # j == nrB ? 
    je addFillArrayContinue

    push %ebx # salveaza adaugat 

    push %ecx
    push %eax # linie
    push %esi # coloana / in cazul nostru start
    call calculeazaIndex
    pop %esi
    pop %eax
    pop %ecx

    push %ecx
    mov 12(%ebp), %ecx
    movb %cl, (%edi, %ebx, 1)
    pop %ecx

    pop %ebx
    add $1, %esi

    inc %ecx
    jmp addFillArrayLoop

addFillArrayContinue: # nevoie de setarea ultimei linii si adaugat = 1
    pop %ebx # reprimeste val adaugat

    mov $1, %ebx # adaugat = 1
    # movl %eax, ultimaLinie # ultimaLinie este ultima linie la care s-a adaugat ceva :P

addLineLoopInc:
    inc %eax
    jmp addLineLoop
    
addExit:
    pop %ebx
    pop %ebp
    ret

# !!!!!!!!!!!!!!!!!
#
# FUNCTIE AUXILIARA
#
# !!!!!!!!!!!!!!!!!

addAux:
    push %ebp
    mov %esp, %ebp
    # mov 12(%ebp), %ecx # descF
    mov 8(%ebp), %edx # nrB
    push %edi
    lea auxMemry, %edi # edi mentine auxMemry
    push %ebx 
    mov $0, %ebx # ebx = adaugat

    mov auxUltimaLinie, %eax # indexul/ linie

auxLineLoop:
    cmp $1024, %eax 
    je auxExit
    cmp $0, %ebx # adaugat == 0?
    jne auxExit

    mov $0xFFFFFFFF, %esi # esi = start
    xor %ecx, %ecx

auxFindStartLoop:
    cmp $1024, %ecx # ecx = j 
    je auxLineLoopPart2
    cmp $0xffffffff, %esi
    jne auxLineLoopPart2

    push %ebx # functia calculeazaIndex facuta sa pastreze indexul in ebx

    push %eax # linie
    push %ecx # coloana
    call calculeazaIndex
    pop %ecx
    pop %eax

    # PT DEBUG ONLY
    push %eax
    movb (%edi, %ebx, 1), %al
    pop %eax
    # END DEBUG ONLY

    cmpb $0, (%edi, %ebx, 1)
    je auxChangeStart
    pop %ebx # ebx reprimeste valoarea "adaugat"
    jmp auxFindStartLoopInc

auxChangeStart:
    pop %ebx # ebx reprimeste valoarea "adaugat"
    mov %ecx, %esi # startul devine j

auxFindStartLoopInc:
    inc %ecx
    jmp auxFindStartLoop

auxLineLoopPart2:
    cmp $0xFFFFFFFF, %esi # daca pe linia respectiva nu s-a gasit nicio pozitie libera trece la urm linie
    je auxLineLoopInc

    mov %esi, %ecx
    add $1, %ecx # ecx = j = start + 1

    push %ebx # pastreaza valoarea adaugat
    push %edx # salvez nrB 
    add %esi, %edx # edx = nrB + start

    cmp $1024, %edx
    jle auxCheckIfFitting # daca nu sare aici inseamna ca nu are loc pe linie
    pop %edx # nu e nevoie de folosirea registrilor salvati precedent asa ca se reiau
    pop %ebx
    jmp auxLineLoopInc

auxCheckIfFitting:
    # deja am %ecx = start + 1 = j
    mov $1, %ebx # ebx = ok

auxCheckIfFittingLoop:
    cmp %edx, %ecx # j == start + nrb?
    je auxFillArray
    cmp $0, %ebx
    je auxLineLoopInc

    push %ebx # ca sa pastrez ok-ul

    push %eax # linie
    push %ecx # coloana 
    call calculeazaIndex
    pop %ecx
    pop %eax

    # PT DEBUG ONLY
    push %eax
    movb (%edi, %ebx, 1), %al
    pop %eax
    # END DEBUG ONLY

    cmpb $0, (%edi, %ebx, 1)
    jne auxChangeOk
    pop %ebx # peste asta poate sarii --> daca nu sare reprimeste ok
    jmp auxCheckIfFittingLoopInc

auxChangeOk:
    pop %ebx # reprimeste ok / si peste asta poate sarii DAR NU IN AMBELE CAZURI IEI
    mov $0, %ebx # ok = 0 

auxCheckIfFittingLoopInc:
    inc %ecx
    jmp auxCheckIfFittingLoop

auxFillArray:
    pop %edx # edx = nrB din nou

    xor %ecx, %ecx # j = 0

    cmp $1, %ebx
    je auxFillArrayLoop
    pop %ebx # reprimeste adaugat
    jmp auxFillArrayContinue

auxFillArrayLoop:
#   pop %ebx # reprimeste adaugat

    cmp %edx, %ecx # j == nrB ? 
    je auxFillArrayContinue

    push %ebx # salveaza adaugat 

    push %ecx
    push %eax # linie
    push %esi # coloana / in cazul nostru start
    call calculeazaIndex
    pop %esi
    pop %eax
    pop %ecx

    push %ecx
    mov 12(%ebp), %ecx
    movb %cl, (%edi, %ebx, 1)
    pop %ecx

    pop %ebx
    add $1, %esi

    inc %ecx
    jmp auxFillArrayLoop

auxFillArrayContinue: # nevoie de setarea ultimei linii si adaugat = 1
    pop %ebx # reprimeste val adaugat

    mov $1, %ebx # adaugat = 1
    movl %eax, auxUltimaLinie # ultimaLinie este ultima linie la care s-a adaugat ceva :P

auxLineLoopInc:
    inc %eax
    jmp auxLineLoop
    
auxExit:
    pop %ebx
    pop %edi
    pop %ebp
    ret

# FUNCTIA GET
# Second Try:

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
    cmp $1048576, %ecx # TB SCHIMBAT LA 1048576
    je getDoesItExist
    cmp $0xFFFFFFFF, %eax
    jne getSecond

    cmpb (%edi, %ecx, 1), %dl
    je getChangeStart
    jmp getFirstLoopInc

getChangeStart:
    mov %ecx, %eax

getFirstLoopInc:
    inc %ecx
    jmp getFirstLoop

getDoesItExist:
    cmp $0xFFFFFFFF, %eax
    je nuExista

getSecond:
    cmp $0, %eax # start == 0? 
    je getSpecialCase0

getFindLineAndColumn:
    push %edx
    push %ebx
    push %eax # salveaza variabile

    xor %edx, %edx
    mov $1024, %ebx
    div %ebx # face start / 1024

    mov %edx, %ecx # pozC = start % 1024
    mov %edx, getPrimulStop # salvez si %1024 ca sa nu il mai calculez inca o data la afisare 
    mov %eax, linieGet # salvez linia ca sa nu mai fac impartirea INCA O DATA SMH IMPARTIREA LU MA_SA

    pop %eax # reprimeste start simplu
    pop %ebx
    pop %edx
    jmp getSecondLoop

getSpecialCase0:
    mov $1, %ecx # daca ia efectiv primul element care are indexul 0 atunci e clar ca pozC va fi 0
    movl $0, linieGet
    movl $0, getPrimulStop

getSecondLoop:
    cmp $1024, %ecx
    je getIf
    cmp $0xFFFFFFFF, %ebx
    jne getIf

    push %ebx

    push %ecx
    push linieGet # linie
    push %ecx     # coloana aka pozC
    call calculeazaIndex
    pop %ecx
    pop %ecx
    pop %ecx

    cmpb (%edi, %ebx, 1), %dl # memry[] != descf?
    jne getChangeStop
    pop %ebx
    jmp getSecondLoopInc

getChangeStop:
    pop %ebx
    mov %ecx, %ebx
    sub $1, %ebx

getSecondLoopInc:
    inc %ecx
    jmp getSecondLoop

getIf:
    cmp $1024, %ecx
    je fullMemory

    cmp $0xFFFFFFFF, %ebx
    je startEqualStop

    jmp getPrintContinue

startEqualStop:
    mov %edx, %ebx
    jmp getIf

fullMemory:
    # xor %ecx, %ecx
    mov $1023, %ecx

    push %ebx

    push %ecx # redundant dar il tin danke
    push linieGet
    push %ecx # coloana
    call calculeazaIndex
    pop %ecx
    pop %ecx
    pop %ecx

    cmpb $0, (%edi, %ebx, 1)
    je notQuiteFull

    pop %ebx
    mov $1023, %ebx # stop = ultimul element
    jmp getIf

notQuiteFull:
    pop %ebx
    mov $1022, %ebx
    jmp getIf

nuExista:
    push $formatPrint0
    call printf
    pop %ecx

    jmp getExit

getPrintContinue:
    push %ebx # stop
    push linieGet # start / 12
    push getPrimulStop # start % 12
    push linieGet  # start / 12
    push $formatPrintGet
    call printf
    pop %ecx
    pop %ecx
    pop %ecx
    pop %ecx
    pop %ebx

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
    push %eax
    mov $0, %eax # gasit == 
    push %ebx

deleteLoop:
    cmp $1048575, %ecx 
    je deleteExit

    movzbl (%edi, %ecx, 1), %ebx # conversie din byte in long

    cmp %ebx, %edx # memry[pozC] == descF?
    je deleteElement

    cmp %ebx, %edx # cand gaseste elem dif de descF verifica daca a fost deja sters descF
    jne deleteCheckGasit

    jmp deleteLoopInc

deleteElement:
    cmp $0, %eax
    je deleteChangeGasit
    movb $0, (%edi, %ecx, 1) # delete ul propriu-zis
    jmp deleteLoopInc

deleteChangeGasit:
    mov $1, %eax
    jmp deleteElement

deleteCheckGasit:
    cmp $1, %eax # daca a fost gasit si s-a sters deja practic
    je deleteExit # a fost gasit SI sters deja! a trecut la primul element de dupa :P
    # daca NU a fost gasit inainte atunci continua alergarea :P

deleteLoopInc:
    inc %ecx
    jmp deleteLoop

deleteExit:
    # call resetUltimaLinie
    pop %ebx
    pop %eax
    pop %edi
    pop %edx
    pop %ebp
    ret

# FUNCTIA DEFRAG 

defragMain:
    push %edi
    push %esi
    lea memry, %edi # edi adresa memry
    lea auxMemry, %esi # esi adresa auxMemry

    xor %ecx, %ecx # ecx = pozC

defragFirstLoop:
    cmp $1048576, %ecx
    je defragSecond

    cmpb $0, (%edi, %ecx, 1)
    jne defragMoveInAuxMemry
    jmp defragFirstLoopInc

defragMoveInAuxMemry:
    push %eax
    push %ebx
    push %edx

    mov $0, %eax # eax = nrB
    xor %ebx, %ebx
    movb (%edi, %ecx, 1), %bl # ebx = descF

defragWhile:
    cmpb (%edi, %ecx, 1), %bl
    jne defragMoveInAuxMemryContinue

    add $1, %eax
    inc %ecx
    jmp defragWhile

defragMoveInAuxMemryContinue:
    sub $1, %ecx

    push %ecx # de salvat in caz ca functia il omoara

    push %ebx # descF
    push %eax # nrB
    call addAux
    pop %ebx
    pop %eax

    pop %ecx

    pop %edx
    pop %ebx
    pop %eax

    # call printAuxMemory # PT DEBGUG

defragFirstLoopInc:
    inc %ecx
    jmp defragFirstLoop

defragSecond:
    xor %ecx, %ecx
    lea auxMemry, %esi

defragSecondLoop:
    cmp $1048576, %ecx
    je defragResetAux

    push %edx
    
    movb (%esi, %ecx, 1), %dl
    movb %dl, (%edi, %ecx, 1) # mov auxMemry[pozC], memry[pozC]
    
    pop %edx

    inc %ecx
    jmp defragSecondLoop

defragResetAux:
    movl $0, auxUltimaLinie
    xor %ecx, %ecx

defragResetAuxLoop:
    cmp $1048576, %ecx
    je defragExit

    movb $0, (%esi, %ecx, 1)

    inc %ecx
    jmp defragResetAuxLoop

defragExit:
    # call printAuxMemory

    pop %esi
    pop %edi
    ret


#
# GLOBAL MAIN STARTING POINT
#

.global main
main:
    lea memry, %edi

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

    push descF
    push dim
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
    call defragMain

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

    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
