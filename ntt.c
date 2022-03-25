#include <stdio.h>
#include <stdint.h>
#include "params.h"
#include "ntt.h"
#include "NTT.h"
#include "arith_rns.h"
#include "consts.h"
#include <immintrin.h>

void poly_mul_ntt(uint32_t a[SIFE_N], uint32_t b[SIFE_N],uint32_t c[SIFE_N], uint32_t sel){

	uint32_t i;
	__attribute__((aligned(32)))
	uint32_t a_t[SIFE_N], b_t[SIFE_N];

	for( i=0 ; i < SIFE_N ; i++ ){
		a_t[i]=a[i];
		b_t[i]=b[i];
	}

	CT_forward(a_t, qdata[sel], psidata[sel]);
	CT_forward(b_t, qdata[sel], psidata[sel]);
	point_mul_(a_t, b_t, c, qdata[sel]);
	GS_reverse(c, qdata[sel], psiinvdata[sel]);
}

void point_mul(uint32_t a[SIFE_N], uint32_t b[SIFE_N], uint32_t c[SIFE_N], uint32_t sel){
		
		uint64_t i;
		for( i=0 ; i < SIFE_N ; i++ ) {
			c[i]=mod_prime((uint64_t)a[i]*b[i], sel);
		}
		
}

