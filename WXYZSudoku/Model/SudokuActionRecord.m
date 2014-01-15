//
//  SudokuActionRecord.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-15.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuActionRecord.h"

@interface SudokuAction ()
@property (nonatomic, readwrite) NSUInteger row;
@property (nonatomic, readwrite) NSUInteger column;
@property (nonatomic, readwrite) NSUInteger fromValue;
@property (nonatomic, readwrite) NSUInteger toValue;
@end

@implementation SudokuAction

- (instancetype)initWithRow:(NSUInteger)row withColumn:(NSUInteger)column fromValue:(NSUInteger)fromValue toValue:(NSUInteger)toValue
{
    self = [super init];
    if (self) {
        self.row = row;
        self.column = column;
        self.fromValue = fromValue;
        self.toValue = toValue;
    }
    return self;
}

@end

@interface SudokuActionRecord ()
@property (strong, nonatomic) NSMutableArray *actions;
@property (nonatomic) NSInteger currentIndex;
@end

@implementation SudokuActionRecord

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentIndex = -1;
        self.actions = nil;
    }
    return self;
}

- (NSMutableArray *)actions
{
    if (!_actions) {
        _actions = [[NSMutableArray alloc] init];
    }
    return _actions;
}

- (BOOL)canRedo
{
    return [self.actions count] > 0 && self.currentIndex + 1 < [self.actions count];
}

- (BOOL)canUndo
{
    return [self.actions count] > 0 && self.currentIndex >= 0;
}

- (SudokuAction *)undo
{
    if ([self canUndo]) {
        SudokuAction *currentAction = self.actions[self.currentIndex];
        self.currentIndex--;
        return currentAction;
    } else {
        return nil;
    }
}

- (SudokuAction *)redo
{
    if ([self canRedo]) {
        self.currentIndex++;
        SudokuAction *currentAction = self.actions[self.currentIndex];
        return currentAction;
    } else {
        return nil;
    }
}

- (void)pushAction:(SudokuAction *)action;
{
    self.currentIndex++;
    [self.actions removeObjectsInRange:NSMakeRange(self.currentIndex, [self.actions count] - self.currentIndex)];
    [self.actions addObject:action];
}

@end
