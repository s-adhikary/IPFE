#ifndef NTT_H
#define NTT_H

#include "params.h"

void CT_forward(uint32_t a[SIFE_N],const uint32_t qdata[4], uint32_t* psidata);

void GS_reverse(uint32_t a[SIFE_N],const uint32_t qdata[4], uint32_t* psiinvdata);

void point_mul(uint32_t a[SIFE_N], uint32_t b[SIFE_N], uint32_t c[SIFE_N], uint32_t * qdata);

void poly_mul_ntt(uint32_t a[SIFE_N], uint32_t b[SIFE_N],uint32_t c[SIFE_N], uint32_t sel);

#endif
