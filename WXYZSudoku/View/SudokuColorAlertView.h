//
//  SudokuColorAlertView.h
//  WXYZSudoku
//
//  Created by wxyz on 14-4-2.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "CustomIOS7AlertView.h"

@interface SudokuColorAlertView : CustomIOS7AlertView

@property (nonatomic, readonly) NSUInteger chosenColorIndex;

- (instancetype)initWithTitle:(NSString *)title withColorArray:(NSArray *)colorArray currentColorIndex:(NSUInteger)currentColorIndex;
- (BOOL)isConfirmChangeColorButton:(NSInteger)buttonIndex;

@end
