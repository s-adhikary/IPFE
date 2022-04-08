#include "seclevel.h"
.include "arith.inc"

/*
	The following updates the coefficients of the array
	as follows 
		U = a[i]
		V = a[i + t] * (psi)
		a[i] = (U + V)
		a[i + t] = (U - V)
	This is the update rule for Cooly-Tukey's NTT. 
	The twiddle factor (psi) is multiplied with a[i+t]
	before update is done.
*/

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

#if SEC_LEVEL==0

.macro level0_2 off

#level 0
vmovdqa		(8*\off+1024)*4(%rdi),%ymm7
vmovdqa		(8*\off+1280)*4(%rdi),%ymm8
vmovdqa		(8*\off+1536)*4(%rdi),%ymm9
vmovdqa		(8*\off+1792)*4(%rdi),%ymm10

vpbroadcastd	(%rdx),%ymm15

mul 		15, 7
mont 		7
mul 		15, 8
mont 		8
mul 		15, 9
mont 		9
mul 		15, 10
mont 		10

vmovdqa		(8*\off+0)*4(%rdi),%ymm3
vmovdqa		(8*\off+256)*4(%rdi),%ymm4
vmovdqa		(8*\off+512)*4(%rdi),%ymm5
vmovdqa		(8*\off+768)*4(%rdi),%ymm6

update 	2, 3, 4, 5, 6, 7, 8, 9, 10

vpbroadcastd	4(%rdx),%ymm15

mul			15, 4
mont 		4
mul			15, 5
mont 		5

vpbroadcastd	8(%rdx),%ymm15

mul			15, 9
mont 		9
mul			15, 10
mont 		10

update 	6, 2, 3, 7, 8, 4, 5, 9, 10

vpbroadcastd	12(%rdx),%ymm15
mul			15, 2
mont 		2

vpbroadcastd	16(%rdx),%ymm15
mul			15, 5
mont 		5

vpbroadcastd	20(%rdx),%ymm15
mul			15, 7
mont 		7

vpbroadcastd	24(%rdx),%ymm15
mul			15, 10
mont 		10

update	8, 6, 4, 3, 9, 2, 5, 7, 10

vmovdqa		%ymm8, (8*\off+0)*4(%rdi)
vmovdqa		%ymm2, (8*\off+256)*4(%rdi)
vmovdqa		%ymm6, (8*\off+512)*4(%rdi)
vmovdqa		%ymm5, (8*\off+768)*4(%rdi)
vmovdqa		%ymm4, (8*\off+1024+0)*4(%rdi)
vmovdqa		%ymm7, (8*\off+1024+256)*4(%rdi)
vmovdqa		%ymm3, (8*\off+1024+512)*4(%rdi)
vmovdqa		%ymm10,(8*\off+1024+768)*4(%rdi)

.endm
.macro level3_4 off, i

vmovdqa		(16*\off+256*\i+128)*4(%rdi), %ymm7
vmovdqa		(16*\off+256*\i+136)*4(%rdi), %ymm8
vmovdqa		(16*\off+256*\i+192)*4(%rdi), %ymm9
vmovdqa		(16*\off+256*\i+200)*4(%rdi), %ymm10

vpbroadcastd	(%rdx),%ymm15
mul 		15, 7
mont 		7
mul 		15, 8
mont 		8
mul 		15, 9
mont 		9
mul 		15, 10
mont 		10

vmovdqa		(16*\off+256*\i)*4(%rdi), %ymm3
vmovdqa		(16*\off+256*\i+8)*4(%rdi), %ymm4
vmovdqa		(16*\off+256*\i+64)*4(%rdi), %ymm5
vmovdqa		(16*\off+256*\i+72)*4(%rdi), %ymm6

update 2, 3, 4, 5, 6, 7, 8, 9, 10

vpbroadcastd	4(%rdx),%ymm15
mul 		15, 4
mont 		4
mul 		15, 5
mont 		5

vpbroadcastd	8(%rdx),%ymm15
mul 		15, 9
mont 		9
mul 		15, 10
mont 		10

update	6, 2, 3, 7, 8, 4, 5, 9, 10

vmovdqa		%ymm6, (16*\off+256*\i)*4(%rdi)
vmovdqa		%ymm2, (16*\off+256*\i+8)*4(%rdi)
vmovdqa		%ymm4, (16*\off+256*\i+64)*4(%rdi)
vmovdqa		%ymm5, (16*\off+256*\i+72)*4(%rdi)
vmovdqa		%ymm3, (16*\off+256*\i+128)*4(%rdi)
vmovdqa		%ymm7, (16*\off+256*\i+136)*4(%rdi)
vmovdqa		%ymm9, (16*\off+256*\i+192)*4(%rdi)
vmovdqa		%ymm10,(16*\off+256*\i+200)*4(%rdi)

.endm


.macro LEVEL_0_2
level0_2		0
level0_2		1
level0_2		2
level0_2		3
level0_2		4
level0_2		5
level0_2		6
level0_2		7
level0_2		8
level0_2		9
level0_2		10
level0_2		11
level0_2		12
level0_2		13
level0_2		14
level0_2		15
level0_2		16
level0_2		17
level0_2		18
level0_2		19
level0_2		20
level0_2		21
level0_2		22
level0_2		23
level0_2		24
level0_2		25
level0_2		26
level0_2		27
level0_2		28
level0_2		29
level0_2		30
level0_2		31

add		$28, %rdx
.endm


.macro LEVEL_3_4	i
level3_4	0, \i
level3_4	1, \i
level3_4	2, \i
level3_4	3, \i
add		$12, %rdx
.endm 

.macro LEVEL_5_10 i
vpbroadcastd	(%rdx),%ymm15

vmovdqa		128(%rdi),%ymm7
vmovdqa		160(%rdi),%ymm8
vmovdqa		192(%rdi),%ymm9
vmovdqa		224(%rdi),%ymm10

mul 		15, 7
mont 		7
mul 		15, 8
mont 		8
mul 		15, 9
mont 		9
mul 		15, 10
mont 		10

vmovdqa		(%rdi),%ymm3
vmovdqa		32(%rdi),%ymm4
vmovdqa		64(%rdi),%ymm5
vmovdqa		96(%rdi),%ymm6

update 	2, 3, 4, 5, 6, 7, 8, 9, 10

vpbroadcastd	4(%rdx),%ymm15

mul 15, 4
mont 4
mul 15, 5
mont 5

vpbroadcastd	8(%rdx),%ymm15

mul 15, 9
mont 9
mul 15, 10
mont 10

update	6, 2, 3, 7, 8, 4, 5, 9, 10

vpbroadcastd	12(%rdx),%ymm15

mul	15, 2
mont 2

vpbroadcastd	16(%rdx),%ymm15

mul 15, 5
mont 5

vpbroadcastd	20(%rdx),%ymm15

mul 15, 7
mont 7

vpbroadcastd	24(%rdx),%ymm15

mul 15, 10
mont 10

add			$32, %rdx
update	8, 6, 4, 3, 9, 2, 5, 7, 10

shuffle4	8, 2, 9, 2
shuffle4	6, 5, 8, 5
shuffle4	4, 7, 6, 7
shuffle4	3,10, 4,10

vmovdqa		(%rdx), %ymm15
mul	15, 2
mont 2

vmovdqa		32(%rdx), %ymm15
mul	15, 5
mont 5

vmovdqa		64(%rdx), %ymm15
mul	15, 7
mont 7

vmovdqa		96(%rdx), %ymm15
mul	15, 10
mont 10

update	3, 9, 8, 6, 4, 2, 5, 7, 10

shuffle4	3, 2, 4, 2
shuffle4	9, 5, 3, 5
shuffle4	8, 7, 9, 7
shuffle4	6,10, 8,10

add		$128, %rdx

shuffle2	4, 2, 6, 2
shuffle2	3, 5, 4, 5
shuffle2	9, 7, 3, 7
shuffle2	8,10, 9,10

vmovdqa		(%rdx), %ymm15
mul	15, 2
mont 2

vmovdqa		32(%rdx), %ymm15
mul	15, 5
mont 5

vmovdqa		64(%rdx), %ymm15
mul	15, 7
mont 7

vmovdqa		96(%rdx), %ymm15
mul	15, 10
mont 10

update	8, 6, 4, 3, 9, 2, 5, 7, 10

shuffle2	8, 2, 9, 2
shuffle2	6, 5, 8, 5
shuffle2	4, 7, 6, 7
shuffle2	3,10, 4,10

add		$128, %rdx

shuffle1	9, 2, 3, 2
shuffle1	8, 5, 9, 5
shuffle1	6, 7, 8, 7
shuffle1	4,10, 6,10

vmovdqa		(%rdx), %ymm15
mul	15, 2
mont 2

vmovdqa		32(%rdx), %ymm15
mul	15, 5
mont 5

vmovdqa		64(%rdx), %ymm15
mul	15, 7
mont 7

vmovdqa		96(%rdx), %ymm15
mul	15, 10
mont 10

update	4, 3, 9, 8, 6, 2, 5, 7, 10

shuffle1	4, 2, 6, 2
shuffle1	3, 5, 4, 5
shuffle1	9, 7, 3, 7
shuffle1	8,10, 9,10

add		$128, %rdx

vmovdqa		%ymm6, (%rdi)
vmovdqa		%ymm2, 32(%rdi)
vmovdqa		%ymm4, 64(%rdi)
vmovdqa		%ymm5, 96(%rdi)
vmovdqa		%ymm3, 128(%rdi)
vmovdqa		%ymm7, 160(%rdi)
vmovdqa		%ymm9, 192(%rdi)
vmovdqa		%ymm10,224(%rdi)
  
add		$256, %rdi
.endm

/*
	The following function is the Cooley-Tukey's 
	forward NTT operation for polynomials of size 
	n = 2048
*/

.text
.global CT_forward
CT_forward:

vpbroadcastd	(%rsi),%ymm0
vpbroadcastd	4(%rsi),%ymm1

add			$4, %rdx

LEVEL_0_2

LEVEL_3_4	0
LEVEL_3_4	1
LEVEL_3_4	2
LEVEL_3_4	3
LEVEL_3_4	4
LEVEL_3_4	5
LEVEL_3_4	6
LEVEL_3_4	7

LEVEL_5_10	 0
LEVEL_5_10	 1
LEVEL_5_10	 2
LEVEL_5_10	 3
LEVEL_5_10	 4
LEVEL_5_10	 5
LEVEL_5_10	 6
LEVEL_5_10	 7
LEVEL_5_10	 8
LEVEL_5_10	 9
LEVEL_5_10	10
LEVEL_5_10	11
LEVEL_5_10	12
LEVEL_5_10	13
LEVEL_5_10	14
LEVEL_5_10	15
LEVEL_5_10	16
LEVEL_5_10	17
LEVEL_5_10	18
LEVEL_5_10	19
LEVEL_5_10	20
LEVEL_5_10	21
LEVEL_5_10	22
LEVEL_5_10	23
LEVEL_5_10	24
LEVEL_5_10	25
LEVEL_5_10	26
LEVEL_5_10	27
LEVEL_5_10	28
LEVEL_5_10	29
LEVEL_5_10	30
LEVEL_5_10	31

ret

#elif SEC_LEVEL==1

.macro level0_2 off

#level 0
vmovdqa		(8*\off+2048)*4(%rdi),%ymm7
vmovdqa		(8*\off+2560)*4(%rdi),%ymm8
vmovdqa		(8*\off+3072)*4(%rdi),%ymm9
vmovdqa		(8*\off+3584)*4(%rdi),%ymm10

vpbroadcastd	(%rdx),%ymm15

mul 		15, 7
mont 		7
mul 		15, 8
mont 		8
mul 		15, 9
mont 		9
mul 		15, 10
mont 		10

vmovdqa		(8*\off+0)*4(%rdi),%ymm3
vmovdqa		(8*\off+512)*4(%rdi),%ymm4
vmovdqa		(8*\off+1024)*4(%rdi),%ymm5
vmovdqa		(8*\off+1536)*4(%rdi),%ymm6

update 	2, 3, 4, 5, 6, 7, 8, 9, 10

vpbroadcastd	4(%rdx),%ymm15

mul			15, 4
mont 		4
mul			15, 5
mont 		5

vpbroadcastd	8(%rdx),%ymm15

mul			15, 9
mont 		9
mul			15, 10
mont 		10

update 	6, 2, 3, 7, 8, 4, 5, 9, 10

vpbroadcastd	12(%rdx),%ymm15
mul			15, 2
mont 		2

vpbroadcastd	16(%rdx),%ymm15
mul			15, 5
mont 		5

vpbroadcastd	20(%rdx),%ymm15
mul			15, 7
mont 		7

vpbroadcastd	24(%rdx),%ymm15
mul			15, 10
mont 		10

update	8, 6, 4, 3, 9, 2, 5, 7, 10

vmovdqa		%ymm8, (8*\off)*4(%rdi)
vmovdqa		%ymm2, (8*\off+512)*4(%rdi)
vmovdqa		%ymm6, (8*\off+1024)*4(%rdi)
vmovdqa		%ymm5, (8*\off+1536)*4(%rdi)
vmovdqa		%ymm4, (8*\off+2048)*4(%rdi)
vmovdqa		%ymm7, (8*\off+2560)*4(%rdi)
vmovdqa		%ymm3, (8*\off+3072)*4(%rdi)
vmovdqa		%ymm10,(8*\off+3584)*4(%rdi)

.endm

.macro level3_5 off, i

vmovdqa		(512*\i+8*\off+256)*4(%rdi), %ymm7
vmovdqa		(512*\i+8*\off+320)*4(%rdi), %ymm8
vmovdqa		(512*\i+8*\off+384)*4(%rdi), %ymm9
vmovdqa		(512*\i+8*\off+448)*4(%rdi), %ymm10

vpbroadcastd	(%rdx), %ymm15
mul		15, 7
mont	7
mul		15, 8
mont	8
mul		15, 9
mont	9
mul		15, 10
mont	10

vmovdqa		(512*\i+8*\off)*4(%rdi), %ymm3
vmovdqa		(512*\i+8*\off+64)*4(%rdi), %ymm4
vmovdqa		(512*\i+8*\off+128)*4(%rdi), %ymm5
vmovdqa		(512*\i+8*\off+192)*4(%rdi), %ymm6

update	2, 3, 4, 5, 6, 7, 8, 9, 10

vpbroadcastd	4(%rdx), %ymm15
mul		15, 4
mont	4
mul		15, 5
mont	5

vpbroadcastd	8(%rdx), %ymm15
mul		15, 9
mont	9
mul		15, 10
mont	10

update	6, 2, 3, 7, 8, 4, 5, 9, 10

vpbroadcastd	12(%rdx), %ymm15
mul		15, 2
mont	2
vpbroadcastd	16(%rdx), %ymm15
mul		15, 5
mont	5
vpbroadcastd	20(%rdx), %ymm15
mul		15, 7
mont	7
vpbroadcastd	24(%rdx), %ymm15
mul		15, 10
mont	10

update	8, 6, 4, 3, 9, 2, 5, 7, 10

vmovdqa		%ymm8, (512*\i+8*\off)*4(%rdi)
vmovdqa		%ymm2, (512*\i+8*\off+64)*4(%rdi)
vmovdqa		%ymm6, (512*\i+8*\off+128)*4(%rdi)
vmovdqa		%ymm5, (512*\i+8*\off+192)*4(%rdi)
vmovdqa		%ymm4, (512*\i+8*\off+256)*4(%rdi)
vmovdqa		%ymm7, (512*\i+8*\off+320)*4(%rdi)
vmovdqa		%ymm3, (512*\i+8*\off+384)*4(%rdi)
vmovdqa		%ymm10,(512*\i+8*\off+448)*4(%rdi)

.endm

.macro level3_5_iter i

level3_5	0, \i
level3_5	1, \i
level3_5	2, \i
level3_5	3, \i
level3_5	4, \i
level3_5	5, \i
level3_5	6, \i
level3_5	7, \i
add		$28, %rdx

.endm

.macro LEVEL_6_11 i
vpbroadcastd	(%rdx),%ymm15

vmovdqa		128(%rdi),%ymm7
vmovdqa		160(%rdi),%ymm8
vmovdqa		192(%rdi),%ymm9
vmovdqa		224(%rdi),%ymm10

mul 		15, 7
mont 		7
mul 		15, 8
mont 		8
mul 		15, 9
mont 		9
mul 		15, 10
mont 		10

vmovdqa		(%rdi),%ymm3
vmovdqa		32(%rdi),%ymm4
vmovdqa		64(%rdi),%ymm5
vmovdqa		96(%rdi),%ymm6

update 	2, 3, 4, 5, 6, 7, 8, 9, 10

vpbroadcastd	4(%rdx),%ymm15

mul 15, 4
mont 4
mul 15, 5
mont 5

vpbroadcastd	8(%rdx),%ymm15
mul 15, 9
mont 9
mul 15, 10
mont 10

update	6, 2, 3, 7, 8, 4, 5, 9, 10

vpbroadcastd	12(%rdx),%ymm15
mul	15, 2
mont 2

vpbroadcastd	16(%rdx),%ymm15
mul 15, 5
mont 5

vpbroadcastd	20(%rdx),%ymm15
mul 15, 7
mont 7

vpbroadcastd	24(%rdx),%ymm15
mul 15, 10
mont 10

add			$32, %rdx
update	8, 6, 4, 3, 9, 2, 5, 7, 10

shuffle4	8, 2, 9, 2
shuffle4	6, 5, 8, 5
shuffle4	4, 7, 6, 7
shuffle4	3,10, 4,10

vmovdqa		(%rdx), %ymm15
mul	15, 2
mont 2

vmovdqa		32(%rdx), %ymm15
mul	15, 5
mont 5

vmovdqa		64(%rdx), %ymm15
mul	15, 7
mont 7

vmovdqa		96(%rdx), %ymm15
mul	15, 10
mont 10

update	3, 9, 8, 6, 4, 2, 5, 7, 10

shuffle4	3, 2, 4, 2
shuffle4	9, 5, 3, 5
shuffle4	8, 7, 9, 7
shuffle4	6,10, 8,10

add		$128, %rdx

shuffle2	4, 2, 6, 2
shuffle2	3, 5, 4, 5
shuffle2	9, 7, 3, 7
shuffle2	8,10, 9,10

vmovdqa		(%rdx), %ymm15
mul	15, 2
mont 2

vmovdqa		32(%rdx), %ymm15
mul	15, 5
mont 5

vmovdqa		64(%rdx), %ymm15
mul	15, 7
mont 7

vmovdqa		96(%rdx), %ymm15
mul	15, 10
mont 10

update	8, 6, 4, 3, 9, 2, 5, 7, 10

shuffle2	8, 2, 9, 2
shuffle2	6, 5, 8, 5
shuffle2	4, 7, 6, 7
shuffle2	3,10, 4,10

add		$128, %rdx

shuffle1	9, 2, 3, 2
shuffle1	8, 5, 9, 5
shuffle1	6, 7, 8, 7
shuffle1	4,10, 6,10

vmovdqa		(%rdx), %ymm15
mul	15, 2
mont 2

vmovdqa		32(%rdx), %ymm15
mul	15, 5
mont 5

vmovdqa		64(%rdx), %ymm15
mul	15, 7
mont 7

vmovdqa		96(%rdx), %ymm15
mul	15, 10
mont 10

update	4, 3, 9, 8, 6, 2, 5, 7, 10

shuffle1	4, 2, 6, 2
shuffle1	3, 5, 4, 5
shuffle1	9, 7, 3, 7
shuffle1	8,10, 9,10

add		$128, %rdx

vmovdqa		%ymm6, (%rdi)
vmovdqa		%ymm2, 32(%rdi)
vmovdqa		%ymm4, 64(%rdi)
vmovdqa		%ymm5, 96(%rdi)
vmovdqa		%ymm3, 128(%rdi)
vmovdqa		%ymm7, 160(%rdi)
vmovdqa		%ymm9, 192(%rdi)
vmovdqa		%ymm10,224(%rdi)
  
add		$256, %rdi
.endm

/*
	The following function is the Cooley-Tukey's 
	forward NTT operation for polynomials of size 
	n = 4096
*/

.text
.global CT_forward
CT_forward:

vpbroadcastd	(%rsi),%ymm0
vpbroadcastd	4(%rsi),%ymm1

add			$4, %rdx

level0_2	0
level0_2	1
level0_2	2
level0_2	3
level0_2	4
level0_2	5
level0_2	6
level0_2	7
level0_2	8
level0_2	9
level0_2	10
level0_2	11
level0_2	12
level0_2	13
level0_2	14
level0_2	15
level0_2	16
level0_2	17
level0_2	18
level0_2	19
level0_2	20
level0_2	21
level0_2	22
level0_2	23
level0_2	24
level0_2	25
level0_2	26
level0_2	27
level0_2	28
level0_2	29
level0_2	30
level0_2	31
level0_2	32
level0_2	33
level0_2	34
level0_2	35
level0_2	36
level0_2	37
level0_2	38
level0_2	39
level0_2	40
level0_2	41
level0_2	42
level0_2	43
level0_2	44
level0_2	45
level0_2	46
level0_2	47
level0_2	48
level0_2	49
level0_2	50
level0_2	51
level0_2	52
level0_2	53
level0_2	54
level0_2	55
level0_2	56
level0_2	57
level0_2	58
level0_2	59
level0_2	60
level0_2	61
level0_2	62
level0_2	63

add 	$28, %rdx
level3_5_iter	0
level3_5_iter	1
level3_5_iter	2
level3_5_iter	3
level3_5_iter	4
level3_5_iter	5
level3_5_iter	6
level3_5_iter	7

LEVEL_6_11	 0
LEVEL_6_11	 1
LEVEL_6_11	 2
LEVEL_6_11	 3
LEVEL_6_11	 4
LEVEL_6_11	 5
LEVEL_6_11	 6
LEVEL_6_11	 7
LEVEL_6_11	 8
LEVEL_6_11	 9
LEVEL_6_11	 10
LEVEL_6_11	 11
LEVEL_6_11	 12
LEVEL_6_11	 13
LEVEL_6_11	 14
LEVEL_6_11	 15
LEVEL_6_11	 16
LEVEL_6_11	 17
LEVEL_6_11	 18
LEVEL_6_11	 19
LEVEL_6_11	 20
LEVEL_6_11	 21
LEVEL_6_11	 22
LEVEL_6_11	 23
LEVEL_6_11	 24
LEVEL_6_11	 25
LEVEL_6_11	 26
LEVEL_6_11	 27
LEVEL_6_11	 28
LEVEL_6_11	 29
LEVEL_6_11	 30
LEVEL_6_11	 31
LEVEL_6_11	 32
LEVEL_6_11	 33
LEVEL_6_11	 34
LEVEL_6_11	 35
LEVEL_6_11	 36
LEVEL_6_11	 37
LEVEL_6_11	 38
LEVEL_6_11	 39
LEVEL_6_11	 40
LEVEL_6_11	 41
LEVEL_6_11	 42
LEVEL_6_11	 43
LEVEL_6_11	 44
LEVEL_6_11	 45
LEVEL_6_11	 46
LEVEL_6_11	 47
LEVEL_6_11	 48
LEVEL_6_11	 49
LEVEL_6_11	 50
LEVEL_6_11	 51
LEVEL_6_11	 52
LEVEL_6_11	 53
LEVEL_6_11	 54
LEVEL_6_11	 55
LEVEL_6_11	 56
LEVEL_6_11	 57
LEVEL_6_11	 58
LEVEL_6_11	 59
LEVEL_6_11	 60
LEVEL_6_11	 61
LEVEL_6_11	 62
LEVEL_6_11	 63

ret

#elif SEC_LEVEL==2

.macro level0_2 off, i

vmovdqa		(64*\i+8*\off+4096)*4(%rdi),%ymm7
vmovdqa		(64*\i+8*\off+5120)*4(%rdi),%ymm8
vmovdqa		(64*\i+8*\off+6144)*4(%rdi),%ymm9
vmovdqa		(64*\i+8*\off+7168)*4(%rdi),%ymm10

vpbroadcastd	(%rdx),%ymm15

mul 		15, 7
mont 		7
mul 		15, 8
mont 		8
mul 		15, 9
mont 		9
mul 		15, 10
mont 		10

vmovdqa		(64*\i+8*\off)*4(%rdi),%ymm3
vmovdqa		(64*\i+8*\off+1024)*4(%rdi),%ymm4
vmovdqa		(64*\i+8*\off+2048)*4(%rdi),%ymm5
vmovdqa		(64*\i+8*\off+3072)*4(%rdi),%ymm6

update 	2, 3, 4, 5, 6, 7, 8, 9, 10

vpbroadcastd	4(%rdx),%ymm15

mul			15, 4
mont 		4
mul			15, 5
mont 		5

vpbroadcastd	8(%rdx),%ymm15

mul			15, 9
mont 		9
mul			15, 10
mont 		10

update 	6, 2, 3, 7, 8, 4, 5, 9, 10

vpbroadcastd	12(%rdx),%ymm15
mul			15, 2
mont 		2

vpbroadcastd	16(%rdx),%ymm15
mul			15, 5
mont 		5

vpbroadcastd	20(%rdx),%ymm15
mul			15, 7
mont 		7

vpbroadcastd	24(%rdx),%ymm15
mul			15, 10
mont 		10

update	8, 6, 4, 3, 9, 2, 5, 7, 10

vmovdqa		%ymm8, (64*\i+8*\off)*4(%rdi)
vmovdqa		%ymm2, (64*\i+8*\off+1024)*4(%rdi)
vmovdqa		%ymm6, (64*\i+8*\off+2048)*4(%rdi)
vmovdqa		%ymm5, (64*\i+8*\off+3072)*4(%rdi)
vmovdqa		%ymm4, (64*\i+8*\off+4096)*4(%rdi)
vmovdqa		%ymm7, (64*\i+8*\off+5120)*4(%rdi)
vmovdqa		%ymm3, (64*\i+8*\off+6144)*4(%rdi)
vmovdqa		%ymm10,(64*\i+8*\off+7168)*4(%rdi)

.endm

.macro level0_2_block64		i
level0_2	0, \i
level0_2	1, \i
level0_2	2, \i
level0_2	3, \i
level0_2	4, \i
level0_2	5, \i
level0_2	6, \i
level0_2	7, \i
.endm

.macro level3_5 off, i

vmovdqa		(1024*\i+8*\off+512)*4(%rdi), %ymm7
vmovdqa		(1024*\i+8*\off+640)*4(%rdi), %ymm8
vmovdqa		(1024*\i+8*\off+768)*4(%rdi), %ymm9
vmovdqa		(1024*\i+8*\off+896)*4(%rdi), %ymm10

vpbroadcastd	(%rdx), %ymm15
mul		15, 7
mont	7
mul		15, 8
mont	8
mul		15, 9
mont	9
mul		15, 10
mont	10

vmovdqa		(1024*\i+8*\off)*4(%rdi), %ymm3
vmovdqa		(1024*\i+8*\off+128)*4(%rdi), %ymm4
vmovdqa		(1024*\i+8*\off+256)*4(%rdi), %ymm5
vmovdqa		(1024*\i+8*\off+384)*4(%rdi), %ymm6

update	2, 3, 4, 5, 6, 7, 8, 9, 10

vpbroadcastd	4(%rdx), %ymm15
mul		15, 4
mont	4
mul		15, 5
mont	5

vpbroadcastd	8(%rdx), %ymm15
mul		15, 9
mont	9
mul		15, 10
mont	10

update	6, 2, 3, 7, 8, 4, 5, 9, 10

vpbroadcastd	12(%rdx), %ymm15
mul		15, 2
mont	2
vpbroadcastd	16(%rdx), %ymm15
mul		15, 5
mont	5
vpbroadcastd	20(%rdx), %ymm15
mul		15, 7
mont	7
vpbroadcastd	24(%rdx), %ymm15
mul		15, 10
mont	10

update	8, 6, 4, 3, 9, 2, 5, 7, 10

vmovdqa		%ymm8, (1024*\i+8*\off)*4(%rdi)
vmovdqa		%ymm2, (1024*\i+8*\off+128)*4(%rdi)
vmovdqa		%ymm6, (1024*\i+8*\off+256)*4(%rdi)
vmovdqa		%ymm5, (1024*\i+8*\off+384)*4(%rdi)
vmovdqa		%ymm4, (1024*\i+8*\off+512)*4(%rdi)
vmovdqa		%ymm7, (1024*\i+8*\off+640)*4(%rdi)
vmovdqa		%ymm3, (1024*\i+8*\off+768)*4(%rdi)
vmovdqa		%ymm10,(1024*\i+8*\off+896)*4(%rdi)

.endm

.macro level3_5_iter i

level3_5	0, \i
level3_5	1, \i
level3_5	2, \i
level3_5	3, \i
level3_5	4, \i
level3_5	5, \i
level3_5	6, \i
level3_5	7, \i
level3_5	8, \i
level3_5	9, \i
level3_5	10, \i
level3_5	11, \i
level3_5	12, \i
level3_5	13, \i
level3_5	14, \i
level3_5	15, \i
add		$28, %rdx

.endm

.macro level6	off, i
vmovdqa		(128*\i+32*\off+64)*4(%rdi), %ymm7
vmovdqa		(128*\i+32*\off+72)*4(%rdi), %ymm8
vmovdqa		(128*\i+32*\off+80)*4(%rdi), %ymm9
vmovdqa		(128*\i+32*\off+88)*4(%rdi), %ymm10

mul 		15, 7
mont 		7
mul 		15, 8
mont 		8
mul 		15, 9
mont 		9
mul 		15, 10
mont 		10

vmovdqa		(128*\i+32*\off)*4(%rdi), %ymm3
vmovdqa		(128*\i+32*\off+8)*4(%rdi), %ymm4
vmovdqa		(128*\i+32*\off+16)*4(%rdi), %ymm5
vmovdqa		(128*\i+32*\off+24)*4(%rdi), %ymm6

update 	2, 3, 4, 5, 6, 7, 8, 9, 10

vmovdqa		%ymm2, (128*\i+32*\off)*4(%rdi)
vmovdqa		%ymm3, (128*\i+32*\off+8)*4(%rdi)
vmovdqa		%ymm4, (128*\i+32*\off+16)*4(%rdi)
vmovdqa		%ymm5, (128*\i+32*\off+24)*4(%rdi)
vmovdqa		%ymm7, (128*\i+32*\off+64)*4(%rdi)
vmovdqa		%ymm8, (128*\i+32*\off+72)*4(%rdi)
vmovdqa		%ymm9, (128*\i+32*\off+80)*4(%rdi)
vmovdqa		%ymm10, (128*\i+32*\off+88)*4(%rdi)

.endm

.macro level6_iter i

vpbroadcastd	(%rdx), %ymm15

level6		0, \i
level6		1, \i

add		$4, %rdx

.endm

.macro level7_12 i
vpbroadcastd	(%rdx),%ymm15

vmovdqa		128(%rdi),%ymm7
vmovdqa		160(%rdi),%ymm8
vmovdqa		192(%rdi),%ymm9
vmovdqa		224(%rdi),%ymm10

mul 		15, 7
mont 		7
mul 		15, 8
mont 		8
mul 		15, 9
mont 		9
mul 		15, 10
mont 		10

vmovdqa		(%rdi),%ymm3
vmovdqa		32(%rdi),%ymm4
vmovdqa		64(%rdi),%ymm5
vmovdqa		96(%rdi),%ymm6

update 	2, 3, 4, 5, 6, 7, 8, 9, 10

add			$4, %rdx
vpbroadcastd	(%rdx),%ymm15

mul 15, 4
mont 4
mul 15, 5
mont 5

add			$4, %rdx
vpbroadcastd	(%rdx),%ymm15

mul 15, 9
mont 9
mul 15, 10
mont 10

update	6, 2, 3, 7, 8, 4, 5, 9, 10

add			$4, %rdx
vpbroadcastd	(%rdx),%ymm15

mul	15, 2
mont 2

add			$4, %rdx
vpbroadcastd	(%rdx),%ymm15

mul 15, 5
mont 5

add			$4, %rdx
vpbroadcastd	(%rdx),%ymm15

mul 15, 7
mont 7

add			$4, %rdx
vpbroadcastd	(%rdx),%ymm15

mul 15, 10
mont 10

add			$8, %rdx
update	8, 6, 4, 3, 9, 2, 5, 7, 10

shuffle4	8, 2, 9, 2
shuffle4	6, 5, 8, 5
shuffle4	4, 7, 6, 7
shuffle4	3,10, 4,10

vmovdqa		(%rdx), %ymm15
mul	15, 2
mont 2

vmovdqa		32(%rdx), %ymm15
mul	15, 5
mont 5

vmovdqa		64(%rdx), %ymm15
mul	15, 7
mont 7

vmovdqa		96(%rdx), %ymm15
mul	15, 10
mont 10

update	3, 9, 8, 6, 4, 2, 5, 7, 10

shuffle4	3, 2, 4, 2
shuffle4	9, 5, 3, 5
shuffle4	8, 7, 9, 7
shuffle4	6,10, 8,10

add		$128, %rdx

shuffle2	4, 2, 6, 2
shuffle2	3, 5, 4, 5
shuffle2	9, 7, 3, 7
shuffle2	8,10, 9,10

vmovdqa		(%rdx), %ymm15
mul	15, 2
mont 2

vmovdqa		32(%rdx), %ymm15
mul	15, 5
mont 5

vmovdqa		64(%rdx), %ymm15
mul	15, 7
mont 7

vmovdqa		96(%rdx), %ymm15
mul	15, 10
mont 10

update	8, 6, 4, 3, 9, 2, 5, 7, 10

shuffle2	8, 2, 9, 2
shuffle2	6, 5, 8, 5
shuffle2	4, 7, 6, 7
shuffle2	3,10, 4,10

add		$128, %rdx

shuffle1	9, 2, 3, 2
shuffle1	8, 5, 9, 5
shuffle1	6, 7, 8, 7
shuffle1	4,10, 6,10

vmovdqa		(%rdx), %ymm15
mul	15, 2
mont 2

vmovdqa		32(%rdx), %ymm15
mul	15, 5
mont 5

vmovdqa		64(%rdx), %ymm15
mul	15, 7
mont 7

vmovdqa		96(%rdx), %ymm15
mul	15, 10
mont 10

update	4, 3, 9, 8, 6, 2, 5, 7, 10

shuffle1	4, 2, 6, 2
shuffle1	3, 5, 4, 5
shuffle1	9, 7, 3, 7
shuffle1	8,10, 9,10

add		$128, %rdx

vmovdqa		%ymm6, (%rdi)
vmovdqa		%ymm2, 32(%rdi)
vmovdqa		%ymm4, 64(%rdi)
vmovdqa		%ymm5, 96(%rdi)
vmovdqa		%ymm3, 128(%rdi)
vmovdqa		%ymm7, 160(%rdi)
vmovdqa		%ymm9, 192(%rdi)
vmovdqa		%ymm10,224(%rdi)
  
add		$256, %rdi
.endm

.macro level7_12_x4
level7_12
level7_12
level7_12
level7_12
.endm

/*
	The following function is the Cooley-Tukey's 
	forward NTT operation for polynomials of size 
	n = 8192
*/

.text
.global CT_forward
CT_forward:

vpbroadcastd	(%rsi),%ymm0
vpbroadcastd	4(%rsi),%ymm1


add			$4, %rdx

level0_2_block64	0
level0_2_block64	1
level0_2_block64	2
level0_2_block64	3
level0_2_block64	4
level0_2_block64	5
level0_2_block64	6
level0_2_block64	7
level0_2_block64	8
level0_2_block64	9
level0_2_block64	10
level0_2_block64	11
level0_2_block64	12
level0_2_block64	13
level0_2_block64	14
level0_2_block64	15

add		$28, %rdx

level3_5_iter		0
level3_5_iter		1
level3_5_iter		2
level3_5_iter		3
level3_5_iter		4
level3_5_iter		5
level3_5_iter		6
level3_5_iter		7

level6_iter	 0
level6_iter	 1
level6_iter	 2
level6_iter	 3
level6_iter	 4
level6_iter	 5
level6_iter	 6
level6_iter	 7
level6_iter	 8
level6_iter	 9
level6_iter	 10
level6_iter	 11
level6_iter	 12
level6_iter	 13
level6_iter	 14
level6_iter	 15
level6_iter	 16
level6_iter	 17
level6_iter	 18
level6_iter	 19
level6_iter	 20
level6_iter	 21
level6_iter	 22
level6_iter	 23
level6_iter	 24
level6_iter	 25
level6_iter	 26
level6_iter	 27
level6_iter	 28
level6_iter	 29
level6_iter	 30
level6_iter	 31
level6_iter	 32
level6_iter	 33
level6_iter	 34
level6_iter	 35
level6_iter	 36
level6_iter	 37
level6_iter	 38
level6_iter	 39
level6_iter	 40
level6_iter	 41
level6_iter	 42
level6_iter	 43
level6_iter	 44
level6_iter	 45
level6_iter	 46
level6_iter	 47
level6_iter	 48
level6_iter	 49
level6_iter	 50
level6_iter	 51
level6_iter	 52
level6_iter	 53
level6_iter	 54
level6_iter	 55
level6_iter	 56
level6_iter	 57
level6_iter	 58
level6_iter	 59
level6_iter	 60
level6_iter	 61
level6_iter	 62
level6_iter	 63

level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4
level7_12_x4

ret

#endif

