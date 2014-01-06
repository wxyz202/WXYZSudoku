//
//  SudokuViewController.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-4.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuViewController.h"

@interface SudokuViewController ()
@property (strong, nonatomic)SudokuGridView *sudokuView;
@property (strong, nonatomic)Sudoku *sudoku;
@end

@implementation SudokuViewController

static const int SUDOKU_VIEW_TAG = 1;

- (Sudoku *)sudoku
{
    if (!_sudoku) {
        _sudoku = [[Sudoku alloc] init];
    }
    return _sudoku;
}

- (void)createSubView
{
    self.sudokuView = (SudokuGridView *)[self.view viewWithTag:SUDOKU_VIEW_TAG];
    for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++) {
            UIButton *button = [self.sudokuView getButtonInRow:row inColumn:column];
            [button addTarget:self action:@selector(chooseGrid:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (IBAction)chooseGrid:(id)sender
{
    NSUInteger chosenRow = 0;
    NSUInteger chosenColumn = 0;
    for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++) {
            UIButton *button = [self.sudokuView getButtonInRow:row inColumn:column];
            if (button == sender) {
                chosenRow = row;
                chosenColumn = column;
                break;
            }
        }
    }
    
    [self.sudoku chooseGridInRow:chosenRow inColumn:chosenColumn];
    [self updateUI];
}

- (void)updateUI
{
    for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++) {
            UIButton *button = [self.sudokuView getButtonInRow:row inColumn:column];
            SudokuGrid *grid = [self.sudoku getGridInRow:row inColumn:column];
            if (grid.isChosen) {
                [button setBackgroundColor:[SudokuGridView chosenGridBackgroundColor]];
            } else {
                 [button setBackgroundColor:[SudokuGridView otherGridBackgroundColor]];
            }
            [button setTitleColor:[SudokuGridView otherGridTitleColor] forState:UIControlStateNormal];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSubView];
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
