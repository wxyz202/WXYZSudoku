//
//  SudokuIndexViewController.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-25.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuIndexViewController.h"
#import "SudokuGenerator.h"
#import "SudokuViewController.h"

static const NSUInteger NEW_GAME_ALERT_VIEW_TAG = 100;

@interface SudokuIndexViewController ()

@end

@implementation SudokuIndexViewController

- (IBAction)touchNewGameButton {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Game" message:@"choose difficulty" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Easy", @"Normal", @"Hard", nil];
    alertView.tag = NEW_GAME_ALERT_VIEW_TAG;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        // do nothing
        return;
    }
    if (alertView.tag == NEW_GAME_ALERT_VIEW_TAG) {
        NSString *difficulty = [alertView buttonTitleAtIndex:buttonIndex];
        NSDictionary *difficultyDict = @{@"Easy":@(DIFFICULTY_EASY),
                                         @"Normal":@(DIFFICULTY_NORMAL),
                                         @"Hard":@(DIFFICULTY_HARD)};
        [self performSegueWithIdentifier:@"new game" sender:[difficultyDict objectForKey:difficulty]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"new game"]) {
        SudokuViewController *viewController = segue.destinationViewController;
        [viewController newGameWithDifficulty:[sender unsignedIntegerValue]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
