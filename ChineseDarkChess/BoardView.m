//
//  BoardView.m
//  ChineseDarkChess
//
//  Created by Garrick on 2016/10/2.
//  Copyright © 2016年 Garrick. All rights reserved.
//

#import "BoardView.h"

@implementation BoardView

static CGFloat kWidthOfSquare;

-(void)awakeFromNib{
    [super awakeFromNib];
    self.imagesOfBoard = [NSMutableArray arrayWithCapacity:BOARD_SIZE];
    NSLog(@"%@ %f",NSStringFromCGRect(self.frame),  (self.frame.size.width) / 4);
    kWidthOfSquare = (self.frame.size.width) / 4;
    
    assert(kWidthOfSquare == (self.frame.size.height) / 8);
}

- (void)setNeedsDisplay{
    [self removeSubviews];
    [self drawBoard];
}

- (void)removeSubviews {
    for (UIImageView *view in self.subviews)
        [view removeFromSuperview];
}

- (void)drawBoard {
    [self drawImageOfPiece];
}

- (void)drawImageOfPiece {
    NSInteger *board = [[self.delegate viewDidRequestBoard:self] board];
    if(board == NULL) return;
    for (NSInteger p = 0; p < BOARD_SIZE; ++p) {
        if(board[p] == FIN_E) continue;
        NSString *pieceName = @(PIECE_ID[board[p]]);
        UIImage *image = [UIImage imageNamed:pieceName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = [self getRectWithPoint:p];
        [_imagesOfBoard setObject:imageView atIndexedSubscript:p];
        [self addSubview:imageView];
    }
    MOVE *move = [[self.delegate viewDidRequestBoard:self] getHistoryTail];
    if(move != NULL) [self drawImageOfPieceFrame:move.dst color:FRAME_COLOR_RED];
}

-(void) drawValiedMoveOfFrameWithPosition:(NSInteger)position{
    MOVLST lst ;
    NSInteger cnt = [[self.delegate viewDidRequestBoard:self] genMove:lst];
    for(NSInteger i = 0; i < cnt; ++i){
        if(lst[i]>>5 == position){
            [self drawImageOfPieceFrame:lst[i]&31 color:FRAME_COLOR_YELLOW];
        }
    }
}

-(void) drawImageOfPieceFrame:(NSInteger)position color:(FRAME_COLOR)color{
    NSString *pieceName ;
    switch(color){
        case FRAME_COLOR_RED:
            pieceName = @("FRAME_RED");
            break;
        case FRAME_COLOR_BLK:
            pieceName = @("FRAME_BLACK");
            break;
        case FRAME_COLOR_YELLOW:
            pieceName = @("FRAME_BLUE");
            break;
    }
    UIImage *image = [UIImage imageNamed:pieceName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = [self getRectWithFrame:position];
    [self addSubview:imageView];
    
    if(color == FRAME_COLOR_BLK)
        [self drawValiedMoveOfFrameWithPosition:position];
}

- (void)changePieceImageToTop:(NSInteger)position {
    [self addSubview:_imagesOfBoard[position]];
}

- (void)movePieceImage:(UIImageView *)image point:(CGPoint)point {
    CGRect rect = CGRectMake(point.x - kWidthOfSquare / 2,
                             point.y - kWidthOfSquare / 2,
                             kWidthOfSquare,
                             kWidthOfSquare);
    [image setFrame:rect]; 
}

- (CGRect)getRectWithPoint:(NSUInteger)square {
    float startX = [self convertToPoint:square % 4];
    float startY = [self convertToPoint:square / 4];
    return CGRectMake(startX+5, startY+5, kWidthOfSquare-10,  kWidthOfSquare-10);
}

- (CGRect)getRectWithFrame:(NSUInteger)square {
    float startX = [self convertToPoint:square % 4];
    float startY = [self convertToPoint:square / 4];
    return CGRectMake(startX+2, startY+2, kWidthOfSquare-4,  kWidthOfSquare-4);
}

- (float)convertToPoint:(NSInteger)num {
    return num * ( kWidthOfSquare);
}
@end

