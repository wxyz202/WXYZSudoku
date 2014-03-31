//
//  SudokuViewController.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-4.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuGenerator.h"
#import "SudokuViewController.h"
#import "SudokuCongratulationAlertView.h"
#import "RankRecord+Create.h"
#import "NSString+SecondsFormat.h"

@interface SudokuViewController ()
@property (strong, nonatomic)SudokuGridView *sudokuView;
@property (strong, nonatomic)Sudoku *sudoku;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *redoButton;
@property (weak, nonatomic) IBOutlet UIButton *clearGridButton;
@property (weak, nonatomic) IBOutlet UIButton *solveButton;
@end

@implementation SudokuViewController

static const NSInteger SUDOKU_VIEW_TAG = 100;
static const NSInteger RESTART_ALERT_VIEW_TAG = 101;
static const NSInteger CONGRATULATION_ALERT_VIEW_TAG = 102;

- (void)newGameWithDifficulty:(NSUInteger)difficulty
{
    self.sudoku = [[Sudoku alloc] initWithDifficulty:difficulty];
    [self saveSudoku];
    [self updateTitleWithDifficulty:difficulty];
}

- (void)updateTitleWithDifficulty:(NSUInteger)difficulty
{
    NSDictionary *difficultyDict = @{@(DIFFICULTY_EASY): @"Easy",
                                 @(DIFFICULTY_NORMAL): @"Normal",
                                 @(DIFFICULTY_HARD): @"Hard"
                                 };
    NSString *difficultyName = difficultyDict[@(difficulty)];
    self.title = [NSString stringWithFormat:@"%@ Sudoku", difficultyName];
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
    [self saveSudoku];
    [self updateUI];
    if ([self.sudoku isFinished]) {
        self.sudoku.finishSeconds = self.sudoku.playSeconds;
        [self finish];
        SudokuCongratulationAlertView *congratulationView = [[SudokuCongratulationAlertView alloc] initWithTitle:@"Congratulaion!" message:[NSString stringWithFormat:@"Solve in %@. Please input your name.", [NSString stringWithSeconds:self.sudoku.finishSeconds]] delegate:self cancelButtonTitle:nil otherButtonTitle:@"OK"];
        congratulationView.tag = CONGRATULATION_ALERT_VIEW_TAG;
        [congratulationView show];
    }
}

- (IBAction)clearGrid {
    [self.sudoku clearChosenGrid];
    [self saveSudoku];
    [self updateUI];
}

- (void)updateUI
{
    for (int row = 0; row < 9; row++) {
        for (int column = 0; column < 9; column++) {
            UIButton *button = [self.sudokuView getButtonInRow:row inColumn:column];
            SudokuGrid *grid = [self.sudoku getGridInRow:row inColumn:column];
            if (grid.isFilled) {
                [button setTitle:[NSString stringWithFormat:@"%@", @(grid.value)] forState:UIControlStateNormal];
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
    [self removeSavedSudoku];
}

- (IBAction)clickRestartButton {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure to restart?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertView.tag = RESTART_ALERT_VIEW_TAG;
    [alertView show];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    if (alertView.tag == CONGRATULATION_ALERT_VIEW_TAG) {
        SudokuCongratulationAlertView *congratulationAlertView = (SudokuCongratulationAlertView *)alertView;
        if ([congratulationAlertView.inputName isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        // do nothing
        return;
    }
    if (alertView.tag == RESTART_ALERT_VIEW_TAG) {
        [self removeSavedSudoku];
        [self newGameWithDifficulty:self.sudoku.difficulty];
        [self.sudoku resume];
        self.solveButton.enabled = YES;
        [self updateUI];
    } else if (alertView.tag == CONGRATULATION_ALERT_VIEW_TAG) {
        SudokuCongratulationAlertView *congratulationAlertView = (SudokuCongratulationAlertView *)alertView;
        NSString *playerName = congratulationAlertView.inputName;
        NSUInteger finishSeconds = self.sudoku.finishSeconds;
        [self addRecordWithPlayerName:playerName withFinishSeconds:@(finishSeconds)];
    }
}

- (void)addRecordWithPlayerName:(NSString *)playerName withFinishSeconds:(NSNumber *)finishSeconds
{
    RankRecord *record = [RankRecord newRankRecordInManagedObjectContext:self.managedObjectContext];
    record.sudoku = [NSKeyedArchiver archivedDataWithRootObject:self.sudoku];
    record.playerName = playerName;
    record.finishSeconds = finishSeconds;
    record.difficulty = @(self.sudoku.difficulty);
}

- (IBAction)clickUndoButton {
    [self.sudoku undo];
    [self saveSudoku];
    [self updateUI];
}

- (IBAction)clickRedoButton {
    [self.sudoku redo];
    [self saveSudoku];
    [self updateUI];
}

- (void)saveSudoku
{
    NSData *sudokuData = [NSKeyedArchiver archivedDataWithRootObject:self.sudoku];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sudokuData forKey:@"storedSudoku"];
    [defaults synchronize];
}

- (void)loadSudoku
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *sudokuData = [defaults objectForKey:@"storedSudoku"];
    [self loadSudokuWithData:sudokuData];
}

- (void)loadSudokuWithData:(NSData *)data
{
    self.sudoku = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self updateTitleWithDifficulty:self.sudoku.difficulty];
}

- (void)removeSavedSudoku
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"storedSudoku"];
    [defaults synchronize];
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
