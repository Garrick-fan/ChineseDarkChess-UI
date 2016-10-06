//
//  ChessView.m
//  ChineseDarkChess
//
//  Created by Garrick on 2016/10/5.
//  Copyright © 2016年 Garrick. All rights reserved.
//

#import "PieceStatusView.h"

@implementation PieceStatusView

static CGFloat kWidthOfBorder = 2;
static CGFloat kWidthOfSquare;
static CGFloat kBeginXOfDrawing;
static CGFloat kBeginYOfDrawing;

-(void)awakeFromNib{
    [super awakeFromNib];
    kWidthOfSquare  = MIN(self.frame.size.width / 2, self.frame.size.height / 9);
    kBeginYOfDrawing = (self.frame.size.height - kWidthOfSquare * 9) / 2;
    kBeginXOfDrawing  = (self.frame.size.width - kWidthOfSquare) / 2;
}

-(void)initWithColor:(NSInteger)color{
    self.color = color;
    [self drawStatePiece];
}

- (void)setNeedsDisplay{
    [self removeSubviews];
    [self drawStatePiece];
}

- (void)removeSubviews {
    for (UIImageView *view in self.subviews)
        [view removeFromSuperview];
}

- (void)drawStatePiece{
    PCEStatue* statePiece = [[self.delegate viewDidRequestBoard:self] getPieceStateByColor:_color];
    if(statePiece == NULL) return ;
    static const int mapToPieceID[] = {
        FIN_K, FIN_G, FIN_G, FIN_M, FIN_M, FIN_R, FIN_R, FIN_N,
        FIN_N, FIN_C, FIN_C, FIN_P, FIN_P, FIN_P, FIN_P, FIN_P
    };
    for(int i = 0; i < PIECE_SIZE; ++i){
        NSInteger ID = (int)(mapToPieceID[i]|_color);
        switch(statePiece[i]){
            case PIECE_STATUS_CLOSE:
                [self drawPiece:@(PIECE_ID[ID]) position:i alpha:1];
                [self drawPiece:@("T") position:i alpha:0.8];
                break;
            case PIECE_STATUS_OPEN:
                [self drawPiece:@(PIECE_ID[ID]) position:i alpha:1];
                break;
            case PIECE_STATUS_DIED:
                [self drawPiece:@("C1") position:i alpha:1];
                break;
        }
    }
}

-(void)drawPiece:(NSString*)pieceName position:(NSInteger)position alpha:(CGFloat)alpha {
    UIImage *image = [UIImage imageNamed:pieceName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = [self getRectWithPosition:position];
    imageView.alpha = alpha;
    [self addSubview:imageView];
}

- (CGRect)getRectWithPosition:(NSUInteger)square {
    float startX = 0;
    float startY = 0;
    if(square == 0 || square == 15){
        startX = kBeginXOfDrawing + [self convertToPoint:0];
        startY = kBeginYOfDrawing + [self convertToPoint:(square==0)?0:8];
    } else{
        startX = [self convertToPoint:(square-1)%2];
        startY = kBeginYOfDrawing + [self convertToPoint:(square-1)/2+1];
    }
    return CGRectMake(startX + kWidthOfBorder,
                      startY + kWidthOfBorder,
                      kWidthOfSquare - 2 * kWidthOfBorder,
                      kWidthOfSquare - 2 * kWidthOfBorder);
}

- (float)convertToPoint:(NSInteger)num {
    return num * ( kWidthOfSquare);
}

@end
