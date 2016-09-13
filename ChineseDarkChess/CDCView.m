//
//  CDCView.m
//  ChineseDarkChess
//
//  Created by Garrick on 2016/9/4.
//  Copyright © 2016年 Garrick. All rights reserved.
//

#import "CDCView.h"

@implementation CDCView

// static CGFloat kLengthOfCell;
static CGFloat kBorderWidth = 1;
static CGFloat kBorderWidthOut = 1;
static CGFloat kPaddingWidth = 60;
static CGFloat kWidthOfSquare;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  self.backgroundColor = [UIColor whiteColor];
  _imagesOfBoard = [NSMutableArray arrayWithCapacity:BOARD_SIZE];
  CGFloat width = (self.frame.size.width) * 0.6;
  kWidthOfSquare = (width - kBorderWidthOut * 2 - kBorderWidth * 3) / 4;
  return self;
}

- (void)drawRect:(CGRect)rect {
  [self removeSubviews];
  [self drawBoard];
}

- (void)removeSubviews {
  for (UIView *view in self.subviews) {
    [view removeFromSuperview];
  }
}

- (void)drawBoard {
  [self drawImageOfBoard];
  [self drawImageOfPiece];
}

- (void)drawImageOfBoard {
  CGFloat width = (self.frame.size.width) * 0.6;
  CGFloat height = width * 2;
  UIImage *image = [UIImage imageNamed:@"Board"];
  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
  imageView.frame = CGRectMake(kPaddingWidth, kPaddingWidth, width, height);
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  [self addSubview:imageView];
}

- (void)drawImageOfPiece {
  NSInteger *board = [[self.delegate viewDidRequestBoard:self] board];
  for (NSInteger p = 0; p < BOARD_SIZE; ++p) {
    CGRect rect = [self getRectWithPoint:p];
    NSString *pieceName = [NSString stringWithFormat:@"%s", PIECE_ID[board[p]]];
    UIImage *image = [UIImage imageNamed:pieceName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = rect;
    [_imagesOfBoard setObject:imageView atIndexedSubscript:p];
    [self addSubview:imageView];
  }
}

- (void)changePieceImageToTop:(NSInteger)position {
  [self addSubview:_imagesOfBoard[position]];
}

- (void)movePieceImage:(UIImageView *)image point:(CGPoint)point {
  CGRect rect =
      CGRectMake(point.x - kWidthOfSquare / 2, point.y - kWidthOfSquare / 2,
                 kWidthOfSquare, kWidthOfSquare);
  [image setFrame:rect];
}

- (CGRect)getRectWithPoint:(NSUInteger)square {
  float startX = [self convertToPoint:square % 4];
  float startY = [self convertToPoint:square / 4];
  return CGRectMake(kPaddingWidth + kBorderWidthOut + startX,
                    kPaddingWidth + kBorderWidthOut + startY, kWidthOfSquare,
                    kWidthOfSquare);
}

- (float)convertToPoint:(NSInteger)num {
  return num * (kBorderWidth + kWidthOfSquare);
}
@end
