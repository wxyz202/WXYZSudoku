//
//  Sudoku.h
//  WXYZSudoku
//
//  Created by wxyz on 14-1-5.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SudokuGrid.h"

@interface Sudoku : NSObject

@property (nonatomic, readonly) NSUInteger difficulty;
@property (nonatomic, readonly, strong) NSString *identifier;
@property (nonatomic) NSUInteger currentTraceGroup;
@property (nonatomic) NSUInteger playSeconds;
@property (nonatomic) NSUInteger finishSeconds;

- (instancetype)initWithIdentifier:(NSString *)identifier withDifficulty:(NSUInteger)difficulty;
- (instancetype)initWithDifficulty:(NSUInteger)difficulty;

- (SudokuGrid *)getGridInRow:(NSUInteger)row inColumn:(NSUInteger)column;
- (BOOL)gridsWithValueFinish:(NSUInteger)value;

- (void)clearAllGridsStatus;
- (void)chooseGridInRow:(NSUInteger)row inColumn:(NSUInteger)column;
- (void)clearChosenGrid;
- (void)fillChosenGridWithValue:(NSUInteger)value;
- (void)clearGridWithTraceGroup:(NSUInteger)traceGroup;
- (BOOL)canUndo;
- (BOOL)canRedo;
- (void)undo;
- (void)redo;
- (void)solve;
- (BOOL)isFinished;

@end
