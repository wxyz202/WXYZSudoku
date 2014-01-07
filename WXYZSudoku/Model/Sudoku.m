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

- (void)updateAllGridsStatus
{
    int row = -1;
    int column = -1;
    for (int rowIndex = 0; rowIndex < 9; rowIndex++) {
        for (int columnIndex = 0; columnIndex < 9; columnIndex++) {
            if ([self getGridInRow:rowIndex inColumn:columnIndex].isChosen) {
                row = rowIndex;
                column = columnIndex;
            }
        }
    }
    for (int rowIndex = 0; rowIndex < 9; rowIndex++) {
        [self getGridInRow:rowIndex inColumn:column].related = YES;
    }
    for (int columnIndex = 0; columnIndex < 9; columnIndex++) {
        [self getGridInRow:row inColumn:columnIndex].related = YES;
    }
    for (int rowIndex = row / 3 * 3; rowIndex < row / 3 * 3 + 3; rowIndex++) {
        for (int columnIndex = column / 3 * 3; columnIndex < column / 3 * 3 + 3; columnIndex++) {
            [self getGridInRow:rowIndex inColumn:columnIndex].related = YES;
        }
    }
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
    for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++) {
            SudokuGrid *grid = [self getGridInRow:row inColumn:column];
            if (grid.isChosen && !grid.isConstant) {
                grid.value = 0;
            }
        }
    }
    [self updateAllGridsStatus];
}

- (void)fillChosenGridWithValue:(NSUInteger)value
{
    for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++) {
            SudokuGrid *grid = [self getGridInRow:row inColumn:column];
            if (grid.isChosen && !grid.isConstant) {
                grid.value = value;
            }
        }
    }
    [self updateAllGridsStatus];
}

@end
