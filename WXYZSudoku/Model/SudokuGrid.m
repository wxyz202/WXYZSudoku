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

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:@(self.value) forKey:@"value"];
    [encoder encodeObject:@(self.constant) forKey:@"constant"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    NSUInteger value = [[decoder decodeObjectForKey:@"value"] unsignedIntegerValue];
    BOOL constant = [[decoder decodeObjectForKey:@"constant"] boolValue];
    if (constant) {
        return [self initGridConstWithValue:value];
    } else {
        self = [self initGridEmpty];
        if (self) {
            self.value = value;
        }
        return self;
    }
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
