//
//  SudokuGridView.h
//  WXYZSudoku
//
//  Created by wxyz on 14-1-4.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SudokuGridView : UIView

- (UIButton *)getButtonWithRow:(NSUInteger)row withColumn:(NSUInteger)column;

@end
