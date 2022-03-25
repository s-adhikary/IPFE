#ifndef PARAMS_H
#define PARAMS_H

#include "seclevel.h"

#if SEC_LEVEL==1

static const char SIFE_Q_str[] = "9654886946576654147239937" ;
#define SIFE_LOGQ_BYTE 83
#define SIFE_NMODULI 3
static const uint64_t SIFE_CRT_CONSTS[SIFE_NMODULI]={0,144633560,611295928};
static const uint32_t SIFE_MOD_Q_I[SIFE_NMODULI] = {16760833,536608769,1073479681};
static const uint32_t SIFE_MOD_QINV_I[SIFE_NMODULI] ={251674625,3758358529,3221487617};
static const uint32_t INT64_MOD_Q[SIFE_NMODULI] = {13696128,504094781,260045840};
#define SIFE_B_x 2
#define SIFE_B_y 2
#define SIFE_L 2048
#define SIFE_N 4096
#define HSIFE_N 2048
#define SIFE_SIGMA 1
#define SIFE_P (SIFE_B*SIFE_B*SIFE_L + 1)
static const char SIFE_P_str[] = "4097";
static const char SIFE_SCALE_M_str[]="192171472434399278422";
static const uint64_t SIFE_SCALE_M_MOD_Q_I[SIFE_NMODULI] = {908202, 101375442, 152493330};
extern uint32_t qdata[SIFE_NMODULI][4];
extern uint32_t psidata[SIFE_NMODULI][6720];
extern uint32_t psiinvdata[SIFE_NMODULI][6720];
extern uint32_t psisqrdata[SIFE_NMODULI][HSIFE_N];


#elif SEC_LEVEL==2

static const char SIFE_Q_str[] = "29141941557785951247351809";
#define SIFE_LOGQ_BYTE 85
#define SIFE_NMODULI 4
static const uint64_t SIFE_CRT_CONSTS[SIFE_NMODULI]= {0, 903170, 1362091, 26843455}; //{0, 2146953901, 8460412124};	//*
static const uint32_t SIFE_MOD_Q_I[SIFE_NMODULI] = {114689, 1032193, 7340033, 33538049}; //{2147352577, 2146959361 , 4293918721};//*
static const uint32_t SIFE_MOD_QINV_I[SIFE_NMODULI] ={268320769, 267403265, 4287627265, 234897409}; //{2147614721,2148007937,1048577};//*
static const uint32_t INT64_MOD_Q[SIFE_NMODULI] = {2484, 765937, 3338324, 671696}; //{3145700,264240644,266338049};//*
static const uint32_t SIFE_NTT_NINV[SIFE_NMODULI] = {114675, 1032067, 7339137, 33533955};
#define SIFE_B_x 2
#define SIFE_B_y 2
#define SIFE_L 2048
#define SIFE_N 8192
#define HSIFE_N 4096
#define SIFE_SIGMA 1
#define SIFE_P (SIFE_B_x*SIFE_B_y*SIFE_L + 1)
static const char SIFE_P_str[] = "4097"; // K
static const char SIFE_SCALE_M_str[]="7112995254524274163376";  // Q/K
static const uint64_t SIFE_SCALE_M_MOD_Q_I[SIFE_NMODULI]= {8146, 641184, 4249587, 14767547}; //{2126372117, 1592386324, 1319825431};	//*
extern uint32_t qdata[SIFE_NMODULI][4];
extern uint32_t psidata[SIFE_NMODULI][13440];
extern uint32_t psiinvdata[SIFE_NMODULI][13440];
extern uint32_t psisqrdata[SIFE_NMODULI][HSIFE_N];

#endif


#endif
