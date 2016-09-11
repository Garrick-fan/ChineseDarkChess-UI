//
//  CDCBoard.m
//  ChineseDarkChess
//
//  Created by Garrick on 2016/9/4.
//  Copyright © 2016年 Garrick. All rights reserved.
//
#import "CDCBoard.h"

@implementation CDCBoard

- (instancetype)init {
  self = [super init];
  if (self) {
    _board = (NSInteger *)malloc(sizeof(NSInteger) * BOARD_SIZE);
    _darkcnt = (NSInteger *)malloc(sizeof(NSInteger) * PIECE_SIZE);
  }
  for (NSInteger i = 0; i < BOARD_SIZE; ++i)
    _board[i] = FIN_X;
  for (NSInteger i = 0; i < PIECE_SIZE; ++i)
    _darkcnt[i] = CNT[i];
  _darksum = BOARD_SIZE;
  _color = CLR_U;
  return self;
}

- (void)move:(NSInteger)src dst:(NSInteger)dst {
  _board[dst] = _board[src];
  _board[src] = FIN_E;
  _color ^= 1;
}

- (void)flip:(NSInteger)position piece:(NSInteger)piece {
  if (_darksum == BOARD_SIZE)
    _color = GetColor((int)piece);
  _board[position] = piece;
  --_darkcnt[piece];
  --_darksum;
  _color ^= 1;
}

- (bool)isDark:(NSInteger)position {
  return _board[position] == FIN_X;
}

- (bool)isValiedMove:(NSInteger)src dst:(NSInteger)dst {
  return ValiedMove(_board, _color, src, dst);
}

- (NSInteger)genMove:(MOVLST)movelst {
  return GenerateMove(_board, _color, movelst);
}

@end
