.macro mul r0, r1, rl=13, rh=12 , e1=11				# Multiplication of two 32 bits integers

vpmuludq	%ymm\r0, %ymm\r1, %ymm\rh
vmovshdup	%ymm\rh, %ymm\rh
vmovshdup	%ymm\r1, %ymm\e1
vmovshdup	%ymm\r0, %ymm\rl
vpmuludq	%ymm\rl, %ymm\e1, %ymm\e1
vmovshdup	%ymm\e1, %ymm\e1
vpblendd	$0xAA, %ymm\e1, %ymm\rh, %ymm\rh		# putting high 32 bits of multiplication in rh
vpmulld		%ymm\r0, %ymm\r1, %ymm\rl				# putting low 32 bits of multiplication in rl
.endm

.macro mont r, q=0, qi=1							# Montgomery Reduction

vpmulld		%ymm13, %ymm\qi, %ymm13
vpmuludq	%ymm13, %ymm\q, %ymm\r
vmovshdup	%ymm\r, %ymm\r
vmovshdup	%ymm13, %ymm13
#vmovshdup	%ymm\q, %ymm11
vpmuludq	%ymm13, %ymm\q, %ymm13
vpblendd	$0xAA, %ymm13, %ymm\r, %ymm\r
vpsubq		%ymm\r, %ymm12, %ymm\r

vpsrad		$31, %ymm\r, %ymm13

vpand		%ymm13, %ymm\q, %ymm13
vpaddq		%ymm\r, %ymm13, %ymm\r

.endm


.macro shuffle4 r0,r1,r2,r3
vperm2i128	$0x20,%ymm\r1,%ymm\r0,%ymm\r2
vperm2i128	$0x31,%ymm\r1,%ymm\r0,%ymm\r3
.endm

.macro shuffle2 r0,r1,r2,r3
vpunpcklqdq	%ymm\r1,%ymm\r0,%ymm\r2
vpunpckhqdq	%ymm\r1,%ymm\r0,%ymm\r3
.endm

.macro shuffle1 r0,r1,r2,r3
vmovsldup	%ymm\r1,%ymm\r2
vpblendd	$0xAA,%ymm\r2,%ymm\r0,%ymm\r2
vpsrlq		$32,%ymm\r0,%ymm\r0
vpblendd	$0xAA,%ymm\r1,%ymm\r0,%ymm\r3
.endm

