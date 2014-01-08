//
//  Sudoku.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-5.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "Sudoku.h"

@interface Sudoku ()

@property (strong, nonatomic) NSArray *grids;

@end


@implementation Sudoku

- (NSArray *)grids
{
    if (!_grids) {
        _grids = [self createEmptyGrids];
    }
    return _grids;
}

- (NSArray *)createEmptyGrids
{
    NSMutableArray *totalGrids = [[NSMutableArray alloc] init];
    for (int row = 0; row < 9; row++) {
        NSMutableArray *rowGrids = [[NSMutableArray alloc] init];
        for (int column = 0; column < 9; column++) {
            [rowGrids addObject:[[SudokuGrid alloc] initGridEmpty]];
        }
        [totalGrids addObject:[NSArray arrayWithArray:rowGrids]];
    }
    return [NSArray arrayWithArray:totalGrids];
}

- (SudokuGrid *)getGridInRow:(NSUInteger)row inColumn:(NSUInteger)column
{
    return self.grids[row][column];
}

- (void)clearAllGridsStatus
{
    for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++) {
            SudokuGrid *grid = self.grids[row][column];
            grid.chosen = NO;
            grid.confilcting = NO;
            grid.related = NO;
        }
    }
}

- (NSArray *)getRelatedGridsWithRow:(NSUInteger)row withColumn:(NSUInteger)column
{
    NSMutableArray* relatedGrids = [[NSMutableArray alloc] init];
    for (int rowIndex = 0; rowIndex < 9; rowIndex++) {
        if (row == rowIndex) {
            continue;
        }
        [relatedGrids addObject:[self getGridInRow:rowIndex inColumn:column]];
    }
    for (int columnIndex = 0; columnIndex < 9; columnIndex++) {
        if (column == columnIndex) {
            continue;
        }
        [relatedGrids addObject:[self getGridInRow:row inColumn:columnIndex]];
    }
    for (int rowIndex = row / 3 * 3; rowIndex < row / 3 * 3 + 3; rowIndex++) {
        for (int columnIndex = column / 3 * 3; columnIndex < column / 3 * 3 + 3; columnIndex++) {
            if (row != rowIndex && column !=columnIndex) {
                [relatedGrids addObject:[self getGridInRow:rowIndex inColumn:columnIndex]];
            }
        }
    }
    return [NSArray arrayWithArray:relatedGrids];
}

- (void)updateConflicting
{
    for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++) {
            SudokuGrid *grid = [self getGridInRow:row inColumn:column];
            if (!grid.isFilled) {
                continue;
            }
            
            NSArray *relatedGrids = [self getRelatedGridsWithRow:row withColumn:column];
            for (SudokuGrid *candidateGrid in relatedGrids) {
                if (candidateGrid.value == grid.value) {
                    grid.confilcting = YES;
                    candidateGrid.confilcting = YES;
                }
            }
        }
    }
}

- (void)updateAllGridsStatus
{
    int row = 0;
    int column = 0;
    for (int rowIndex = 0; rowIndex < 9; rowIndex++) {
        for (int columnIndex = 0; columnIndex < 9; columnIndex++) {
            if ([self getGridInRow:rowIndex inColumn:columnIndex].isChosen) {
                row = rowIndex;
                column = columnIndex;
            }
        }
    }
    
    NSArray *relatedGrids = [self getRelatedGridsWithRow:row withColumn:column];
    for (SudokuGrid *grid in relatedGrids) {
        grid.related = YES;
    }
    
    [self updateConflicting];
}

- (void)chooseGridInRow:(NSUInteger)row inColumn:(NSUInteger)column
{
    [self clearAllGridsStatus];
    SudokuGrid *chonsenGrid = [self getGridInRow:row inColumn:column];
    chonsenGrid.chosen = YES;
    [self updateAllGridsStatus];
}

- (void)clearChosenGrid
{
    BOOL finished = NO;
    for (int row = 0; !finished && row < 9; row++) {
        for (int column = 0; !finished && column < 9; column++) {
            SudokuGrid *grid = [self getGridInRow:row inColumn:column];
            if (grid.isChosen && !grid.isConstant) {
                grid.value = 0;
                [self chooseGridInRow:row inColumn:column];
                finished = YES;
            }
        }
    }
}

- (void)fillChosenGridWithValue:(NSUInteger)value
{
    BOOL finished = NO;
    for (int row = 0; !finished && row < 9; row++) {
        for (int column = 0; !finished && column < 9; column++) {
            SudokuGrid *grid = [self getGridInRow:row inColumn:column];
            if (grid.isChosen && !grid.isConstant) {                grid.value = value;
                [self chooseGridInRow:row inColumn:column];
                finished = YES;
            }
        }
    }
}

@end
