//
//  SudokuViewController.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-4.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuSetting.h"
#import "SudokuViewController.h"

@interface SudokuViewController ()

@end

const NSInteger SUDOKU_VIEW_TAG = 100;

@implementation SudokuViewController

# pragma mark - load data

- (void)loadSudokuWithData:(NSData *)data
{
    self.sudoku = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self updateTitleWithDifficulty:self.sudoku.difficulty];
}

# pragma mark - ui

- (void)updateTitleWithDifficulty:(NSUInteger)difficulty
{
    NSString *difficultyName = DIFFICULTY_NAME_DICT[@(difficulty)];
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
- (void)showSudokuWithAnimate
{
    UIView *coverView1 = [[UIView alloc] init];
    UIView *coverView2 = [[UIView alloc] init];
    SudokuGridView *sudokuView = self.sudokuView;
    coverView1.frame = sudokuView.frame;
    coverView2.frame = sudokuView.frame;
    coverView1.backgroundColor = [UIColor whiteColor];
    coverView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:coverView1];
    [self.view addSubview:coverView2];
    
    [UIView animateWithDuration:1.0 animations:^{
        CGRect tempRect = coverView1.frame;
        tempRect.origin.x += tempRect.size.width;
        tempRect.size.width = 0;
        coverView1.frame = tempRect;
        tempRect = coverView2.frame;
        tempRect.origin.y += tempRect.size.height;
        tempRect.size.height = 0;
        coverView2.frame = tempRect;
    } completion:^(BOOL fin){
        [coverView1 removeFromSuperview];
        [coverView2 removeFromSuperview];
    }];
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
            } else if (grid.isConstant) {
                [button setBackgroundColor:[SudokuGridView constantValueGridBackgroundColor]];
            } else {
                 [button setBackgroundColor:[SudokuGridView normalGridBackgroundColor]];
            }
            
            if (grid.isConfilcting) {
                [button setTitleColor:[SudokuGridView conflictingGridTitleColor] forState:UIControlStateNormal];
            } else if (grid.isSameAsChosen) {
                [button setTitleColor:[SudokuGridView sameValueGridTitleColor] forState:UIControlStateNormal];
            } else if (grid.isConstant){
                [button setTitleColor:[SudokuGridView constantValueGridTitleColor] forState:UIControlStateNormal];
            } else {
                [button setTitleColor:[SudokuGridView normalGridTitleColorArray][grid.traceGroup] forState:UIControlStateNormal];
            }
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
    
    if (!self.alreadyAnimate) {
        [self showSudokuWithAnimate];
        self.alreadyAnimate = YES;
    }
}

# pragma mark - play

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

- (IBAction)clickUndoButton {
    [self.sudoku undo];
    [self updateUI];
}

- (IBAction)clickRedoButton {
    [self.sudoku redo];
    [self updateUI];
}

# pragma mark - other

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSubView];
    self.alreadyAnimate = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
