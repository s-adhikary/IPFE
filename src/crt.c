#include <stdint.h>
#include "params.h"
#include "arith_rns.h"
#include "crt.h"

void
crt_convert
(const int32_t a[SIFE_N], uint32_t a_crt[SIFE_NMODULI][SIFE_N])
{
	int i, j;
	
	#pragma omp for collapse(2) schedule(static)
	for (j = 0; j < SIFE_NMODULI; ++j) {
		for (i = 0; i < SIFE_N; ++i) {
			a_crt[j][i] = mod_prime((int64_t)a[i] + SIFE_MOD_Q_I[j], j);
		}
	}
}

void
crt_convert_gmp
(const mpz_t a[SIFE_N], uint32_t a_crt[SIFE_NMODULI][SIFE_N])
{
	int i, j;
	
	#pragma omp for collapse(2) schedule(static)
	for (j = 0; j < SIFE_NMODULI; ++j) {
		for (i = 0; i < SIFE_N; ++i) {
			a_crt[j][i]= mpz_fdiv_ui(a[i], SIFE_MOD_Q_I[j]);

		}
	}
}

void
crt_convert_generic
(const int32_t a[SIFE_L], uint32_t a_crt[SIFE_NMODULI][SIFE_L], const int len)//fix. len not needed
{
	int i, j;

	#pragma omp for collapse(2) schedule(static)
	for (j = 0; j < SIFE_NMODULI; ++j) {
		for (i = 0; i < len; ++i) {
			a_crt[j][i] = mod_prime((int64_t)a[i] + SIFE_MOD_Q_I[j], j);
		}
	}
}

void
crt_reverse_gmp
(mpz_t a[SIFE_N], const uint32_t split_a[SIFE_NMODULI][SIFE_N])
{
	
		uint64_t i,j,k;
		mpz_t gmp_u, gmp_c, gmp_x;

		mpz_init(gmp_u);
		mpz_init(gmp_c);
		mpz_init(gmp_x);

		#pragma omp for schedule(static) nowait
		for (k = 0; k < SIFE_N; k++) {
			mpz_set_ui(gmp_u, split_a[0][k]);
			mpz_set(gmp_x, gmp_u);
			for (i = 1; i <= SIFE_NMODULI-1; i++) {
				mpz_set_ui(gmp_c, split_a[i][k]);	//c=vi
				mpz_sub(gmp_u, gmp_c, gmp_x);	//vi-x
				mpz_mul_ui(gmp_u, gmp_u, SIFE_CRT_CONSTS[i]);//(vi-x)Ci
				mpz_mod_ui(gmp_u, gmp_u, SIFE_MOD_Q_I[i]);//(vi-x)Ci mod mi
				mpz_set_str(gmp_c, "1", 10);
				for(j = 0; j <= i-1; j++) {
					//mpz_mul(gmp_c, gmp_c, gmp_q_ar[j]);
					mpz_mul_ui(gmp_c, gmp_c, SIFE_MOD_Q_I[j]);
				} 
				mpz_mul( gmp_u, gmp_u, gmp_c );
				mpz_add(gmp_x, gmp_x, gmp_u);				
			}
			mpz_set(a[k],gmp_x);
		}

		mpz_clear(gmp_u);
		mpz_clear(gmp_c);
		mpz_clear(gmp_x);

}
