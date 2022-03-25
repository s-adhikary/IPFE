#ifndef _NEW_NTT
#define _NEW_NTT
void CT_forward(uint32_t a[SIFE_N],const uint32_t qdata[3], uint32_t* psidata);
void GS_reverse(uint32_t a[SIFE_N],const uint32_t qdata[3], uint32_t* psiinvdata);
#endif
