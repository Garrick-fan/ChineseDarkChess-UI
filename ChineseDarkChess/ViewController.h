//
//  ViewController.h
//  ChineseDarkChess
//
//  Created by Garrick on 2016/9/3.
//  Copyright © 2016年 Garrick. All rights reserved.
//
#import "CDCBoard.h"
#import "PieceStatusView.h"
#import "BoardView.h"
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic, strong) CDCBoard *cdcBoard;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;
@property (weak, nonatomic) IBOutlet UIImageView *gun;
@property (weak, nonatomic) IBOutlet BoardView *boardView;
@property (weak, nonatomic) IBOutlet PieceStatusView *redPieceStatusView;
@property (weak, nonatomic) IBOutlet PieceStatusView *blkPieceStatusView;

@end
