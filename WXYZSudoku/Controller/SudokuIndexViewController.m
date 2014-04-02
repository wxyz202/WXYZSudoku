//
//  SudokuIndexViewController.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-25.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuIndexViewController.h"
#import "SudokuGenerator.h"
#import "SudokuPlayViewController.h"
#import "SudokuRankRecordCDTVC.h"
#import "RankRecordDatabaseAvailability.h"

static const NSUInteger NEW_GAME_ALERT_VIEW_TAG = 100;

@interface SudokuIndexViewController ()
@property (weak, nonatomic) IBOutlet UIButton *resumeButton;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation SudokuIndexViewController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:RankRecordDatabaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = note.userInfo[RankRecordDatabaseAvailabilityContext];
                                                  }];
}


- (IBAction)touchNewGameButton {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Game" message:@"choose difficulty" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Easy", @"Normal", @"Hard", @"Nightmare", @"Hell", @"Demo", nil];
    alertView.tag = NEW_GAME_ALERT_VIEW_TAG;
    [alertView show];
}

- (IBAction)touchResumeButton {
    [self performSegueWithIdentifier:@"resume" sender:nil];
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
                                         @"Hard":@(DIFFICULTY_HARD),
                                         @"Nightmare":@(DIFFICULTY_NIGHTMARE),
                                         @"Hell":@(DIFFICULTY_HELL),
                                         @"Demo":@(DIFFICULTY_DEMO)};
        [self performSegueWithIdentifier:@"new game" sender:[difficultyDict objectForKey:difficulty]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"new game"]) {
        SudokuPlayViewController *viewController = segue.destinationViewController;
        [viewController newGameWithDifficulty:[sender unsignedIntegerValue]];
        viewController.managedObjectContext = self.managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"resume"]) {
        SudokuPlayViewController *viewController = segue.destinationViewController;
        [viewController loadSudoku];
        viewController.managedObjectContext = self.managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"show rank"]) {
        SudokuRankRecordCDTVC *sudokuRankRecordCDTVC = segue.destinationViewController;
        sudokuRankRecordCDTVC.managedObjectContext = self.managedObjectContext;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"storedSudoku"] == nil) {
        self.resumeButton.enabled = NO;
    } else {
        self.resumeButton.enabled = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
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
