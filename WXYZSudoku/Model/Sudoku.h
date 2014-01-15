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

- (SudokuGrid *)getGridInRow:(NSUInteger)row inColumn:(NSUInteger)column;

- (BOOL)gridsWithValueFinish:(NSUInteger)value;

- (void)chooseGridInRow:(NSUInteger)row inColumn:(NSUInteger)column;
- (void)clearChosenGrid;
- (void)fillChosenGridWithValue:(NSUInteger)value;
- (BOOL)canUndo;
- (BOOL)canRedo;
- (void)undo;
- (void)redo;
- (void)solve;

@end
