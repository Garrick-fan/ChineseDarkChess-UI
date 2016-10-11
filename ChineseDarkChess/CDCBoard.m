//
//  CDCBoard.m
//  ChineseDarkChess
//
//  Created by Garrick on 2016/9/4.
//  Copyright © 2016年 Garrick. All rights reserved.
//
#import "CDCBoard.h"

@implementation CDCBoard
static bool isUndo = false;
static NSInteger undoPly = 0;
- (instancetype)init {
    self = [super init];
    if (self) {
        _board      = (NSInteger *)malloc(sizeof(NSInteger) * BOARD_SIZE);
        _darkcnt    = (NSInteger *)malloc(sizeof(NSInteger) * PIECE_SIZE);
        _lifecnt    = (NSInteger *)malloc(sizeof(NSInteger) * PIECE_SIZE);
        _pieceState = (PCEStatue *)malloc(sizeof(PCEStatue*) * BOARD_SIZE);
        _history    = [[NSMutableArray alloc] init];
        memset(_pieceState, 0, sizeof(PCEStatue) * BOARD_SIZE);
        _ply = 0;
    }
    for (NSInteger i = 0; i < BOARD_SIZE; ++i)
        _board[i] = FIN_X;
    for (NSInteger i = 0; i < PIECE_SIZE; ++i)
        _lifecnt[i] = _darkcnt[i] = CNT[i];
    
    _darksum = BOARD_SIZE;
    _color = CLR_U;
    return self;
}

- (void) initGame {
    memset(_pieceState, 0, sizeof(PCEStatue) * BOARD_SIZE);
    for (NSInteger i = 0; i < BOARD_SIZE; ++i)
        _board[i] = FIN_X;
    for (NSInteger i = 0; i < PIECE_SIZE; ++i)
        _lifecnt[i] = _darkcnt[i] = CNT[i];
    _darksum = BOARD_SIZE;
    _color = CLR_U;
    _ply = 0;
}

- (NSInteger)genMove:(MOVLST)movelst {
    return GenerateMove(_board, _color, movelst);
}

- (void)undoHistoryWithPly:(NSInteger)ply{
    isUndo = true;
    undoPly = _history.count < ply ? _history.count : ply;
    [self initGame];
    for(NSInteger i = 0; i < undoPly; ++i){
        MOVE *move = [self getHistory:i];
        if(move.src == move.dst)
            [self flip:move.src piece:move.pce];
        else
            [self move:move.src dst:move.dst];
    }
}

-(void)insertHistory:(NSInteger)src dst:(NSInteger)dst pce:(NSInteger)pce{
    MOVE *move = [[MOVE alloc] init:src dst:dst pce:pce];
    if(_history.count > _ply && [[_history objectAtIndex:_ply] isEqual:move]){ return;
    }else if(_history.count > _ply){
        while(_history.count > _ply) [_history removeLastObject];
    }
    [_history addObject:move];
}

-(MOVE*)getHistory:(NSInteger)index{
    return [_history objectAtIndex:index];
}

-(MOVE*)getHistoryTail{
    return [_history lastObject];
}

-(PCEStatue*)getPieceStateByColor:(NSInteger) color{
    return &_pieceState[color*PIECE_SIZE];
}

- (void)initPieceState:(NSInteger)srcPce dst:(NSInteger)dstPce {
    static int  index[7] = {0};
    static bool isInit = false;
    if(!isInit){
        index[0] = 0;
        for(int i = 1; i < 7; ++i)
            index[i] = index[i-1] + CNT[(i-1)<<1];
        isInit = true;
    }
    
    int color = GetColor(dstPce);
    int start = color*PIECE_SIZE+index[dstPce>>1];
    if(srcPce == dstPce){
        for(int i = 0; i < CNT[dstPce]; ++i  ){
            if(_pieceState[start+i] == PIECE_STATUS_CLOSE){
                _pieceState[start+i] = PIECE_STATUS_OPEN;
                return;
            }
        }
    }else{
        for(int i = 0; i < CNT[dstPce]; ++i){
            if(_pieceState[start+i] == PIECE_STATUS_OPEN){
                _pieceState[start+i] = PIECE_STATUS_DIED;
                return;
            }
        }
    }
    assert(false);
}

- (void)move:(NSInteger)src dst:(NSInteger)dst {
    [self insertHistory:src dst:dst pce:INVALIED];
    if (_board[dst] != FIN_E)
        [self initPieceState:_board[src] dst:_board[dst]];
    _board[dst] = _board[src];
    _board[src] = FIN_E;
    _color ^= 1;
    ++_ply;
}

- (void)flip:(NSInteger)position piece:(NSInteger)piece {
    [self initPieceState:piece dst:piece];
    [self insertHistory:position dst:position pce:piece];
    if (_darksum == BOARD_SIZE)
        _color = GetColor((int)piece);
    _board[position] = piece;
    --_darkcnt[piece];
    --_darksum;
    _color ^= 1;
    ++_ply;
}

- (bool)isDark:(NSInteger)position {
    return _board[position] == FIN_X;
}

- (bool)isMyPiece:(NSInteger)position {
    return GetColor(_board[position]) == _color;
}

-(bool)isValiedPosition:(NSInteger)position{
    if([self isDark:position] || [self isMyPiece:position]) return true;
    return false;
}

- (bool)isValiedMove:(NSInteger)src dst:(NSInteger)dst {
    return ValiedMove(_board, _color, src, dst);
}

@end

