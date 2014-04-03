//
//  SudokuActionRecord.h
//  WXYZSudoku
//
//  Created by wxyz on 14-1-15.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SudokuAction : NSObject

@property (nonatomic, readonly) NSUInteger row;
@property (nonatomic, readonly) NSUInteger column;
@property (nonatomic, readonly) NSUInteger fromValue;
@property (nonatomic, readonly) NSUInteger toValue;
@property (nonatomic, readonly) NSUInteger fromTraceGroup;
@property (nonatomic, readonly) NSUInteger toTraceGroup;

- (instancetype)initWithRow:(NSUInteger)row withColumn:(NSUInteger)column fromValue:(NSUInteger)fromValue toValue:(NSUInteger)toValue fromTraceGroup:(NSUInteger)fromTraceGroup toTraceGroup:(NSUInteger)toTraceGroup;

@end

@interface SudokuActionRecord : NSObject

- (BOOL)canRedo;
- (BOOL)canUndo;
- (SudokuAction *)undo;
- (SudokuAction *)redo;
- (void)pushAction:(SudokuAction *)action;

@end
