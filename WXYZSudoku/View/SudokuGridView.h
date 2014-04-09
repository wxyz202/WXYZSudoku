//
//  SudokuGridView.h
//  WXYZSudoku
//
//  Created by wxyz on 14-1-4.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SudokuGridView : UIView

+ (NSArray *)normalGridTitleColorArray;

+ (UIColor *)chosenGridBackgroundColor;
+ (UIColor *)relatedGridBackgroundColor;
+ (UIColor *)constantValueGridBackgroundColor;
+ (UIColor *)normalGridBackgroundColor;
+ (UIColor *)conflictingGridTitleColor;
+ (UIColor *)sameValueGridTitleColor;
+ (UIColor *)constantValueGridTitleColor;

- (UIButton *)getButtonInRow:(NSUInteger)row inColumn:(NSUInteger)column;
- (void)resetGrid;

- (void)jumpButtons;

@end
