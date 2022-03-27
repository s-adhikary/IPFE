#include "seclevel.h"
.include "arith.inc"

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
.global point_mul
point_mul:

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
mul_1x1	   64
mul_1x1	   65
mul_1x1	   66
mul_1x1	   67
mul_1x1	   68
mul_1x1	   69
mul_1x1	   70
mul_1x1	   71
mul_1x1	   72
mul_1x1	   73
mul_1x1	   74
mul_1x1	   75
mul_1x1	   76
mul_1x1	   77
mul_1x1	   78
mul_1x1	   79
mul_1x1	   80
mul_1x1	   81
mul_1x1	   82
mul_1x1	   83
mul_1x1	   84
mul_1x1	   85
mul_1x1	   86
mul_1x1	   87
mul_1x1	   88
mul_1x1	   89
mul_1x1	   90
mul_1x1	   91
mul_1x1	   92
mul_1x1	   93
mul_1x1	   94
mul_1x1	   95
mul_1x1	   96
mul_1x1	   97
mul_1x1	   98
mul_1x1    99
mul_1x1    100
mul_1x1    101
mul_1x1    102
mul_1x1    103
mul_1x1    104
mul_1x1    105
mul_1x1    106
mul_1x1    107
mul_1x1    108
mul_1x1    109
mul_1x1    110
mul_1x1    111
mul_1x1    112
mul_1x1    113
mul_1x1    114
mul_1x1    115
mul_1x1    116
mul_1x1    117
mul_1x1    118
mul_1x1    119
mul_1x1    120
mul_1x1    121
mul_1x1    122
mul_1x1    123
mul_1x1    124
mul_1x1    125
mul_1x1    126
mul_1x1    127


#if SEC_LEVEL==2

mul_1x1    128
mul_1x1    129
mul_1x1    130
mul_1x1    131
mul_1x1    132
mul_1x1    133
mul_1x1    134
mul_1x1    135
mul_1x1    136
mul_1x1    137
mul_1x1    138
mul_1x1    139
mul_1x1    140
mul_1x1    141
mul_1x1    142
mul_1x1    143
mul_1x1    144
mul_1x1    145
mul_1x1    146
mul_1x1    147
mul_1x1    148
mul_1x1    149
mul_1x1    150
mul_1x1    151
mul_1x1    152
mul_1x1    153
mul_1x1    154
mul_1x1    155
mul_1x1    156
mul_1x1    157
mul_1x1    158
mul_1x1    159
mul_1x1    160
mul_1x1    161
mul_1x1    162
mul_1x1    163
mul_1x1    164
mul_1x1    165
mul_1x1    166
mul_1x1    167
mul_1x1    168
mul_1x1    169
mul_1x1    170
mul_1x1    171
mul_1x1    172
mul_1x1    173
mul_1x1    174
mul_1x1    175
mul_1x1    176
mul_1x1    177
mul_1x1    178
mul_1x1    179
mul_1x1    180
mul_1x1    181
mul_1x1    182
mul_1x1    183
mul_1x1    184
mul_1x1    185
mul_1x1    186
mul_1x1    187
mul_1x1    188
mul_1x1    189
mul_1x1    190
mul_1x1    191
mul_1x1    192
mul_1x1    193
mul_1x1    194
mul_1x1    195
mul_1x1    196
mul_1x1    197
mul_1x1    198
mul_1x1    199
mul_1x1    200
mul_1x1    201
mul_1x1    202
mul_1x1    203
mul_1x1    204
mul_1x1    205
mul_1x1    206
mul_1x1    207
mul_1x1    208
mul_1x1    209
mul_1x1    210
mul_1x1    211
mul_1x1    212
mul_1x1    213
mul_1x1    214
mul_1x1    215
mul_1x1    216
mul_1x1    217
mul_1x1    218
mul_1x1    219
mul_1x1    220
mul_1x1    221
mul_1x1    222
mul_1x1    223
mul_1x1    224
mul_1x1    225
mul_1x1    226
mul_1x1    227
mul_1x1    228
mul_1x1    229
mul_1x1    230
mul_1x1    231
mul_1x1    232
mul_1x1    233
mul_1x1    234
mul_1x1    235
mul_1x1    236
mul_1x1    237
mul_1x1    238
mul_1x1    239
mul_1x1    240
mul_1x1    241
mul_1x1    242
mul_1x1    243
mul_1x1    244
mul_1x1    245
mul_1x1    246
mul_1x1    247
mul_1x1    248
mul_1x1    249
mul_1x1    250
mul_1x1    251
mul_1x1    252
mul_1x1    253
mul_1x1    254
mul_1x1    255


#endif

ret
