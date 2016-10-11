//
//  ViewController.m
//  ChineseDarkChess
//
//  Created by Garrick on 2016/9/3.
//  Copyright © 2016年 Garrick. All rights reserved.
//

#import "ViewController.h"
@interface ViewController () <BoardViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initBoard];
    [self initCDCView];
    [self initChessView];
    [self initTapRecognier];
    [self initPanRecognier];
    
    [_sliderHistory addTarget:self
                       action:@selector(sliderValueChanged:)
             forControlEvents:UIControlEventValueChanged];

    [_sliderHistory setMinimumValue:0];
    [_sliderHistory setMaximumValue:0];
    //[_sliderHistory setContinuous:false];
}

- (void) initTapRecognier{
    UITapGestureRecognizer *tapRecognizerSingleClick =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handleSingleClick:)];
    tapRecognizerSingleClick.numberOfTapsRequired = 1;
    [self.boardView addGestureRecognizer:tapRecognizerSingleClick];
}

- (void) initPanRecognier{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(handlePanRecognier:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self.boardView addGestureRecognizer:panRecognizer];
}

- (void)handlePanRecognier:(UIPanGestureRecognizer *)sender {
    static NSInteger positionBegin = INVALIED;
    static UIImageView *selectedImage;
    CGPoint point = [sender locationInView:sender.view];
    if (sender.state == UIGestureRecognizerStateBegan) {
        positionBegin = [self getValiedPositionByPoint:point];
        if (positionBegin != INVALIED && ![_cdcBoard isDark:positionBegin]) {
            selectedImage = _boardView.imagesOfBoard[positionBegin];
            [_boardView drawImageOfPieceFrame:positionBegin color:FRAME_COLOR_BLK];
            [_boardView changePieceImageToTop:positionBegin];
        } else
            positionBegin = INVALIED;
    } else if (positionBegin != INVALIED) {
        if (sender.state == UIGestureRecognizerStateChanged) {
            [_boardView movePieceImage:selectedImage point:point];
        } else if (sender.state == UIGestureRecognizerStateEnded) {
            NSInteger positionEnd = [self getPositionByPoint:point];
            if ([_cdcBoard isValiedMove:positionBegin dst:positionEnd])
                [_cdcBoard move:positionBegin dst:positionEnd];
            [_boardView setNeedsDisplay];
            positionBegin = INVALIED;
        }
    }
}

- (void)initBoard {
    _cdcBoard = [[CDCBoard alloc] init];
}

- (void)initCDCView {
    _boardView.delegate = self;
    _boardView.userInteractionEnabled = YES;
    [self.view addSubview:_boardView];
    [_boardView setNeedsDisplay];
}

- (void)initChessView {
    _redPieceStatusView.delegate = self;
    [_redPieceStatusView initWithColor:CLR_R];
    _blkPieceStatusView.delegate = self;
    [_blkPieceStatusView initWithColor:CLR_B];
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
        NSInteger pos = INVALIED;
        if (src == INVALIED) {
            src = pos = [self getValiedPositionByPoint:point];;
        } else {
            dst = pos =  [self getPositionByPoint:point];;
            if ([_cdcBoard isDark:pos] && src == dst) {
                [_cdcBoard flip:pos piece:[self randPiece]];
            } else {
                if ([_cdcBoard isValiedMove:src dst:dst])
                    [_cdcBoard move:src dst:dst];
            }
            src = dst = INVALIED;
            [_sliderHistory setMaximumValue:_cdcBoard.history.count];
            [_sliderHistory setValue:_cdcBoard.history.count];
            [_redPieceStatusView setNeedsDisplay];
            [_blkPieceStatusView setNeedsDisplay];
            switch(_cdcBoard.color){
                case CLR_R:
                    _labelMessage.text = @("Red");
                    break;
                case CLR_B:
                    _labelMessage.text = @("Black");
                    break;
                case CLR_U:
                    _labelMessage.text = @("Unknow");
                    break;
            } 
        }
        [_boardView setNeedsDisplay];
        if(src != INVALIED) [_boardView drawImageOfPieceFrame:src color:FRAME_COLOR_BLK];
    }
}

- (NSInteger)getPositionByPoint:(CGPoint)point {
    NSInteger piece = INVALIED;
    for (piece = 0; piece < BOARD_SIZE; ++piece) {
        CGRect rect_relative = [_boardView getRectWithPoint:piece];
        if (CGRectContainsPoint(rect_relative, point))
            return piece;
    }
    return INVALIED;
}

-(NSInteger)getValiedPositionByPoint:(CGPoint)point{
    NSInteger position = [self getPositionByPoint:point];
    if([_cdcBoard isValiedPosition:position]) return position;
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

- (IBAction)sliderValueChanged:(UISlider *)sender {
    _sliderHistory.value = (int)sender.value;
    [_cdcBoard undoHistoryWithPly:_sliderHistory.value];
    [_boardView setNeedsDisplay];
    [_redPieceStatusView setNeedsDisplay];
    [_blkPieceStatusView setNeedsDisplay];
}

@end


