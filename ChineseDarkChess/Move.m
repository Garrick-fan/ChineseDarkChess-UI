//
//  Move.m
//  ChineseDarkChess
//
//  Created by Garrick on 2016/10/6.
//  Copyright © 2016年 Garrick. All rights reserved.
//

#import "Move.h"
 
@implementation Move
- (instancetype)init:(NSInteger)src dst:(NSInteger)dst pce:(NSInteger)pce {
    self = [self init];
    if (self) {
        self.src = src;
        self.dst = dst;
        self.pce = pce;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[Move class]]) {
        Move *move = object;
        return self.src == move.src && self.dst == move.dst && self.pce == move.pce;
    }
    else {
        return NO;
    }
}
@end
