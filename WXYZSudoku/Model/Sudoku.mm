//
//  Sudoku.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-5.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "Sudoku.h"
#import "SudokuSolver.h"
#import "SudokuGenerator.h"
#import "SudokuActionRecord.h"

@interface Sudoku ()

@property (nonatomic, readwrite) NSUInteger difficulty;
@property (strong, nonatomic) NSArray *grids;
@property (strong, nonatomic) SudokuActionRecord *actionRecord;
@property (strong, nonatomic) NSTimer *oneSecondTimer;
@property (nonatomic, readwrite) NSUInteger playSeconds;

@end


@implementation Sudoku

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.grids forKey:@"grids"];
    [encoder encodeObject:@(self.difficulty) forKey:@"difficulty"];
    [encoder encodeObject:self.actionRecord forKey:@"actionRecord"];
    [encoder encodeObject:@(self.playSeconds) forKey:@"playSeconds"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    NSArray *grids = [decoder decodeObjectForKey:@"grids"];
    NSUInteger difficulty = [[decoder decodeObjectForKey:@"difficulty"] unsignedIntegerValue];
    SudokuActionRecord *actionRecord = [decoder decodeObjectForKey:@"actionRecord"];
    NSUInteger playSeconds = [[decoder decodeObjectForKey:@"playSeconds"] unsignedIntegerValue];
    
    self = [self init];
    if (self) {
        self.grids = grids;
        self.difficulty = difficulty;
        self.actionRecord = actionRecord;
        self.playSeconds = playSeconds;
        [self updateAllGridsStatus];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.playSeconds = 0;
        self.oneSecondTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(passOneSecond:) userInfo:nil repeats:YES];
        [self pause];
    }
    return self;
}

- (instancetype)initWithDifficulty:(NSUInteger)difficulty
{
    self = [self init];
    if (self) {
        self.difficulty = difficulty;
    }
    return self;
}

- (void)dealloc
{
    [self.oneSecondTimer invalidate];
}

- (NSArray *)grids
{
    if (!_grids) {
        _grids = [self createRandomGeneratedGridsWithDifficulty:self.difficulty];
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
            grid.sameAsChosne = NO;
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
    for (NSUInteger rowIndex = row / 3 * 3; rowIndex < row / 3 * 3 + 3; rowIndex++) {
        for (NSUInteger columnIndex = column / 3 * 3; columnIndex < column / 3 * 3 + 3; columnIndex++) {
            if (row != rowIndex && column !=columnIndex) {
                [relatedGrids addObject:[self getGridInRow:rowIndex inColumn:columnIndex]];
            }
        }
    }
    return [NSArray arrayWithArray:relatedGrids];
}

- (NSArray *)getGridsWithValue:(NSUInteger)value
{
    NSMutableArray *grids = [[NSMutableArray alloc] init];
    
    for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++) {
            SudokuGrid *grid = [self getGridInRow:row inColumn:column];
            if (!grid.isFilled) {
                continue;
            }
            if (grid.value == value) {
                [grids addObject:grid];
            }
        }
    }

    return [NSArray arrayWithArray:grids];
}

- (BOOL)gridsWithValueFinish:(NSUInteger)value
{
    return [[self getGridsWithValue:value] count] == 9;
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
    [self updateConflicting];
    
    int row = 0;
    int column = 0;
    BOOL hasChosenGrid = NO;
    for (int rowIndex = 0; rowIndex < 9; rowIndex++) {
        for (int columnIndex = 0; columnIndex < 9; columnIndex++) {
            if ([self getGridInRow:rowIndex inColumn:columnIndex].isChosen) {
                row = rowIndex;
                column = columnIndex;
                hasChosenGrid = YES;
            }
        }
    }
    if (!hasChosenGrid) {
        return;
    }
    
    NSArray *relatedGrids = [self getRelatedGridsWithRow:row withColumn:column];
    for (SudokuGrid *grid in relatedGrids) {
        grid.related = YES;
    }
    
    SudokuGrid *chosenGrid = [self getGridInRow:row inColumn:column];
    if (chosenGrid.isFilled) {
        NSArray *sameGrids = [self getGridsWithValue:chosenGrid.value];
        for (SudokuGrid *grid in sameGrids) {
            grid.sameAsChosne = YES;
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
    BOOL finished = NO;
    for (int row = 0; !finished && row < 9; row++) {
        for (int column = 0; !finished && column < 9; column++) {
            SudokuGrid *grid = [self getGridInRow:row inColumn:column];
            if (grid.isChosen && !grid.isConstant) {
                SudokuAction *action = [[SudokuAction alloc] initWithRow:row withColumn:column fromValue:grid.value toValue:0];
                [self.actionRecord pushAction:action];
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
            if (grid.isChosen && !grid.isConstant) {
                SudokuAction *action = [[SudokuAction alloc] initWithRow:row withColumn:column fromValue:grid.value toValue:value];
                [self.actionRecord pushAction:action];
                grid.value = value;
                [self chooseGridInRow:row inColumn:column];
                finished = YES;
            }
        }
    }
}

- (void)solve
{
    int input[9][9];
    for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++){
            SudokuGrid *grid = [self getGridInRow:row inColumn:column];
            if (grid.isConstant) {
                input[row][column] = (int)grid.value;
            } else {
                input[row][column] = 0;
            }
        }
    }
    
    solve(input);
    
    for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++){
            [self getGridInRow:row inColumn:column].value = input[row][column];
        }
    }
    
    [self clearAllGridsStatus];
    [self updateAllGridsStatus];
}

- (NSArray *)createRandomGeneratedGrids
{
    int input[9][9];
    for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++){
            input[row][column]=0;
        }
    }
    generate(input, DIFFICULTY_NORMAL);
    
    NSMutableArray *totalGrids = [[NSMutableArray alloc] init];
    for (int row = 0; row < 9; row++) {
        NSMutableArray *rowGrids = [[NSMutableArray alloc] init];
        for (int column = 0; column < 9; column++) {
            if (input[row][column] > 0) {
                [rowGrids addObject:[[SudokuGrid alloc] initGridConstWithValue:input[row][column]]];
            } else {
                [rowGrids addObject:[[SudokuGrid alloc] initGridEmpty]];
            }
        }
        [totalGrids addObject:[NSArray arrayWithArray:rowGrids]];
    }
    return [NSArray arrayWithArray:totalGrids];
}

- (NSArray *)createRandomGeneratedGridsWithDifficulty:(NSUInteger)difficulty
{
    int input[9][9];
    for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++){
            input[row][column]=0;
        }
    }
    generate(input, (int)(self.difficulty));
    
    NSMutableArray *totalGrids = [[NSMutableArray alloc] init];
    for (int row = 0; row < 9; row++) {
        NSMutableArray *rowGrids = [[NSMutableArray alloc] init];
        for (int column = 0; column < 9; column++) {
            if (input[row][column] > 0) {
                [rowGrids addObject:[[SudokuGrid alloc] initGridConstWithValue:input[row][column]]];
            } else {
                [rowGrids addObject:[[SudokuGrid alloc] initGridEmpty]];
            }
        }
        [totalGrids addObject:[NSArray arrayWithArray:rowGrids]];
    }
    return [NSArray arrayWithArray:totalGrids];
}

- (SudokuActionRecord *)actionRecord
{
    if (!_actionRecord) {
        _actionRecord = [[SudokuActionRecord alloc] init];
    }
    return _actionRecord;
}

- (BOOL)canUndo
{
    return [self.actionRecord canUndo];
}

- (BOOL)canRedo
{
    return [self.actionRecord canRedo];
}

- (void)undo
{
    SudokuAction *action = [self.actionRecord undo];
    if (action) {
        [self getGridInRow:action.row inColumn:action.column].value = action.fromValue;
        [self chooseGridInRow:action.row inColumn:action.column];
    }
}

- (void)redo
{
    SudokuAction *action = [self.actionRecord redo];
    if (action) {
        [self getGridInRow:action.row inColumn:action.column].value = action.toValue;
        [self chooseGridInRow:action.row inColumn:action.column];
    }
}

- (BOOL)isFinished
{
    for (NSUInteger row = 0; row < 9; row++) {
        for (NSUInteger column = 0; column < 9; column++) {
            SudokuGrid *grid = [self getGridInRow:row inColumn:column];
            if (!grid.isConstant && !grid.isFilled) {
                return NO;
            }
        }
    }
    return YES;
}


- (void)passOneSecond:(NSTimer *)timer
{
    self.playSeconds++;
}

- (void)pause
{
    [self.oneSecondTimer setFireDate:[NSDate distantFuture]];
}

- (void)resume
{
    [self.oneSecondTimer setFireDate:[NSDate distantPast]];
}

@end
