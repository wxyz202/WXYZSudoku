//
//  SudokuColorAlertView.h
//  WXYZSudoku
//
//  Created by wxyz on 14-4-2.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "CustomIOS7AlertView.h"

@interface SudokuColorAlertView : CustomIOS7AlertView

- (instancetype)initWithColorArray:(NSArray *)colorArray currentColor:(UIColor *)currentColor;
- (BOOL)isConfirmChangeColorButton:(NSInteger)buttonIndex;
- (UIColor *)chosenColor;

@end
