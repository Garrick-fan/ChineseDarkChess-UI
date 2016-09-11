//
//  ViewController.h
//  ChineseDarkChess
//
//  Created by Garrick on 2016/9/3.
//  Copyright © 2016年 Garrick. All rights reserved.
//
#import "CDCBoard.h"
#import "CDCView.h"
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic, strong) CDCView *cdcView;
@property(nonatomic, strong) CDCBoard *cdcBoard;

@end
