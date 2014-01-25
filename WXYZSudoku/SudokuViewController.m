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
@property (nonatomic) NSUInteger sudokuDifficulty;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *redoButton;
@property (weak, nonatomic) IBOutlet UIButton *clearGridButton;
@property (weak, nonatomic) IBOutlet UIButton *solveButton;
@end

@implementation SudokuViewController

static const NSInteger SUDOKU_VIEW_TAG = 100;
static const NSInteger RESTART_ALERT_VIEW_TAG = 101;
static const NSInteger CONGRATULATION_ALERT_VIEW_TAG = 102;

- (Sudoku *)sudoku
{
    if (!_sudoku) {
        _sudoku = [[Sudoku alloc] initWithDifficulty:self.sudokuDifficulty];
    }
    return _sudoku;
}

- (void)newGameWithDifficulty:(NSUInteger)difficulty
{
    self.sudokuDifficulty = difficulty;
    self.sudoku = nil;
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
    if ([self.sudoku isFinished]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congratulaion!" message:[NSString stringWithFormat:@"Solve in %d seconds.", self.sudoku.playSeconds] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alertView.tag = CONGRATULATION_ALERT_VIEW_TAG;
        [alertView show];
        [self finish];
    }
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
    
    for (NSUInteger value = 1; value <= 9; value++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:value];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.enabled = YES;
        if ([self.sudoku gridsWithValueFinish:value]) {
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.enabled = NO;
        }
    }
    
    if ([self.sudoku canUndo]) {
        [self.undoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.undoButton.enabled = YES;
    } else {
        [self.undoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.undoButton.enabled = NO;
    }
    if ([self.sudoku canRedo]) {
        [self.redoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.redoButton.enabled = YES;
    } else {
        [self.redoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.redoButton.enabled = NO;
    }
}

- (IBAction)clickSolveButton {
    [self.sudoku solve];
    [self updateUI];
    [self finish];
}

- (void)finish {
    [self.undoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.undoButton.enabled = NO;
    [self.redoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.redoButton.enabled = NO;
    self.clearGridButton.enabled = NO;
    self.solveButton.enabled = NO;
}

- (IBAction)clickRestartButton {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure to restart?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertView.tag = RESTART_ALERT_VIEW_TAG;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        // do nothing
        return;
    }
    if (alertView.tag == RESTART_ALERT_VIEW_TAG) {
        self.sudoku = nil;
        self.solveButton.enabled = YES;
        [self updateUI];
    } else if (alertView.tag == CONGRATULATION_ALERT_VIEW_TAG) {
        // do nothing
    }
}

- (IBAction)clickUndoButton {
    [self.sudoku undo];
    [self updateUI];
}

- (IBAction)clickRedoButton {
    [self.sudoku redo];
    [self updateUI];
}

- (IBAction)clickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSubView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
    [self.sudoku resume];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.sudoku pause];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
