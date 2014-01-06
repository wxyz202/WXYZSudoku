//
//  SudokuGrid.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-5.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuGrid.h"

@interface SudokuGrid ()

@property (nonatomic) SudokuGridType gridType;

@end

@implementation SudokuGrid

@synthesize value = _value;

- (void)setValue:(NSUInteger)value
{
    if ([self isConst]){
        return;
    }
    _value = value;
}

- (BOOL)isConst
{
    return self.gridType == SudokuGridTypeConst;
}
        
- (instancetype)initGridEmpty
{
    self = [super init];
    if (self){
        self.gridType = SudokuGridTypeEmpty;
        self.value = 0;
    }
    return self;
}

- (instancetype)initGridConstWithValue:(NSUInteger)value
{
    self = [super init];
    if (self){
        self.gridType = SudokuGridTypeConst;
        self.value = value;
    }
    return self;
}

@end
