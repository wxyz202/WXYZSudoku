//
//  SudokuChallengeViewController.m
//  WXYZSudoku
//
//  Created by wxyz on 14-4-9.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuChallengeViewController.h"
#import "NSString+SecondsFormat.h"
#import "KxMenu.h"

@interface SudokuChallengeViewController ()

@end

@implementation SudokuChallengeViewController


# pragma mark - do not store sudoku

- (void)saveSudoku
{
}

- (void)removeSavedSudoku
{
}

# pragma mark - change color

- (IBAction)showMoreMenu:(UIBarButtonItem *)sender {
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"Choose Color"
                     image:nil
                    target:self
                    action:@selector(clickChooseColorButton)],
      
      [KxMenuItem menuItem:@"Clear Color"
                     image:nil
                    target:self
                    action:@selector(clickClearColorButton)]
      ];
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(self.view.frame.size.width, self.navigationController.navigationBar.frame.origin.y, -40, self.navigationController.navigationBar.frame.size.height)
                 menuItems:menuItems];
}


# pragma mark - timer

- (void)passOneSecond:(NSTimer *)timer
{
    [super passOneSecond:timer];
    
    if (self.challengeSeconds > self.sudoku.playSeconds) {
        self.title = [NSString stringWithSecondsInShort:self.challengeSeconds-self.sudoku.playSeconds];
    } else {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor redColor]};
        self.title = [NSString stringWithSecondsInShort:0];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
}

@end
