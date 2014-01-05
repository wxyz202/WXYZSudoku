//
//  Sudoku.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-5.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "Sudoku.h"

@interface Sudoku ()

@property (strong, nonatomic) NSMutableArray *grids;

@end


@implementation Sudoku

- (NSMutableArray *)grids
{
    if (!_grids) {
        _grids = [self createEmptyGrids];
    }
    return _grids;
}

- (NSMutableArray *)createEmptyGrids
{
    NSMutableArray *totalGrids = [[NSMutableArray alloc] init];
    for (int row = 0; row < 9; row++) {
        NSMutableArray *rowGrids = [[NSMutableArray alloc] init];
        for (int column = 0; column < 9; column++) {
            [rowGrids addObject:[[SudokuGrid alloc] initGridEmptyInRow:row inColumn:column]];
        }
        [totalGrids addObject:rowGrids];
    }
    return totalGrids;
}

@end
