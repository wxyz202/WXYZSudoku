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

@interface SudokuViewController : UIViewController

@property (strong, nonatomic)NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *restartButton;

- (void)newGameWithDifficulty:(NSUInteger)difficulty;
- (void)loadSudoku;
- (void)loadSudokuWithData:(NSData *)data;

@end
