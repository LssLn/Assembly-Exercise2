;# ESAME 13/01/2020 T2
;# ciclo for 4 in cui scanf STR e inserisco in N la sua strlen.
;# Poi scanf l'indice i della stringa da processare (passo alla funzione STR[i],N[i])
;#la funzione fa un ciclo for della strlen della str passata e se vede che un elemento di str[] è >= 58 (cioè non è un numero (i numeri in ascii vanno da 47 a 57); se si rompe il ciclo e torna l'indice i precedente (l'ultimo che non era >=58). Se nessuno soddisfa >=58 ritorna l'indice i a fine for, cioè i=strlen(d)
;#questo indice ritornato è A, infine stampo il msg3 che ha 2 argomenti : questo indice tornato dalla funzione, A, e l'indice acquisito con msg2 per scegliere STR[i] e N[i] da passare
.data 
STR: .space 64 ;# char STR[4][16]
N: .space 32 ;# int N[4];
msg1: .asciiz "Inserire str:"
ms3: .asciiz "inserire indice str"
msg3: .asciiz "A[%d]=%d\n"

p1s5: .space 8 ;# printf
ind_i: .space 8 ;# 1° arg  di msg3
A_i: .space 8 ;# 2° arg di msg3

p1s3: .word 0 ;# fd null ovvero stdin
ind: .space 8 ;# dove comincia a scrivere
dim: .word 16 ;#num_byte letti

stack: .space 32 ;# di default 32, ne uso 8 qui

.code: 
;#inizializzo lo stack
    daddi $sp,$0,stack
    daddi $sp,$sp,32
;#STR[X*i] = STR + X*i
;# uso $s0 come indice i, multiplo di 16 (per str)
;# l'indice i di N dovrà essere o la metà di $s0 o un altro registro multiplo di 8 comunque

;#for(i=0;i<4;i++)
    daddi $s0,$0,0 ;#i=0
for: 
    slti $t0, $s0,64 ;# $t0=0 quando i>= 4(16*4)
    beq $t0,0,print2 ;# quando i=4 (4*16) endfor
    ;#printf msg1
    daddi $t0,$0,msg1 
    sd $t0,p1s5($0)
    daddi r14,$0,p1s5
    syscall 5
    ;#scanf %s STR[i]
    daddi $t0,$s0,STR ;#come ho detto prima, STR[i] ==> STR + i * 16 ==> STR + $s0
    sd $t0, Ind($0) ;# Ind($0) o Ind($s0) ?
    daddi r14, $0,p1s3
    syscall 3
    ;# N[i] = strlen(STR[i]);
    dsra $t0,$s0,1 ;# indice i per N (*8) quindi divido i di STR per 2 --> $t0=$s0/2 (dsra sposta a dx di 1 (divide per 2^1)
    sd r1,N($t0) ;# N[i] = strlen (r1 contiene numbyte letti della scanf)

    ;#i++ di fine ciclo for
    daddi $s0,$s0,16 ;# $t0=$s0/2 quindi non serve un altro i++ per $t0
    j for ;# loop for

;# printf msg2 inserisci l'indice str 
print2 : 
    daddi $t0,$0,msg2
    sd $t0,p1s5($0)
    daddi r14,$0,p1s5
    syscall 5
;# scanf("%d),&i)
    jal input_unsigned ;# o Input_unsigned dipende dal file
    move $s1,r1 ;# $s1 = i da usare in STR[i] N[i]

;# A = processa (STR[i], N[i]) 
;# passaggio parametri
    ;# STR[i] i++ corrisponde a $s1 * 16
    dsll $t0,$s1,4  ;#shift sx= molt * 16 : *2^4
    daddi $a0,$t0,STR ;#$a0 = STR[i]
    ;# $a1 = N[i]
    dsll $t0,$s1,3   ;#shif sx=molt * 8 : *2^3
    ld $a1,N($t0) ;# $a1=N[i]
    jal processa

;# printf msg3 coi 2 parametri
    sd $s1,ind_i($0) ;# 1° arg di msg3
    sd r1,A_i($0) ;# 2° arg di msg3
    daddi  $t0,$0,msg3
    sd $t0,p1s5($0)
    daddi r14,$0,p1s5
    syscall 5

;#exit
syscall 0

;# int processa (str,d) $a0=str $a1 = d = strlen
processa: 
    daddi $sp,$sp,-8
    sd $s0,0($sp)

    ;#for(i=0;i<d;i++) con d=strlen
    daddi $s0,$0,0 ;# i=0
for2: 
    slt $t0,$s0,$a1 ;# $t0=0 quando i=d=strlen
    beq $t0,0,return ;#fine for2, return i

    ;#if(str[i] >= 58) break;
    ;# &str[i] = str+i = $a0+$s0
    dadd $t0,$a0,$s0 ;# $t0=&str[i]
    lbu $t1,0($t0) ;# $t1=str[i]
    slti $t2,$t1,58
    bne $t0,0,incr_i ;# se non soddisfa, i++ 

incr_i:
    daddi: $s0,$s0,1 ;#i++ (1 solo byte, scorro dentro la stringa, non c'è bisogno di *16,*8
    j for2 ;# loop for2
return: 
    move r1,$s0
    ld $s0,0($sp)
    daddi $sp,$sp,8

    jr $ra


