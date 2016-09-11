//
//  CDCBoard.h
//  ChineseDarkChess
//
//  Created by Garrick on 2016/9/4.
//  Copyright © 2016年 Garrick. All rights reserved.
//
#import "basic.h"
#import <Foundation/Foundation.h>

@interface CDCBoard : NSObject

@property NSInteger *board;
@property NSInteger *darkcnt;
@property NSInteger darksum;
@property NSInteger color;

- (void)move:(NSInteger)src dst:(NSInteger)dst;
- (void)flip:(NSInteger)position piece:(NSInteger)piece;
- (bool)isDark:(NSInteger)position;
- (bool)isValiedMove:(NSInteger)src dst:(NSInteger)dst;
- (NSInteger)genMove:(MOVLST)movelst;
@end
