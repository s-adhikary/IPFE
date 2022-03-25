#include "seclevel.h"
.include "arith.inc"

.macro update 	rn, rl0, rl1, rl2, rl3, rh0, rh1, rh2, rh3

vpaddq		%ymm\rh0, %ymm\rl0, %ymm\rn
vpsubq		%ymm\rh0, %ymm0, %ymm\rh0
vpaddq		%ymm\rh0, %ymm\rl0, %ymm\rh0

vpaddq		%ymm\rh1, %ymm\rl1, %ymm\rl0
vpsubq		%ymm\rh1, %ymm0, %ymm\rh1
vpaddq		%ymm\rh1, %ymm\rl1, %ymm\rh1

vpaddq		%ymm\rh2, %ymm\rl2, %ymm\rl1
vpsubq		%ymm\rh2, %ymm0, %ymm\rh2
vpaddq		%ymm\rh2, %ymm\rl2, %ymm\rh2

vpaddq		%ymm\rh3, %ymm\rl3, %ymm\rl2
vpsubq		%ymm\rh3, %ymm0, %ymm\rh3
vpaddq		%ymm\rh3, %ymm\rl3, %ymm\rh3

vpsubq		%ymm0, %ymm\rn, %ymm\rn
vpsrad		$31, %ymm\rn, %ymm\rl3
vpand		%ymm\rl3, %ymm0, %ymm\rl3
vpaddq		%ymm\rl3, %ymm\rn, %ymm\rn

vpsubq		%ymm0, %ymm\rl0, %ymm\rl0
vpsrad		$31, %ymm\rl0, %ymm\rl3
vpand		%ymm\rl3, %ymm0, %ymm\rl3
vpaddq		%ymm\rl3, %ymm\rl0, %ymm\rl0


vpsubq		%ymm0, %ymm\rl1, %ymm\rl1
vpsrad		$31, %ymm\rl1, %ymm\rl3
vpand		%ymm\rl3, %ymm0, %ymm\rl3
vpaddq		%ymm\rl3, %ymm\rl1, %ymm\rl1

vpsubq		%ymm0, %ymm\rl2, %ymm\rl2
vpsrad		$31, %ymm\rl2, %ymm\rl3
vpand		%ymm\rl3, %ymm0, %ymm\rl3
vpaddq		%ymm\rl3, %ymm\rl2, %ymm\rl2

vpsubq		%ymm0, %ymm\rh0, %ymm\rh0
vpsrad		$31, %ymm\rh0, %ymm\rl3
vpand		%ymm\rl3, %ymm0, %ymm\rl3
vpaddq		%ymm\rl3, %ymm\rh0, %ymm\rh0

vpsubq		%ymm0, %ymm\rh1, %ymm\rh1
vpsrad		$31, %ymm\rh1, %ymm\rl3
vpand		%ymm\rl3, %ymm0, %ymm\rl3
vpaddq		%ymm\rl3, %ymm\rh1, %ymm\rh1

vpsubq		%ymm0, %ymm\rh2, %ymm\rh2
vpsrad		$31, %ymm\rh2, %ymm\rl3
vpand		%ymm\rl3, %ymm0, %ymm\rl3
vpaddq		%ymm\rl3, %ymm\rh2, %ymm\rh2

vpsubq		%ymm0, %ymm\rh3, %ymm\rh3
vpsrad		$31, %ymm\rh3, %ymm\rl3
vpand		%ymm\rl3, %ymm0, %ymm\rl3
vpaddq		%ymm\rl3, %ymm\rh3, %ymm\rh3

.endm

#if SEC_LEVEL==1

.macro level0_5 off

vmovdqa		(64*\off)*4(%rdi),%ymm3
vmovdqa		(64*\off+8)*4(%rdi),%ymm4
vmovdqa		(64*\off+16)*4(%rdi),%ymm5
vmovdqa		(64*\off+24)*4(%rdi),%ymm6
vmovdqa		(64*\off+32)*4(%rdi),%ymm7
vmovdqa		(64*\off+40)*4(%rdi),%ymm8
vmovdqa		(64*\off+48)*4(%rdi),%ymm9
vmovdqa		(64*\off+56)*4(%rdi),%ymm10

shuffle1	3, 4, 2, 4
shuffle1	5, 6, 3, 6
shuffle1	7, 8, 5, 8
shuffle1	9,10, 7,10

update		9, 2, 3, 5, 7, 4, 6, 8, 10

vmovdqa		(%rdx), %ymm15
mul 	15, 4
mont 	4
vmovdqa		32(%rdx), %ymm15
mul 	15, 6
mont 	6
vmovdqa		64(%rdx), %ymm15
mul 	15, 8
mont 	8
vmovdqa		96(%rdx), %ymm15
mul 	15, 10
mont 	10

shuffle1	9, 4, 7, 4
shuffle1	2, 6, 9, 6
shuffle1	3, 8, 2, 8
shuffle1	5,10, 3,10

add		$128, %rdx

shuffle2	7, 4, 5, 4 
shuffle2	9, 6, 7, 6
shuffle2	2, 8, 9, 8
shuffle2	3,10, 2,10 

update	3, 5, 7, 9, 2, 4, 6, 8, 10

vmovdqa		(%rdx), %ymm15
mul 	15, 4
mont 	4
vmovdqa		32(%rdx), %ymm15
mul 	15, 6
mont 	6
vmovdqa		64(%rdx), %ymm15
mul 	15, 8
mont 	8
vmovdqa		96(%rdx), %ymm15
mul 	15, 10
mont 	10

shuffle2	3, 4, 2, 4 
shuffle2	5, 6, 3, 6
shuffle2	7, 8, 5, 8
shuffle2	9,10, 7,10 

add 	$128, %rdx

shuffle4	2, 4, 9, 4
shuffle4	3, 6, 2, 6
shuffle4	5, 8, 3, 8
shuffle4	7,10, 5,10

update	7, 9, 2, 3, 5, 4, 6, 8, 10

vmovdqa		(%rdx), %ymm15
mul 	15, 4
mont 	4
vmovdqa		32(%rdx), %ymm15
mul 	15, 6
mont 	6
vmovdqa		64(%rdx), %ymm15
mul 	15, 8
mont 	8
vmovdqa		96(%rdx), %ymm15
mul 	15, 10
mont 	10

shuffle4	7, 4, 5, 4
shuffle4	9, 6, 7, 6
shuffle4	2, 8, 9, 8
shuffle4	3,10, 2,10

add		$128, %rdx

update	3, 5, 7, 9, 2, 4, 6, 8, 10

vpbroadcastd	(%rdx),%ymm15
mul		15, 4
mont 	4

vpbroadcastd	4(%rdx),%ymm15
mul 	15, 6
mont 	6

vpbroadcastd	8(%rdx),%ymm15
mul 	15, 8
mont 	8

vpbroadcastd	12(%rdx),%ymm15
mul 	15, 10
mont 	10

update	2, 3, 4, 7, 8, 5, 6, 9, 10

vpbroadcastd	16(%rdx),%ymm15
mul 	15, 5
mont 	5
mul 	15, 6
mont 	6

vpbroadcastd	20(%rdx),%ymm15
mul 	15, 9
mont 	9
mul 	15, 10
mont 	10

update	8, 2, 3, 5, 6, 4, 7, 9, 10

vpbroadcastd	24(%rdx),%ymm15
mul 	15, 4
mont 	4
mul 	15, 7
mont 	7
mul 	15, 9
mont 	9
mul 	15, 10
mont 	10

add 	$32, %rdx

vmovdqa		%ymm8 , (64*\off)*4(%rdi)
vmovdqa		%ymm2 , (64*\off+8)*4(%rdi)
vmovdqa		%ymm3 , (64*\off+16)*4(%rdi)
vmovdqa		%ymm5 , (64*\off+24)*4(%rdi)
vmovdqa		%ymm4 , (64*\off+32)*4(%rdi)
vmovdqa		%ymm7 , (64*\off+40)*4(%rdi)
vmovdqa		%ymm9 , (64*\off+48)*4(%rdi)
vmovdqa		%ymm10, (64*\off+56)*4(%rdi)

.endm

.macro level6_8 off, i

vmovdqa		(512*\i+8*\off)*4(%rdi),%ymm3
vmovdqa		(512*\i+8*\off+64)*4(%rdi),%ymm4
vmovdqa		(512*\i+8*\off+128)*4(%rdi),%ymm5
vmovdqa		(512*\i+8*\off+192)*4(%rdi),%ymm6
vmovdqa		(512*\i+8*\off+256)*4(%rdi),%ymm7
vmovdqa		(512*\i+8*\off+320)*4(%rdi),%ymm8
vmovdqa		(512*\i+8*\off+384)*4(%rdi),%ymm9
vmovdqa		(512*\i+8*\off+448)*4(%rdi),%ymm10

update	2, 3, 5, 7, 9, 4, 6, 8, 10

vpbroadcastd	(%rdx),%ymm15
mul 	15, 4
mont 	4

vpbroadcastd	4(%rdx),%ymm15
mul 	15, 6
mont 	6

vpbroadcastd	8(%rdx),%ymm15
mul 	15, 8
mont 	8

vpbroadcastd	12(%rdx),%ymm15
mul 	15, 10
mont 	10

update 	9, 2, 4, 5, 8, 3, 6, 7, 10

vpbroadcastd	16(%rdx),%ymm15
mul 	15, 3
mont 	3
mul 	15, 6
mont 	6

vpbroadcastd	20(%rdx),%ymm15
mul 	15, 7
mont 	7
mul 	15, 10
mont 	10

update	8, 9, 2, 3, 6, 4, 5, 7, 10

vpbroadcastd	24(%rdx),%ymm15
mul 	15, 4
mont 	4
mul 	15, 5
mont 	5
mul 	15, 7
mont 	7
mul 	15, 10
mont 	10

vmovdqa		%ymm8, (512*\i+8*\off)*4(%rdi)
vmovdqa		%ymm9, (512*\i+8*\off+64)*4(%rdi)
vmovdqa		%ymm2, (512*\i+8*\off+128)*4(%rdi)
vmovdqa		%ymm3, (512*\i+8*\off+192)*4(%rdi)
vmovdqa		%ymm4, (512*\i+8*\off+256)*4(%rdi)
vmovdqa		%ymm5, (512*\i+8*\off+320)*4(%rdi)
vmovdqa		%ymm7, (512*\i+8*\off+384)*4(%rdi)
vmovdqa		%ymm10,(512*\i+8*\off+448)*4(%rdi)

.endm

.macro level6_8_iter i

level6_8	0, \i
level6_8	1, \i
level6_8	2, \i
level6_8	3, \i
level6_8	4, \i
level6_8	5, \i
level6_8	6, \i
level6_8	7, \i
$add	$28, %rdx

.endm

.macro level9_11 off

vmovdqa		(8*\off)*4(%rdi), %ymm3
vmovdqa		(8*\off+512)*4(%rdi), %ymm4
vmovdqa		(8*\off+1024)*4(%rdi), %ymm5
vmovdqa		(8*\off+1536)*4(%rdi), %ymm6
vmovdqa		(8*\off+2048)*4(%rdi), %ymm7
vmovdqa		(8*\off+2560)*4(%rdi), %ymm8
vmovdqa		(8*\off+3072)*4(%rdi), %ymm9
vmovdqa		(8*\off+3584)*4(%rdi), %ymm10

update	2, 3, 5, 7, 9, 4, 6, 8, 10

vpbroadcastd	(%rdx),%ymm15
mul		15, 4
mont 	4

vpbroadcastd	4(%rdx),%ymm15
mul		15, 6
mont 	6

vpbroadcastd	8(%rdx),%ymm15
mul		15, 8
mont 	8

vpbroadcastd	12(%rdx),%ymm15
mul		15, 10
mont 	10

update 9, 2, 4, 5, 8, 3, 6, 7, 10

vpbroadcastd	16(%rdx),%ymm15
mul		15, 3
mont 	3
mul		15, 6
mont 	6

vpbroadcastd	20(%rdx),%ymm15
mul		15, 7
mont 	7
mul		15, 10
mont 	10

update 8, 9, 2, 3, 6, 4, 5, 7, 10

vpbroadcastd	24(%rdx), %ymm15
mul		15, 4
mont 	4
mul		15, 5
mont 	5
mul		15, 7
mont 	7
mul		15, 10
mont 	10

vmovdqa		%ymm8, (8*\off)*4(%rdi)
vmovdqa		%ymm9, (8*\off+512)*4(%rdi)
vmovdqa		%ymm2, (8*\off+1024)*4(%rdi)
vmovdqa		%ymm3, (8*\off+1536)*4(%rdi)
vmovdqa		%ymm4, (8*\off+2048)*4(%rdi)
vmovdqa		%ymm5, (8*\off+2560)*4(%rdi)
vmovdqa		%ymm7, (8*\off+3072)*4(%rdi)
vmovdqa		%ymm10,(8*\off+3584)*4(%rdi)

.endm

.macro LEVEL_6_8 i

level6_8	0, \i
level6_8	1, \i
level6_8	2, \i
level6_8	3, \i
level6_8	4, \i
level6_8	5, \i
level6_8	6, \i
level6_8	7, \i
add		$28, %rdx

.endm

.macro ninv_mul64 off

vmovdqa		(64*\off)*4(%rdi), %ymm3
vmovdqa		(64*\off+8)*4(%rdi), %ymm4
vmovdqa		(64*\off+16)*4(%rdi), %ymm5
vmovdqa		(64*\off+24)*4(%rdi), %ymm6
vmovdqa		(64*\off+32)*4(%rdi), %ymm7
vmovdqa		(64*\off+40)*4(%rdi), %ymm8
vmovdqa		(64*\off+48)*4(%rdi), %ymm9
vmovdqa		(64*\off+56)*4(%rdi), %ymm10

mul		15, 3
mont 	3
mul		15, 4
mont 	4
mul		15, 5
mont 	5
mul		15, 6
mont 	6
mul		15, 7
mont 	7
mul		15, 8
mont 	8
mul		15, 9
mont 	9
mul		15, 10
mont 	10

vmovdqa		%ymm3, (64*\off)*4(%rdi)
vmovdqa		%ymm4, (64*\off+8)*4(%rdi)
vmovdqa		%ymm5, (64*\off+16)*4(%rdi)
vmovdqa		%ymm6, (64*\off+24)*4(%rdi)
vmovdqa		%ymm7, (64*\off+32)*4(%rdi)
vmovdqa		%ymm8, (64*\off+40)*4(%rdi)
vmovdqa		%ymm9, (64*\off+48)*4(%rdi)
vmovdqa		%ymm10,(64*\off+56)*4(%rdi)

.endm

.text
.global GS_reverse
GS_reverse:

vpbroadcastd	(%rsi),%ymm0
vpbroadcastd	4(%rsi),%ymm1


level0_5	0
level0_5	1
level0_5	2
level0_5	3
level0_5	4
level0_5	5
level0_5	6
level0_5	7
level0_5	8
level0_5	9
level0_5	10
level0_5	11
level0_5	12
level0_5	13
level0_5	14
level0_5	15
level0_5	16
level0_5	17
level0_5	18
level0_5	19
level0_5	20
level0_5	21
level0_5	22
level0_5	23
level0_5	24
level0_5	25
level0_5	26
level0_5	27
level0_5	28
level0_5	29
level0_5	30
level0_5	31
level0_5	32
level0_5	33
level0_5	34
level0_5	35
level0_5	36
level0_5	37
level0_5	38
level0_5	39
level0_5	40
level0_5	41
level0_5	42
level0_5	43
level0_5	44
level0_5	45
level0_5	46
level0_5	47
level0_5	48
level0_5	49
level0_5	50
level0_5	51
level0_5	52
level0_5	53
level0_5	54
level0_5	55
level0_5	56
level0_5	57
level0_5	58
level0_5	59
level0_5	60
level0_5	61
level0_5	62
level0_5	63

LEVEL_6_8	0
LEVEL_6_8	1
LEVEL_6_8	2
LEVEL_6_8	3
LEVEL_6_8	4
LEVEL_6_8	5
LEVEL_6_8	6
LEVEL_6_8	7

level9_11	0
level9_11	1
level9_11	2
level9_11	3
level9_11	4
level9_11	5
level9_11	6
level9_11	7
level9_11	8
level9_11	9
level9_11	10
level9_11	11
level9_11	12
level9_11	13
level9_11	14
level9_11	15
level9_11	16
level9_11	17
level9_11	18
level9_11	19
level9_11	20
level9_11	21
level9_11	22
level9_11	23
level9_11	24
level9_11	25
level9_11	26
level9_11	27
level9_11	28
level9_11	29
level9_11	30
level9_11	31
level9_11	32
level9_11	33
level9_11	34
level9_11	35
level9_11	36
level9_11	37
level9_11	38
level9_11	39
level9_11	40
level9_11	41
level9_11	42
level9_11	43
level9_11	44
level9_11	45
level9_11	46
level9_11	47
level9_11	48
level9_11	49
level9_11	50
level9_11	51
level9_11	52
level9_11	53
level9_11	54
level9_11	55
level9_11	56
level9_11	57
level9_11	58
level9_11	59
level9_11	60
level9_11	61
level9_11	62
level9_11	63

vpbroadcastd	8(%rsi),%ymm15

ninv_mul64	0
ninv_mul64	1
ninv_mul64	2
ninv_mul64	3
ninv_mul64	4
ninv_mul64	5
ninv_mul64	6
ninv_mul64	7
ninv_mul64	8
ninv_mul64	9
ninv_mul64	10
ninv_mul64	11
ninv_mul64	12
ninv_mul64	13
ninv_mul64	14
ninv_mul64	15
ninv_mul64	16
ninv_mul64	17
ninv_mul64	18
ninv_mul64	19
ninv_mul64	20
ninv_mul64	21
ninv_mul64	22
ninv_mul64	23
ninv_mul64	24
ninv_mul64	25
ninv_mul64	26
ninv_mul64	27
ninv_mul64	28
ninv_mul64	29
ninv_mul64	30
ninv_mul64	31
ninv_mul64	32
ninv_mul64	33
ninv_mul64	34
ninv_mul64	35
ninv_mul64	36
ninv_mul64	37
ninv_mul64	38
ninv_mul64	39
ninv_mul64	40
ninv_mul64	41
ninv_mul64	42
ninv_mul64	43
ninv_mul64	44
ninv_mul64	45
ninv_mul64	46
ninv_mul64	47
ninv_mul64	48
ninv_mul64	49
ninv_mul64	50
ninv_mul64	51
ninv_mul64	52
ninv_mul64	53
ninv_mul64	54
ninv_mul64	55
ninv_mul64	56
ninv_mul64	57
ninv_mul64	58
ninv_mul64	59
ninv_mul64	60
ninv_mul64	61
ninv_mul64	62
ninv_mul64	63

ret


#elif SEC_LEVEL==2

.macro level0_5 off, i

vmovdqa		(1024*\i+64*\off)*4(%rdi),%ymm3
vmovdqa		(1024*\i+64*\off+8)*4(%rdi),%ymm4
vmovdqa		(1024*\i+64*\off+16)*4(%rdi),%ymm5
vmovdqa		(1024*\i+64*\off+24)*4(%rdi),%ymm6
vmovdqa		(1024*\i+64*\off+32)*4(%rdi),%ymm7
vmovdqa		(1024*\i+64*\off+40)*4(%rdi),%ymm8
vmovdqa		(1024*\i+64*\off+48)*4(%rdi),%ymm9
vmovdqa		(1024*\i+64*\off+56)*4(%rdi),%ymm10

shuffle1	3, 4, 2, 4
shuffle1	5, 6, 3, 6
shuffle1	7, 8, 5, 8
shuffle1	9,10, 7,10

update		9, 2, 3, 5, 7, 4, 6, 8, 10

vmovdqa		(%rdx), %ymm15
mul 	15, 4
mont 	4
vmovdqa		32(%rdx), %ymm15
mul 	15, 6
mont 	6
vmovdqa		64(%rdx), %ymm15
mul 	15, 8
mont 	8
vmovdqa		96(%rdx), %ymm15
mul 	15, 10
mont 	10

shuffle1	9, 4, 7, 4
shuffle1	2, 6, 9, 6
shuffle1	3, 8, 2, 8
shuffle1	5,10, 3,10

add		$128, %rdx

shuffle2	7, 4, 5, 4 
shuffle2	9, 6, 7, 6
shuffle2	2, 8, 9, 8
shuffle2	3,10, 2,10 

update	3, 5, 7, 9, 2, 4, 6, 8, 10

vmovdqa		(%rdx), %ymm15
mul 	15, 4
mont 	4
vmovdqa		32(%rdx), %ymm15
mul 	15, 6
mont 	6
vmovdqa		64(%rdx), %ymm15
mul 	15, 8
mont 	8
vmovdqa		96(%rdx), %ymm15
mul 	15, 10
mont 	10

shuffle2	3, 4, 2, 4 
shuffle2	5, 6, 3, 6
shuffle2	7, 8, 5, 8
shuffle2	9,10, 7,10 

add 	$128, %rdx

shuffle4	2, 4, 9, 4
shuffle4	3, 6, 2, 6
shuffle4	5, 8, 3, 8
shuffle4	7,10, 5,10

update	7, 9, 2, 3, 5, 4, 6, 8, 10

vmovdqa		(%rdx), %ymm15
mul 	15, 4
mont 	4
vmovdqa		32(%rdx), %ymm15
mul 	15, 6
mont 	6
vmovdqa		64(%rdx), %ymm15
mul 	15, 8
mont 	8
vmovdqa		96(%rdx), %ymm15
mul 	15, 10
mont 	10

shuffle4	7, 4, 5, 4
shuffle4	9, 6, 7, 6
shuffle4	2, 8, 9, 8
shuffle4	3,10, 2,10

add		$128, %rdx

update	3, 5, 7, 9, 2, 4, 6, 8, 10

vpbroadcastd	(%rdx),%ymm15
mul		15, 4
mont 	4

vpbroadcastd	4(%rdx),%ymm15
mul 	15, 6
mont 	6

vpbroadcastd	8(%rdx),%ymm15
mul 	15, 8
mont 	8

vpbroadcastd	12(%rdx),%ymm15
mul 	15, 10
mont 	10

update	2, 3, 4, 7, 8, 5, 6, 9, 10

vpbroadcastd	16(%rdx),%ymm15
mul 	15, 5
mont 	5
mul 	15, 6
mont 	6

vpbroadcastd	20(%rdx),%ymm15
mul 	15, 9
mont 	9
mul 	15, 10
mont 	10 

update	8, 2, 3, 5, 6, 4, 7, 9, 10

vpbroadcastd	24(%rdx),%ymm15
mul 	15, 4
mont 	4
mul 	15, 7
mont 	7
mul 	15, 9
mont 	9
mul 	15, 10
mont 	10

add 	$32, %rdx

vmovdqa		%ymm8 , (1024*\i+64*\off)*4(%rdi)
vmovdqa		%ymm2 , (1024*\i+64*\off+8)*4(%rdi)
vmovdqa		%ymm3 , (1024*\i+64*\off+16)*4(%rdi)
vmovdqa		%ymm5 , (1024*\i+64*\off+24)*4(%rdi)
vmovdqa		%ymm4 , (1024*\i+64*\off+32)*4(%rdi)
vmovdqa		%ymm7 , (1024*\i+64*\off+40)*4(%rdi)
vmovdqa		%ymm9 , (1024*\i+64*\off+48)*4(%rdi)
vmovdqa		%ymm10, (1024*\i+64*\off+56)*4(%rdi)

.endm

.macro	level0_5_block1024	i
level0_5	0, \i
level0_5	1, \i
level0_5	2, \i
level0_5	3, \i
level0_5	4, \i
level0_5	5, \i
level0_5	6, \i
level0_5	7, \i
level0_5	8, \i
level0_5	9, \i
level0_5	10, \i
level0_5	11, \i
level0_5	12, \i
level0_5	13, \i
level0_5	14, \i
level0_5	15, \i
.endm

.macro level6_8 off, i

vmovdqa		(512*\i+8*\off)*4(%rdi),%ymm3
vmovdqa		(512*\i+8*\off+64)*4(%rdi),%ymm4
vmovdqa		(512*\i+8*\off+128)*4(%rdi),%ymm5
vmovdqa		(512*\i+8*\off+192)*4(%rdi),%ymm6
vmovdqa		(512*\i+8*\off+256)*4(%rdi),%ymm7
vmovdqa		(512*\i+8*\off+320)*4(%rdi),%ymm8
vmovdqa		(512*\i+8*\off+384)*4(%rdi),%ymm9
vmovdqa		(512*\i+8*\off+448)*4(%rdi),%ymm10

update	2, 3, 5, 7, 9, 4, 6, 8, 10

vpbroadcastd	(%rdx),%ymm15
mul 	15, 4
mont 	4

vpbroadcastd	4(%rdx),%ymm15
mul 	15, 6
mont 	6

vpbroadcastd	8(%rdx),%ymm15
mul 	15, 8
mont 	8

vpbroadcastd	12(%rdx),%ymm15
mul 	15, 10
mont 	10

update 	9, 2, 4, 5, 8, 3, 6, 7, 10

vpbroadcastd	16(%rdx),%ymm15
mul 	15, 3
mont 	3
mul 	15, 6
mont 	6

vpbroadcastd	20(%rdx),%ymm15
mul 	15, 7
mont 	7
mul 	15, 10
mont 	10

update	8, 9, 2, 3, 6, 4, 5, 7, 10

vpbroadcastd	24(%rdx),%ymm15
mul 	15, 4
mont 	4
mul 	15, 5
mont 	5
mul 	15, 7
mont 	7
mul 	15, 10
mont 	10

vmovdqa		%ymm8, (512*\i+8*\off)*4(%rdi)
vmovdqa		%ymm9, (512*\i+8*\off+64)*4(%rdi)
vmovdqa		%ymm2, (512*\i+8*\off+128)*4(%rdi)
vmovdqa		%ymm3, (512*\i+8*\off+192)*4(%rdi)
vmovdqa		%ymm4, (512*\i+8*\off+256)*4(%rdi)
vmovdqa		%ymm5, (512*\i+8*\off+320)*4(%rdi)
vmovdqa		%ymm7, (512*\i+8*\off+384)*4(%rdi)
vmovdqa		%ymm10,(512*\i+8*\off+448)*4(%rdi)

.endm

.macro level6_8_iter i

level6_8	0, \i
level6_8	1, \i
level6_8	2, \i
level6_8	3, \i
level6_8	4, \i
level6_8	5, \i
level6_8	6, \i
level6_8	7, \i
add		$28, %rdx

.endm

.macro level9_11 off, i

vmovdqa		(4096*\i+8*\off)*4(%rdi), %ymm3
vmovdqa		(4096*\i+8*\off+512)*4(%rdi), %ymm4
vmovdqa		(4096*\i+8*\off+1024)*4(%rdi), %ymm5
vmovdqa		(4096*\i+8*\off+1536)*4(%rdi), %ymm6
vmovdqa		(4096*\i+8*\off+2048)*4(%rdi), %ymm7
vmovdqa		(4096*\i+8*\off+2560)*4(%rdi), %ymm8
vmovdqa		(4096*\i+8*\off+3072)*4(%rdi), %ymm9
vmovdqa		(4096*\i+8*\off+3584)*4(%rdi), %ymm10

update	2, 3, 5, 7, 9, 4, 6, 8, 10

vpbroadcastd	(%rdx),%ymm15
mul		15, 4
mont 	4

vpbroadcastd	4(%rdx),%ymm15
mul		15, 6
mont 	6

vpbroadcastd	8(%rdx),%ymm15
mul		15, 8
mont 	8

vpbroadcastd	12(%rdx),%ymm15
mul		15, 10
mont 	10

update 9, 2, 4, 5, 8, 3, 6, 7, 10

vpbroadcastd	16(%rdx),%ymm15
mul		15, 3
mont 	3
mul		15, 6
mont 	6

vpbroadcastd	20(%rdx),%ymm15
mul		15, 7
mont 	7
mul		15, 10
mont 	10

update 8, 9, 2, 3, 6, 4, 5, 7, 10

vpbroadcastd	24(%rdx), %ymm15
mul		15, 4
mont 	4
mul		15, 5
mont 	5
mul		15, 7
mont 	7
mul		15, 10
mont 	10

vmovdqa		%ymm8, (4096*\i+8*\off)*4(%rdi)
vmovdqa		%ymm9, (4096*\i+8*\off+512)*4(%rdi)
vmovdqa		%ymm2, (4096*\i+8*\off+1024)*4(%rdi)
vmovdqa		%ymm3, (4096*\i+8*\off+1536)*4(%rdi)
vmovdqa		%ymm4, (4096*\i+8*\off+2048)*4(%rdi)
vmovdqa		%ymm5, (4096*\i+8*\off+2560)*4(%rdi)
vmovdqa		%ymm7, (4096*\i+8*\off+3072)*4(%rdi)
vmovdqa		%ymm10,(4096*\i+8*\off+3584)*4(%rdi)

.endm

.macro level9_11_iter i

level9_11	0, \i
level9_11	1, \i
level9_11	2, \i
level9_11	3, \i
level9_11	4, \i
level9_11	5, \i
level9_11	6, \i
level9_11	7, \i
level9_11	8, \i
level9_11	9, \i
level9_11	10, \i
level9_11	11, \i
level9_11	12, \i
level9_11	13, \i
level9_11	14, \i
level9_11	15, \i
level9_11	16, \i
level9_11	17, \i
level9_11	18, \i
level9_11	19, \i
level9_11	20, \i
level9_11	21, \i
level9_11	22, \i
level9_11	23, \i
level9_11	24, \i
level9_11	25, \i
level9_11	26, \i
level9_11	27, \i
level9_11	28, \i
level9_11	29, \i
level9_11	30, \i
level9_11	31, \i
level9_11	32, \i
level9_11	33, \i
level9_11	34, \i
level9_11	35, \i
level9_11	36, \i
level9_11	37, \i
level9_11	38, \i
level9_11	39, \i
level9_11	40, \i
level9_11	41, \i
level9_11	42, \i
level9_11	43, \i
level9_11	44, \i
level9_11	45, \i
level9_11	46, \i
level9_11	47, \i
level9_11	48, \i
level9_11	49, \i
level9_11	50, \i
level9_11	51, \i
level9_11	52, \i
level9_11	53, \i
level9_11	54, \i
level9_11	55, \i
level9_11	56, \i
level9_11	57, \i
level9_11	58, \i
level9_11	59, \i
level9_11	60, \i
level9_11	61, \i
level9_11	62, \i
level9_11	63, \i
add		$28, %rdx
.endm

.macro	level12 off, i

vmovdqa		(1024*\i+32*\off)*4(%rdi), %ymm3
vmovdqa		(1024*\i+32*\off+8)*4(%rdi), %ymm4
vmovdqa		(1024*\i+32*\off+16)*4(%rdi), %ymm5
vmovdqa		(1024*\i+32*\off+24)*4(%rdi), %ymm6
vmovdqa		(1024*\i+32*\off+4096)*4(%rdi), %ymm7
vmovdqa		(1024*\i+32*\off+4104)*4(%rdi), %ymm8
vmovdqa		(1024*\i+32*\off+4112)*4(%rdi), %ymm9
vmovdqa		(1024*\i+32*\off+4120)*4(%rdi), %ymm10

update	2, 3, 4, 5, 6, 7, 8, 9, 10

mul		15, 7
mont 	7
mul		15, 8
mont 	8
mul		15, 9
mont 	9
mul		15, 10
mont 	10

vmovdqa		%ymm2, (1024*\i+32*\off)*4(%rdi)
vmovdqa		%ymm3, (1024*\i+32*\off+8)*4(%rdi)
vmovdqa		%ymm4, (1024*\i+32*\off+16)*4(%rdi)
vmovdqa		%ymm5, (1024*\i+32*\off+24)*4(%rdi)
vmovdqa		%ymm7, (1024*\i+32*\off+4096)*4(%rdi)
vmovdqa		%ymm8, (1024*\i+32*\off+4104)*4(%rdi)
vmovdqa		%ymm9, (1024*\i+32*\off+4112)*4(%rdi)
vmovdqa		%ymm10,(1024*\i+32*\off+4120)*4(%rdi)

.endm

.macro level12_block1024 	i

level12		0, \i
level12		1, \i
level12		2, \i
level12		3, \i
level12		4, \i
level12		5, \i
level12		6, \i
level12		7, \i
level12		8, \i
level12		9, \i
level12		10, \i
level12		11, \i
level12		12, \i
level12		13, \i
level12		14, \i
level12		15, \i
level12		16, \i
level12		17, \i
level12		18, \i
level12		19, \i
level12		20, \i
level12		21, \i
level12		22, \i
level12		23, \i
level12		24, \i
level12		25, \i
level12		26, \i
level12		27, \i
level12		28, \i
level12		29, \i
level12		30, \i
level12		31, \i

.endm

.macro ninv_mul64 off, i

vmovdqa		(1024*\i+64*\off)*4(%rdi), %ymm3
vmovdqa		(1024*\i+64*\off+8)*4(%rdi), %ymm4
vmovdqa		(1024*\i+64*\off+16)*4(%rdi), %ymm5
vmovdqa		(1024*\i+64*\off+24)*4(%rdi), %ymm6
vmovdqa		(1024*\i+64*\off+32)*4(%rdi), %ymm7
vmovdqa		(1024*\i+64*\off+40)*4(%rdi), %ymm8
vmovdqa		(1024*\i+64*\off+48)*4(%rdi), %ymm9
vmovdqa		(1024*\i+64*\off+56)*4(%rdi), %ymm10

mul		15, 3
mont 	3
mul		15, 4
mont 	4
mul		15, 5
mont 	5
mul		15, 6
mont 	6
mul		15, 7
mont 	7
mul		15, 8
mont 	8
mul		15, 9
mont 	9
mul		15, 10
mont 	10

vmovdqa		%ymm3, (1024*\i+64*\off)*4(%rdi)
vmovdqa		%ymm4, (1024*\i+64*\off+8)*4(%rdi)
vmovdqa		%ymm5, (1024*\i+64*\off+16)*4(%rdi)
vmovdqa		%ymm6, (1024*\i+64*\off+24)*4(%rdi)
vmovdqa		%ymm7, (1024*\i+64*\off+32)*4(%rdi)
vmovdqa		%ymm8, (1024*\i+64*\off+40)*4(%rdi)
vmovdqa		%ymm9, (1024*\i+64*\off+48)*4(%rdi)
vmovdqa		%ymm10,(1024*\i+64*\off+56)*4(%rdi)

.endm

.macro ninv_mul1024 i

ninv_mul64	0, \i
ninv_mul64	1, \i
ninv_mul64	2, \i
ninv_mul64	3, \i
ninv_mul64	4, \i
ninv_mul64	5, \i
ninv_mul64	6, \i
ninv_mul64	7, \i
ninv_mul64	8, \i
ninv_mul64	9, \i
ninv_mul64	10, \i
ninv_mul64	11, \i
ninv_mul64	12, \i
ninv_mul64	13, \i
ninv_mul64	14, \i
ninv_mul64	15, \i

.endm

.text
.global GS_reverse
GS_reverse:

vpbroadcastd	(%rsi),%ymm0
vpbroadcastd	4(%rsi),%ymm1

level0_5_block1024	0
level0_5_block1024	1
level0_5_block1024	2
level0_5_block1024	3
level0_5_block1024	4
level0_5_block1024	5
level0_5_block1024	6
level0_5_block1024	7

level6_8_iter		0
level6_8_iter		1
level6_8_iter		2
level6_8_iter		3
level6_8_iter		4
level6_8_iter		5
level6_8_iter		6
level6_8_iter		7
level6_8_iter		8
level6_8_iter		9
level6_8_iter		10
level6_8_iter		11
level6_8_iter		12
level6_8_iter		13
level6_8_iter		14
level6_8_iter		15

level9_11_iter		0
level9_11_iter		1

vpbroadcastd	(%rdx), %ymm15

level12_block1024	0
level12_block1024	1
level12_block1024	2
level12_block1024	3


vpbroadcastd	8(%rsi),%ymm15

ninv_mul1024 		0
ninv_mul1024 		1
ninv_mul1024 		2
ninv_mul1024 		3
ninv_mul1024 		4
ninv_mul1024 		5
ninv_mul1024 		6
ninv_mul1024 		7

ret

#endif
