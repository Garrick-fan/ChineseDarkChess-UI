//
//  basic.h
//  ChineseDarkChess
//
//  Created by Garrick on 2016/9/4.
//  Copyright © 2016年 Garrick. All rights reserved.
//

#ifndef _BASIC_H_
#define _BASIC_H_
typedef unsigned int bool;
typedef unsigned int U32;
typedef unsigned long long U64;

typedef int CLR;
typedef int FIN;
typedef int POS;
typedef int MOV;

typedef MOV MOVLST[71];

extern const int CNT[];
extern const char *PIECE_ID[];

static const int INVALIED = -1;
static const int BOARD_SIZE = 32;
static const int PIECE_SIZE = 16;

static const CLR CLR_R = 0;
static const CLR CLR_B = 1;
static const CLR CLR_U = 2;

static const FIN FIN_K = 0;
static const FIN FIN_k = 1;
static const FIN FIN_G = 2;
static const FIN FIN_g = 3;
static const FIN FIN_M = 4;
static const FIN FIN_m = 5;
static const FIN FIN_R = 6;
static const FIN FIN_r = 7;
static const FIN FIN_N = 8;
static const FIN FIN_n = 9;
static const FIN FIN_C = 10;
static const FIN FIN_c = 11;
static const FIN FIN_P = 12;
static const FIN FIN_p = 13;
static const FIN FIN_X = 14;
static const FIN FIN_E = 15;

CLR GetColor(FIN f);
int GenerateMove(int *board, int clr, MOVLST lst);
bool ValiedMove(int *board_, int clr, POS src, POS dst);
#endif
