//
//  ChessView.h
//  ChineseDarkChess
//
//  Created by Garrick on 2016/10/5.
//  Copyright © 2016年 Garrick. All rights reserved.
//

#import "CDCBoard.h"
#import <UIKit/UIKit.h>

@class CDCBoard;
@protocol BoardViewDelegate <NSObject>
- (CDCBoard *)viewDidRequestBoard:(UIView *)view;
@end


@interface PieceStatusView : UIImageView

@property NSInteger color;
@property(weak) id<BoardViewDelegate> delegate;

-(void)initWithColor:(NSInteger)color;

@end
