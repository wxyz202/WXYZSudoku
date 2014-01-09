//
//  SudokuGridView.h
//  WXYZSudoku
//
//  Created by wxyz on 14-1-4.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SudokuGridView : UIView

+ (UIColor *)chosenGridBackgroundColor;
+ (UIColor *)relatedGridBackgroundColor;
+ (UIColor *)otherGridBackgroundColor;
+ (UIColor *)conflictingGridTitleColor;
+ (UIColor *)sameValueGridTitileColor;
+ (UIColor *)otherGridTitleColor;

- (UIButton *)getButtonInRow:(NSUInteger)row inColumn:(NSUInteger)column;

@end
