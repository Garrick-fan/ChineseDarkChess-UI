//
//  ViewController.m
//  ChineseDarkChess
//
//  Created by Garrick on 2016/9/3.
//  Copyright © 2016年 Garrick. All rights reserved.
//

#import "ViewController.h"
@interface ViewController () <CDCViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self initBoard];
  [self initCDCView];

  UITapGestureRecognizer *tapRecognizerSingleClick =
      [[UITapGestureRecognizer alloc]
          initWithTarget:self
                  action:@selector(handleSingleClick:)];
  tapRecognizerSingleClick.numberOfTapsRequired = 1;
  [self.view addGestureRecognizer:tapRecognizerSingleClick];

  UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(handlePanRecognier:)];
  [panRecognizer setMinimumNumberOfTouches:1];
  [panRecognizer setMaximumNumberOfTouches:1];
  [self.cdcView addGestureRecognizer:panRecognizer];
}

- (void)handlePanRecognier:(UIPanGestureRecognizer *)sender {
  static NSInteger positionBegin;
  CGPoint point = [sender locationInView:sender.view];
  if (sender.state == UIGestureRecognizerStateBegan) {
    positionBegin = [self getPositionByPoint:point];
  } else if (sender.state == UIGestureRecognizerStateChanged) {
    // todo: pan animate?
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    NSInteger positionEnd = [self getPositionByPoint:point];
    if ([_cdcBoard isValiedMove:positionBegin dst:positionEnd]) {
      [_cdcBoard move:positionBegin dst:positionEnd];
    }
    positionBegin = INVALIED;
    [_cdcView setNeedsDisplay];
  }
}

- (void)initBoard {
  _cdcBoard = [[CDCBoard alloc] init];
}

- (void)initCDCView {
  _cdcView = [[CDCView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  _cdcView.delegate = self;
  [self.view addSubview:_cdcView];
  [_cdcView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)handleSingleClick:(UITapGestureRecognizer *)sender {
  static NSInteger src = INVALIED;
  static NSInteger dst = INVALIED;
  if (sender.state == UIGestureRecognizerStateRecognized) {
    CGPoint point = [sender locationInView:sender.view];
    NSInteger pos = [self getPositionByPoint:point];
    if (src == INVALIED) {
      src = pos;
    } else {
      dst = pos;
      if ([_cdcBoard isDark:pos] && src == dst) {
        [_cdcBoard flip:pos piece:[self randPiece]];
      } else {
        if ([_cdcBoard isValiedMove:src dst:dst])
          [_cdcBoard move:src dst:dst];
      }
      src = dst = INVALIED;
    }
    [_cdcView setNeedsDisplay];
  }
}

- (NSInteger)getPositionByPoint:(CGPoint)point {
  NSInteger piece = INVALIED;
  for (piece = 0; piece < BOARD_SIZE; ++piece) {
    CGRect rect = [_cdcView getRectWithPoint:piece];
    if (CGRectContainsPoint(rect, point))
      return piece;
  }
  return INVALIED;
}

- (NSInteger)randPiece {
  NSInteger tmp = arc4random() % _cdcBoard.darksum;
  NSInteger piece = INVALIED;
  for (piece = 0; piece < PIECE_SIZE; ++piece)
    if ((tmp -= _cdcBoard.darkcnt[piece]) < 0)
      break;
  return piece;
}

- (CDCBoard *)viewDidRequestBoard:(UIView *)view {
  return _cdcBoard;
}

@end
