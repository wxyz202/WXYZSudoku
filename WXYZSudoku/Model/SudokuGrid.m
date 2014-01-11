//
//  SudokuGrid.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-5.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuGrid.h"

@interface SudokuGrid ()

@property (nonatomic, readwrite, getter = isConstant) BOOL constant;

@end

@implementation SudokuGrid

@synthesize value = _value;

- (void)setValue:(NSUInteger)value
{
    if ([self isConstant]){
        return;
    }
    if (1 <= value && value <= 9) {
        self.filled = YES;
    } else {
        self.filled = NO;
    }
    _value = value;
}

- (instancetype)initGridEmpty
{
    self = [super init];
    if (self){
        self.constant = NO;
        self.value = 0;
    }
    return self;
}

- (instancetype)initGridConstWithValue:(NSUInteger)value
{
    self = [super init];
    if (self){
        self.value = value;
        self.constant = YES;
    }
    return self;
}

@end
