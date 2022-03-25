#include "seclevel.h"
.include "arith.inc"

.macro multupdate l0, l1, r0, r1, f

vpaddq		%ymm\l0, %ymm\l1, %ymm\f
vpsubq		%ymm0, %ymm\f, %ymm\f
vpsrad		$31, %ymm\f, %ymm11
vpand		%ymm11, %ymm0, %ymm11
vpaddq		%ymm11, %ymm\f, %ymm\f

/* yl0 + yl1 -> yf */

mul 	15, \l0
mont 	\l0
mul		15, \l1
mont 	\l1
mul		15, \f
mont 	\f

mul		\l0, \r0
mont	\l0
mul		\l1, \r1
mont	\l1

vpaddq		%ymm\r0, %ymm\r1, %ymm\r0
vpsubq		%ymm0, %ymm\r0, %ymm\r0
vpsrad		$31, %ymm\r0, %ymm11
vpand		%ymm11, %ymm0, %ymm11
vpaddq		%ymm11, %ymm\r0, %ymm\r0

mul		\f, \r0
mont	\f

vpaddq		%ymm\l0, %ymm\l1, %ymm\r0
vpsubq		%ymm0, %ymm\r0, %ymm\r0
vpsrad		$31, %ymm\r0, %ymm11
vpand		%ymm11, %ymm0, %ymm11
vpaddq		%ymm11, %ymm\r0, %ymm\r0

vpsubq		%ymm\r0, %ymm\f, %ymm\f
vpsrad		$31, %ymm\f, %ymm11
vpand		%ymm11, %ymm0, %ymm11
vpaddq		%ymm11, %ymm\f, %ymm\f

vmovdqa		(%rcx), %ymm\r1
add			$32, %rcx

mul 	\r1, \l1
mont 	\l1

vpaddq		%ymm\l0, %ymm\l1, %ymm\l0
vpsubq		%ymm0, %ymm\l0, %ymm\l0
vpsrad		$31, %ymm\l0, %ymm11
vpand		%ymm11, %ymm0, %ymm11
vpaddq		%ymm11, %ymm\l0, %ymm\l0

.endm

.macro _MULT2X2 off

vmovdqa		(32*\off)*4(%rdi), %ymm3
vmovdqa		(32*\off+8)*4(%rdi), %ymm4
vmovdqa		(32*\off+16)*4(%rdi), %ymm5
vmovdqa		(32*\off+24)*4(%rdi), %ymm6

vmovdqa		(32*\off)*4(%rsi), %ymm7
vmovdqa		(32*\off+8)*4(%rsi), %ymm8
vmovdqa		(32*\off+16)*4(%rsi), %ymm9
vmovdqa		(32*\off+24)*4(%rsi), %ymm10


shuffle1	3, 4, 2, 4
shuffle1	5, 6, 3, 6
shuffle1	7, 8, 5, 8
shuffle1	9,10, 7,10

#2 4 3 6 5 8 7 10

multupdate	2, 4, 5, 8, 9
multupdate  3, 6, 7,10, 4  

shuffle1	2, 9, 6, 9
shuffle1	3, 4, 2, 4

vmovdqa		%ymm6,  (32*\off)*4(%rdx)
vmovdqa		%ymm9,  (32*\off+8)*4(%rdx)
vmovdqa		%ymm2,  (32*\off+16)*4(%rdx)
vmovdqa		%ymm4,  (32*\off+24)*4(%rdx)

.endm
 
.text
.global _point_mul
_point_mul:

/* %rdi <- a, %rsi <- b, %rdx <- res, %rcx <- psi_sqr data, %r8 <- qdata */

vpbroadcastd	(%r8),%ymm0
vpbroadcastd	4(%r8),%ymm1
vpbroadcastd	12(%r8),%ymm15



_MULT2X2	0
_MULT2X2	1
_MULT2X2	2
_MULT2X2	3
_MULT2X2	4
_MULT2X2	5
_MULT2X2	6
_MULT2X2	7
_MULT2X2	8
_MULT2X2	9
_MULT2X2	10
_MULT2X2	11
_MULT2X2	12
_MULT2X2	13
_MULT2X2	14
_MULT2X2	15
_MULT2X2	16
_MULT2X2	17
_MULT2X2	18
_MULT2X2	19
_MULT2X2	20
_MULT2X2	21
_MULT2X2	22
_MULT2X2	23
_MULT2X2	24
_MULT2X2	25
_MULT2X2	26
_MULT2X2	27
_MULT2X2	28
_MULT2X2	29
_MULT2X2	30
_MULT2X2	31
_MULT2X2	32
_MULT2X2	33
_MULT2X2	34
_MULT2X2	35
_MULT2X2	36
_MULT2X2	37
_MULT2X2	38
_MULT2X2	39
_MULT2X2	40
_MULT2X2	41
_MULT2X2	42
_MULT2X2	43
_MULT2X2	44
_MULT2X2	45
_MULT2X2	46
_MULT2X2	47
_MULT2X2	48
_MULT2X2	49
_MULT2X2	50
_MULT2X2	51
_MULT2X2	52
_MULT2X2	53
_MULT2X2	54
_MULT2X2	55
_MULT2X2	56
_MULT2X2	57
_MULT2X2	58
_MULT2X2	59
_MULT2X2	60
_MULT2X2	61
_MULT2X2	62
_MULT2X2	63
_MULT2X2	64
_MULT2X2	65
_MULT2X2	66
_MULT2X2	67
_MULT2X2	68
_MULT2X2	69
_MULT2X2	70
_MULT2X2	71
_MULT2X2	72
_MULT2X2	73
_MULT2X2	74
_MULT2X2	75
_MULT2X2	76
_MULT2X2	77
_MULT2X2	78
_MULT2X2	79
_MULT2X2	80
_MULT2X2	81
_MULT2X2	82
_MULT2X2	83
_MULT2X2	84
_MULT2X2	85
_MULT2X2	86
_MULT2X2	87
_MULT2X2	88
_MULT2X2	89
_MULT2X2	90
_MULT2X2	91
_MULT2X2	92
_MULT2X2	93
_MULT2X2	94
_MULT2X2	95
_MULT2X2	96
_MULT2X2	97
_MULT2X2	98
_MULT2X2	99
_MULT2X2	100
_MULT2X2	101
_MULT2X2	102
_MULT2X2	103
_MULT2X2	104
_MULT2X2	105
_MULT2X2	106
_MULT2X2	107
_MULT2X2	108
_MULT2X2	109
_MULT2X2	110
_MULT2X2	111
_MULT2X2	112
_MULT2X2	113
_MULT2X2	114
_MULT2X2	115
_MULT2X2	116
_MULT2X2	117
_MULT2X2	118
_MULT2X2	119
_MULT2X2	120
_MULT2X2	121
_MULT2X2	122
_MULT2X2	123
_MULT2X2	124
_MULT2X2	125
_MULT2X2	126
_MULT2X2	127

#if SEC_LEVEL==2

_MULT2X2	128
_MULT2X2	129
_MULT2X2	130
_MULT2X2	131
_MULT2X2	132
_MULT2X2	133
_MULT2X2	134
_MULT2X2	135
_MULT2X2	136
_MULT2X2	137
_MULT2X2	138
_MULT2X2	139
_MULT2X2	140
_MULT2X2	141
_MULT2X2	142
_MULT2X2	143
_MULT2X2	144
_MULT2X2	145
_MULT2X2	146
_MULT2X2	147
_MULT2X2	148
_MULT2X2	149
_MULT2X2	150
_MULT2X2	151
_MULT2X2	152
_MULT2X2	153
_MULT2X2	154
_MULT2X2	155
_MULT2X2	156
_MULT2X2	157
_MULT2X2	158
_MULT2X2	159
_MULT2X2	160
_MULT2X2	161
_MULT2X2	162
_MULT2X2	163
_MULT2X2	164
_MULT2X2	165
_MULT2X2	166
_MULT2X2	167
_MULT2X2	168
_MULT2X2	169
_MULT2X2	170
_MULT2X2	171
_MULT2X2	172
_MULT2X2	173
_MULT2X2	174
_MULT2X2	175
_MULT2X2	176
_MULT2X2	177
_MULT2X2	178
_MULT2X2	179
_MULT2X2	180
_MULT2X2	181
_MULT2X2	182
_MULT2X2	183
_MULT2X2	184
_MULT2X2	185
_MULT2X2	186
_MULT2X2	187
_MULT2X2	188
_MULT2X2	189
_MULT2X2	190
_MULT2X2	191
_MULT2X2	192
_MULT2X2	193
_MULT2X2	194
_MULT2X2	195
_MULT2X2	196
_MULT2X2	197
_MULT2X2	198
_MULT2X2	199
_MULT2X2	200
_MULT2X2	201
_MULT2X2	202
_MULT2X2	203
_MULT2X2	204
_MULT2X2	205
_MULT2X2	206
_MULT2X2	207
_MULT2X2	208
_MULT2X2	209
_MULT2X2	210
_MULT2X2	211
_MULT2X2	212
_MULT2X2	213
_MULT2X2	214
_MULT2X2	215
_MULT2X2	216
_MULT2X2	217
_MULT2X2	218
_MULT2X2	219
_MULT2X2	220
_MULT2X2	221
_MULT2X2	222
_MULT2X2	223
_MULT2X2	224
_MULT2X2	225
_MULT2X2	226
_MULT2X2	227
_MULT2X2	228
_MULT2X2	229
_MULT2X2	230
_MULT2X2	231
_MULT2X2	232
_MULT2X2	233
_MULT2X2	234
_MULT2X2	235
_MULT2X2	236
_MULT2X2	237
_MULT2X2	238
_MULT2X2	239
_MULT2X2	240
_MULT2X2	241
_MULT2X2	242
_MULT2X2	243
_MULT2X2	244
_MULT2X2	245
_MULT2X2	246
_MULT2X2	247
_MULT2X2	248
_MULT2X2	249
_MULT2X2	250
_MULT2X2	251
_MULT2X2	252
_MULT2X2	253
_MULT2X2	254
_MULT2X2	255

#endif

ret

.macro mul_1x1 off

vmovdqa		(32*\off)*4(%rdi), %ymm3
vmovdqa		(32*\off+8)*4(%rdi), %ymm4
vmovdqa		(32*\off+16)*4(%rdi), %ymm5
vmovdqa		(32*\off+24)*4(%rdi), %ymm6

vmovdqa		(32*\off)*4(%rsi), %ymm7
vmovdqa		(32*\off+8)*4(%rsi), %ymm8
vmovdqa		(32*\off+16)*4(%rsi), %ymm9
vmovdqa		(32*\off+24)*4(%rsi), %ymm10

mul		3, 15
mont 	3
mul		4, 15
mont	4
mul		5, 15
mont	5
mul		6, 15
mont	6

mul		3, 7
mont	3
mul		4, 8
mont	4
mul		5, 9
mont	5
mul		6, 10
mont	6

vmovdqa		%ymm3, (32*\off)*4(%rdx)
vmovdqa		%ymm4, (32*\off+8)*4(%rdx)
vmovdqa		%ymm5, (32*\off+16)*4(%rdx)
vmovdqa		%ymm6, (32*\off+24)*4(%rdx)


.endm

.text
.global point_mul_
point_mul_:

vpbroadcastd	(%rcx),%ymm0
vpbroadcastd	4(%rcx),%ymm1
vpbroadcastd	12(%rcx),%ymm15

mul_1x1    0
mul_1x1    1
mul_1x1    2
mul_1x1    3
mul_1x1    4
mul_1x1    5
mul_1x1    6
mul_1x1    7
mul_1x1    8
mul_1x1    9
mul_1x1    10
mul_1x1    11
mul_1x1    12
mul_1x1    13
mul_1x1    14
mul_1x1    15
mul_1x1    16
mul_1x1    17
mul_1x1    18
mul_1x1    19
mul_1x1    20
mul_1x1    21
mul_1x1    22
mul_1x1    23
mul_1x1    24
mul_1x1    25
mul_1x1    26
mul_1x1    27
mul_1x1    28
mul_1x1    29
mul_1x1    30
mul_1x1    31
mul_1x1    32
mul_1x1    33
mul_1x1    34
mul_1x1    35
mul_1x1    36
mul_1x1    37
mul_1x1    38
mul_1x1    39
mul_1x1    40
mul_1x1    41
mul_1x1    42
mul_1x1    43
mul_1x1    44
mul_1x1    45
mul_1x1    46
mul_1x1    47
mul_1x1    48
mul_1x1    49
mul_1x1    50
mul_1x1    51
mul_1x1    52
mul_1x1    53
mul_1x1    54
mul_1x1    55
mul_1x1    56
mul_1x1    57
mul_1x1    58
mul_1x1    59
mul_1x1    60
mul_1x1    61
mul_1x1    62
mul_1x1    63
mul_1x1	64
mul_1x1	65
mul_1x1	66
mul_1x1	67
mul_1x1	68
mul_1x1	69
mul_1x1	70
mul_1x1	71
mul_1x1	72
mul_1x1	73
mul_1x1	74
mul_1x1	75
mul_1x1	76
mul_1x1	77
mul_1x1	78
mul_1x1	79
mul_1x1	80
mul_1x1	81
mul_1x1	82
mul_1x1	83
mul_1x1	84
mul_1x1	85
mul_1x1	86
mul_1x1	87
mul_1x1	88
mul_1x1	89
mul_1x1	90
mul_1x1	91
mul_1x1	92
mul_1x1	93
mul_1x1	94
mul_1x1	95
mul_1x1	96
mul_1x1	97
mul_1x1	98
mul_1x1	99
mul_1x1	100
mul_1x1	101
mul_1x1	102
mul_1x1	103
mul_1x1	104
mul_1x1	105
mul_1x1	106
mul_1x1	107
mul_1x1	108
mul_1x1	109
mul_1x1	110
mul_1x1	111
mul_1x1	112
mul_1x1	113
mul_1x1	114
mul_1x1	115
mul_1x1	116
mul_1x1	117
mul_1x1	118
mul_1x1	119
mul_1x1	120
mul_1x1	121
mul_1x1	122
mul_1x1	123
mul_1x1	124
mul_1x1	125
mul_1x1	126
mul_1x1	127

#if SEC_LEVEL==2

mul_1x1	128
mul_1x1	129
mul_1x1	130
mul_1x1	131
mul_1x1	132
mul_1x1	133
mul_1x1	134
mul_1x1	135
mul_1x1	136
mul_1x1	137
mul_1x1	138
mul_1x1	139
mul_1x1	140
mul_1x1	141
mul_1x1	142
mul_1x1	143
mul_1x1	144
mul_1x1	145
mul_1x1	146
mul_1x1	147
mul_1x1	148
mul_1x1	149
mul_1x1	150
mul_1x1	151
mul_1x1	152
mul_1x1	153
mul_1x1	154
mul_1x1	155
mul_1x1	156
mul_1x1	157
mul_1x1	158
mul_1x1	159
mul_1x1	160
mul_1x1	161
mul_1x1	162
mul_1x1	163
mul_1x1	164
mul_1x1	165
mul_1x1	166
mul_1x1	167
mul_1x1	168
mul_1x1	169
mul_1x1	170
mul_1x1	171
mul_1x1	172
mul_1x1	173
mul_1x1	174
mul_1x1	175
mul_1x1	176
mul_1x1	177
mul_1x1	178
mul_1x1	179
mul_1x1	180
mul_1x1	181
mul_1x1	182
mul_1x1	183
mul_1x1	184
mul_1x1	185
mul_1x1	186
mul_1x1	187
mul_1x1	188
mul_1x1	189
mul_1x1	190
mul_1x1	191
mul_1x1	192
mul_1x1	193
mul_1x1	194
mul_1x1	195
mul_1x1	196
mul_1x1	197
mul_1x1	198
mul_1x1	199
mul_1x1	200
mul_1x1	201
mul_1x1	202
mul_1x1	203
mul_1x1	204
mul_1x1	205
mul_1x1	206
mul_1x1	207
mul_1x1	208
mul_1x1	209
mul_1x1	210
mul_1x1	211
mul_1x1	212
mul_1x1	213
mul_1x1	214
mul_1x1	215
mul_1x1	216
mul_1x1	217
mul_1x1	218
mul_1x1	219
mul_1x1	220
mul_1x1	221
mul_1x1	222
mul_1x1	223
mul_1x1	224
mul_1x1	225
mul_1x1	226
mul_1x1	227
mul_1x1	228
mul_1x1	229
mul_1x1	230
mul_1x1	231
mul_1x1	232
mul_1x1	233
mul_1x1	234
mul_1x1	235
mul_1x1	236
mul_1x1	237
mul_1x1	238
mul_1x1	239
mul_1x1	240
mul_1x1	241
mul_1x1	242
mul_1x1	243
mul_1x1	244
mul_1x1	245
mul_1x1	246
mul_1x1	247
mul_1x1	248
mul_1x1	249
mul_1x1	250
mul_1x1	251
mul_1x1	252
mul_1x1	253
mul_1x1	254
mul_1x1	255

#endif

ret
