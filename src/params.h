#ifndef PARAMS_H
#define PARAMS_H

#include "seclevel.h"

#if SEC_LEVEL == 0

static const char SIFE_Q_str[] = "55263697518192234497" ;
#define SIFE_LOGQ_BYTE 66
#define SIFE_NMODULI 3
static const uint64_t SIFE_CRT_CONSTS[SIFE_NMODULI]={0,8109685,43830338};
static const uint32_t SIFE_MOD_Q_I[SIFE_NMODULI] = {12289,8380417,536608769};
static const uint32_t SIFE_MOD_QINV_I[SIFE_NMODULI] ={150982657,58728449,3758358529};
static const uint32_t INT64_MOD_Q[SIFE_NMODULI] = {5664,2365951,504094781};
#define SIFE_B_x 2
#define SIFE_B_y 2
#define SIFE_L 64
#define SIFE_N 2048
#define HSIFE_N 1024
#define SIFE_SIGMA 1
#define SIFE_P (SIFE_B*SIFE_B*SIFE_L + 1)
static const char SIFE_P_str[] = "257";
static const char SIFE_SCALE_M_str[]="215033842483238266";
static const uint64_t SIFE_SCALE_M_MOD_Q_I[SIFE_NMODULI] = {908,3358688,298579976};
extern uint32_t qdata[SIFE_NMODULI][4];
extern uint32_t psidata[SIFE_NMODULI][3360];
extern uint32_t psiinvdata[SIFE_NMODULI][3360];
extern uint32_t psisqrdata[SIFE_NMODULI][HSIFE_N];

#elif SEC_LEVEL == 1

static const char SIFE_Q_str[] = "76687145727357674227351553" ;
#define SIFE_LOGQ_BYTE 86
#define SIFE_NMODULI 3
static const uint64_t SIFE_CRT_CONSTS[SIFE_NMODULI]={0,206923011,519246547};
static const uint32_t SIFE_MOD_Q_I[SIFE_NMODULI] = {16760833,2147352577,2130706433};
static const uint32_t SIFE_MOD_QINV_I[SIFE_NMODULI] ={251674625,2147614721,2164260865};
static const uint32_t INT64_MOD_Q[SIFE_NMODULI] = {13696128,3145700,402124772};
#define SIFE_B_x 4
#define SIFE_B_y 16
#define SIFE_L 785
#define SIFE_N 4096
#define HSIFE_N 2048
#define SIFE_SIGMA 1
#define SIFE_P (SIFE_B*SIFE_B*SIFE_L + 1)
static const char SIFE_P_str[] = "50241";
static const char SIFE_SCALE_M_str[]="1526385735302993058007";
static const uint64_t SIFE_SCALE_M_MOD_Q_I[SIFE_NMODULI] = {13798054,441557681,1912932552};
extern uint32_t qdata[SIFE_NMODULI][4];
extern uint32_t psidata[SIFE_NMODULI][6720];
extern uint32_t psiinvdata[SIFE_NMODULI][6720];

#elif SEC_LEVEL == 2

static const char SIFE_Q_str[] = "1754355525517819351530774970369" ;
#define SIFE_LOGQ_BYTE 101
#define SIFE_NMODULI 4
static const uint64_t SIFE_CRT_CONSTS[SIFE_NMODULI]={0,619320,443524396,1270195090};
static const uint32_t SIFE_MOD_Q_I[SIFE_NMODULI] = {786433,1032193,1073479681,2013265921};
static const uint32_t SIFE_MOD_QINV_I[SIFE_NMODULI] ={4294180865,267403265,3221487617,2281701377};
static const uint32_t INT64_MOD_Q[SIFE_NMODULI] = {378615,765937,260045840,1172168163};
#define SIFE_B_x 32
#define SIFE_B_y 32
#define SIFE_L 1024
#define SIFE_N 8192
#define HSIFE_N 4096
#define SIFE_SIGMA 1
#define SIFE_P (SIFE_B*SIFE_B*SIFE_L + 1)
static const char SIFE_P_str[] = "1048577";
static const char SIFE_SCALE_M_str[]="1673082210956200023012878";
static const uint64_t SIFE_SCALE_M_MOD_Q_I[SIFE_NMODULI] = {400856,160437,532538886,2003427850};
extern uint32_t qdata[SIFE_NMODULI][4];
extern uint32_t psidata[SIFE_NMODULI][13440];
extern uint32_t psiinvdata[SIFE_NMODULI][13440];

#endif

#endif


