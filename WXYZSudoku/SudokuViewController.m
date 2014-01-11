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

static const int SUDOKU_VIEW_TAG = 100;

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

- (IBAction)chooseNumber:(UIButton *)sender {
    [self.sudoku fillChosenGridWithValue:[sender.currentTitle intValue]];
    [self updateUI];
}

- (IBAction)clearGrid {
    [self.sudoku clearChosenGrid];
    [self updateUI];
}

- (void)updateUI
{
    for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++) {
            UIButton *button = [self.sudokuView getButtonInRow:row inColumn:column];
            SudokuGrid *grid = [self.sudoku getGridInRow:row inColumn:column];
            if (grid.isFilled) {
                [button setTitle:[NSString stringWithFormat:@"%d", grid.value] forState:UIControlStateNormal];
            } else {
                [button setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
            }
            
            if (grid.isChosen) {
                [button setBackgroundColor:[SudokuGridView chosenGridBackgroundColor]];
            } else if (grid.isRelated){
                [button setBackgroundColor:[SudokuGridView relatedGridBackgroundColor]];
            } else {
                 [button setBackgroundColor:[SudokuGridView otherGridBackgroundColor]];
            }
            
            if (grid.isConfilcting) {
                [button setTitleColor:[SudokuGridView conflictingGridTitleColor] forState:UIControlStateNormal];
            } else if (grid.isSameAsChosen) {
                [button setTitleColor:[SudokuGridView sameValueGridTitileColor] forState:UIControlStateNormal];
            } else if (grid.isConstant){
                [button setTitleColor:[SudokuGridView constantValueGridTitleColor] forState:UIControlStateNormal];
            } else {
                [button setTitleColor:[SudokuGridView otherGridTitleColor] forState:UIControlStateNormal];
            }
        }
    }
}

- (IBAction)clickSolveButton {
    [self.sudoku solve];
    [self updateUI];
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
