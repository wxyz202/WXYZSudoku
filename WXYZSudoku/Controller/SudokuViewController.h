//
//  SudokuViewController.h
//  WXYZSudoku
//
//  Created by wxyz on 14-1-4.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SudokuGridView.h"
#import "Sudoku.h"

extern const NSInteger SUDOKU_VIEW_TAG;

@interface SudokuViewController : UIViewController

@property (strong, nonatomic)NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic)SudokuGridView *sudokuView;
@property (strong, nonatomic)Sudoku *sudoku;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *redoButton;

- (void)loadSudokuWithData:(NSData *)data;
- (void)updateTitleWithDifficulty:(NSUInteger)difficulty;
- (void)updateUI;
- (IBAction)clickUndoButton;
- (IBAction)clickRedoButton;

@end
