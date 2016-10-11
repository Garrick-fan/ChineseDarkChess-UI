//
//  CDCBoard.h
//  ChineseDarkChess
//
//  Created by Garrick on 2016/9/4.
//  Copyright © 2016年 Garrick. All rights reserved.
//
#import "basic.h"
#import "Move.h"
#import <Foundation/Foundation.h>

typedef enum _PIECE_STATUS {
    PIECE_STATUS_CLOSE = 0,
    PIECE_STATUS_OPEN,
    PIECE_STATUS_DIED
} PIECE_STATUS;
typedef PIECE_STATUS PCEStatue;

@interface CDCBoard : NSObject

@property NSInteger *board;
@property NSInteger *darkcnt;
@property NSInteger *lifecnt;
@property NSInteger  darksum;
@property NSInteger  color;
@property NSInteger  ply;
@property PCEStatue *pieceState;
 
@property(nonatomic, strong) NSMutableArray<MOVE*> *history;

- (void)move:(NSInteger)src dst:(NSInteger)dst;
- (void)flip:(NSInteger)position piece:(NSInteger)piece;
- (bool)isDark:(NSInteger)position;
- (bool)isValiedMove:(NSInteger)src dst:(NSInteger)dst;
- (bool)isValiedPosition:(NSInteger)position;
- (NSInteger)genMove:(MOVLST)movelst;
- (MOVE*)getHistoryTail;
- (PCEStatue*)getPieceStateByColor:(NSInteger)color;
- (void)undoHistoryWithPly:(NSInteger)ply;
@end


