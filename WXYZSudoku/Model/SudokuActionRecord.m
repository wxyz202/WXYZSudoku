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
@property (nonatomic, readwrite) NSUInteger fromTraceGroup;
@property (nonatomic, readwrite) NSUInteger toTraceGroup;
@end

@implementation SudokuAction

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:@(self.row) forKey:@"row"];
    [encoder encodeObject:@(self.column) forKey:@"column"];
    [encoder encodeObject:@(self.fromValue) forKey:@"fromValue"];
    [encoder encodeObject:@(self.toValue) forKey:@"toValue"];
    [encoder encodeObject:@(self.fromTraceGroup) forKey:@"fromTraceGroup"];
    [encoder encodeObject:@(self.toTraceGroup) forKey:@"toTraceGroup"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    NSUInteger row = [[decoder decodeObjectForKey:@"row"] unsignedIntegerValue];
    NSUInteger column = [[decoder decodeObjectForKey:@"column"] unsignedIntegerValue];
    NSUInteger fromValue = [[decoder decodeObjectForKey:@"fromValue"] unsignedIntegerValue];
    NSUInteger toValue = [[decoder decodeObjectForKey:@"toValue"] unsignedIntegerValue];
    NSUInteger fromTraceGroup = [[decoder decodeObjectForKey:@"fromTraceGroup"] unsignedIntegerValue];
    NSUInteger toTraceGroup = [[decoder decodeObjectForKey:@"toTraceGroup"] unsignedIntegerValue];
    
    return [self initWithRow:row withColumn:column fromValue:fromValue toValue:toValue fromTraceGroup:fromTraceGroup toTraceGroup:toTraceGroup];
}

- (instancetype)initWithRow:(NSUInteger)row withColumn:(NSUInteger)column fromValue:(NSUInteger)fromValue toValue:(NSUInteger)toValue fromTraceGroup:(NSUInteger)fromTraceGroup toTraceGroup:(NSUInteger)toTraceGroup
{
    self = [super init];
    if (self) {
        self.row = row;
        self.column = column;
        self.fromValue = fromValue;
        self.toValue = toValue;
        self.fromTraceGroup = fromTraceGroup;
        self.toTraceGroup = toTraceGroup;
    }
    return self;
}

@end

@interface SudokuActionRecord ()
@property (strong, nonatomic) NSMutableArray *actions;
@property (nonatomic) NSInteger currentIndex;
@end

@implementation SudokuActionRecord

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.actions forKey:@"actions"];
    [encoder encodeObject:@(self.currentIndex) forKey:@"currentIndex"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    NSMutableArray *actions = [decoder decodeObjectForKey:@"actions"];
    NSUInteger currentIndex = [[decoder decodeObjectForKey:@"currentIndex"] integerValue];
    self = [super init];
    if (self) {
        self.actions = actions;
        self.currentIndex = currentIndex;
    }
    return self;
}

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
