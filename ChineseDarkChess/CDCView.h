//
//  CDCView.h
//  ChineseDarkChess
//
//  Created by Garrick on 2016/9/4.
//  Copyright © 2016年 Garrick. All rights reserved.
//
#import "CDCBoard.h"
#import <UIKit/UIKit.h>

@class CDCBoard;
@protocol CDCViewDelegate <NSObject>
- (CDCBoard *)viewDidRequestBoard:(UIView *)view;
@end
@interface CDCView : UIView

@property(weak) id<CDCViewDelegate> delegate;
@property(nonatomic, strong) NSMutableArray<UIImageView *> *imagesOfBoard;
- (CGRect)getRectWithPoint:(NSUInteger)square;
@end
