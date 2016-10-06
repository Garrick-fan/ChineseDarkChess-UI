//
//  BoardView.h
//  ChineseDarkChess
//
//  Created by Garrick on 2016/10/2.
//  Copyright © 2016年 Garrick. All rights reserved.
//
#import "CDCBoard.h"
#import <UIKit/UIKit.h>

typedef enum _FRAME_COLOR {
    FRAME_COLOR_RED = 0,
    FRAME_COLOR_BLK,
    FRAME_COLOR_YELLOW
} FRAME_COLOR;

@class CDCBoard;
@protocol BoardViewDelegate <NSObject>
- (CDCBoard *)viewDidRequestBoard:(UIView *)view;
@end

@interface BoardView : UIImageView

@property(weak) id<BoardViewDelegate> delegate;
@property(nonatomic, strong) NSMutableArray<UIImageView *> *imagesOfBoard;

- (CGRect)getRectWithPoint:(NSUInteger)square;
- (void)changePieceImageToTop:(NSInteger)position;
- (void)movePieceImage:(UIImageView *)image point:(CGPoint)point;
- (void)drawImageOfPieceFrame:(NSInteger)position color:(FRAME_COLOR)color;

@end

 
