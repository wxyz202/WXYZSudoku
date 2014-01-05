//
//  SudokuGrid.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-5.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuGrid.h"

@interface SudokuGrid ()

@property (nonatomic) NSUInteger row;
@property (nonatomic) NSUInteger column;

@property (nonatomic) SudokuGridType gridType;
@property (nonatomic) NSUInteger value;

@end

@implementation SudokuGrid

- (instancetype)initGridEmptyInRow:(NSUInteger)row inColumn:(NSUInteger)column
{
    self = [super init];
    if (self){
        self.row = row;
        self.column = column;
        self.gridType = SudokuGridTypeEmpty;
        self.value = 0;
    }
    return self;
}

- (instancetype)initGridConstInRow:(NSUInteger)row inColumn:(NSUInteger)column withValue:(NSUInteger)value
{
    self = [super init];
    if (self){
        self.row = row;
        self.column = column;
        self.gridType = SudokuGridTypeConst;
        self.value = value;
    }
    return self;
}

- (BOOL)matchWithRow:(NSUInteger)row withColumn:(NSUInteger)column
{
    return row == self.row && column == self.column;
}

@end
