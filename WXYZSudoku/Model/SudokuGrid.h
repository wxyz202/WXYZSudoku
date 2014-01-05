//
//  SudokuGrid.h
//  WXYZSudoku
//
//  Created by wxyz on 14-1-5.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SudokuGridType){
    SudokuGridTypeEmpty,
    SudokuGridTypeConst,
    SudokuGridTypeFilled
};

@interface SudokuGrid : NSObject

@property (nonatomic, getter = isChosen) BOOL chosen;

- (instancetype)initGridEmptyInRow:(NSUInteger)row inColumn:(NSUInteger)column;
- (instancetype)initGridConstInRow:(NSUInteger)row inColumn:(NSUInteger)column withValue:(NSUInteger)value;

- (BOOL)matchWithRow:(NSUInteger)row withColumn:(NSUInteger)column;

@end
