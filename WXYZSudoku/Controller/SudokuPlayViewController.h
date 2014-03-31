//
//  SudokuPlayViewController.h
//  WXYZSudoku
//
//  Created by wxyz on 14-3-31.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuViewController.h"

@interface SudokuPlayViewController : SudokuViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *restartButton;

- (void)newGameWithDifficulty:(NSUInteger)difficulty;
- (void)loadSudoku;

@end
