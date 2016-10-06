//
//  Move.h
//  ChineseDarkChess
//
//  Created by Garrick on 2016/10/6.
//  Copyright © 2016年 Garrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Move;
typedef Move MOVE;

@interface Move : NSObject
@property NSInteger src;
@property NSInteger dst;
@property NSInteger pce;
- (instancetype)init:(NSInteger)src dst:(NSInteger)dst pce:(NSInteger)pce;
@end


