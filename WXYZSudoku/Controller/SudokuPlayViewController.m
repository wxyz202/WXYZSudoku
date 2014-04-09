//
//  SudokuPlayViewController.m
//  WXYZSudoku
//
//  Created by wxyz on 14-3-31.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuPlayViewController.h"
#import "SudokuCongratulationAlertView.h"
#import "RankRecord+Create.h"
#import "NSString+SecondsFormat.h"
#import "SudokuColorAlertView.h"
#import "KxMenu.h"
#import "UDID.h"
#import "SudokuServerInterfceConnection.h"

@interface SudokuPlayViewController () <CustomIOS7AlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *clearGridButton;
@property (strong, nonatomic) NSTimer *oneSecondTimer;

@end

static const NSInteger RESTART_ALERT_VIEW_TAG = 101;
static const NSInteger CONGRATULATION_ALERT_VIEW_TAG = 102;
static const NSInteger CHOOSE_COLOR_ALERT_VIEW_TAG = 103;
static const NSInteger CLEAR_COLOR_ALERT_VIEW_TAG = 104;

@implementation SudokuPlayViewController

- (void)newGameWithDifficulty:(NSUInteger)difficulty
{
    self.sudoku = [[Sudoku alloc] initWithDifficulty:difficulty];
    [self saveSudoku];
    [self updateTitleWithDifficulty:difficulty];
}

# pragma mark - store sudoku

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

- (void)removeSavedSudoku
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"storedSudoku"];
    [defaults synchronize];
}

# pragma mark - store playername

- (void)savePlayerName:(NSString *)name
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:@"storedPlayerName"];
    [defaults synchronize];
}

- (NSString *)loadPlayerName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"storedPlayerName"];
}

# pragma mark - play

- (IBAction)chooseNumber:(UIButton *)sender {
    [self.sudoku fillChosenGridWithValue:[sender.currentTitle intValue]];
    [self saveSudoku];
    [self updateUI];
    if ([self.sudoku isFinished]) {
        [self.sudoku clearAllGridsStatus];
        [self updateUI];
        self.sudoku.finishSeconds = self.sudoku.playSeconds;
        [self finish];
        SudokuCongratulationAlertView *congratulationView = [[SudokuCongratulationAlertView alloc] initWithTitle:@"Congratulaion!" message:[NSString stringWithFormat:@"Solve in %@. Please input your name.", [NSString stringWithSeconds:self.sudoku.finishSeconds]] delegate:self cancelButtonTitle:nil otherButtonTitle:@"OK" defaultName:[self loadPlayerName]];
        congratulationView.tag = CONGRATULATION_ALERT_VIEW_TAG;
        [congratulationView show];
    }
}

- (IBAction)clearGrid {
    [self.sudoku clearChosenGrid];
    [self saveSudoku];
    [self updateUI];
}

- (IBAction)clickUndoButton {
    [super clickUndoButton];
    [self saveSudoku];
}

- (IBAction)clickRedoButton {
    [super clickRedoButton];
    [self saveSudoku];
}

# pragma mark - ui
- (void)updateUI
{
    [super updateUI];
    for (NSUInteger value = 1; value <= 9; value++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:value];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.enabled = YES;
        if ([self.sudoku gridsWithValueFinish:value]) {
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.enabled = NO;
        }
    }
}

- (IBAction)showMoreMenu:(UIBarButtonItem *)sender {
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"Restart"
                     image:nil
                    target:self
                    action:@selector(clickRestartButton)],
      
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

# pragma mark - change color

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (((UIView *)alertView).tag == CHOOSE_COLOR_ALERT_VIEW_TAG) {
        if ([alertView isConfirmChangeColorButton:buttonIndex]) {
            self.sudoku.currentTraceGroup = ((SudokuColorAlertView *)alertView).chosenColorIndex;
        }
    } else if (((UIView *)alertView).tag == CLEAR_COLOR_ALERT_VIEW_TAG) {
        if ([alertView isConfirmChangeColorButton:buttonIndex]) {
            [self.sudoku clearGridWithTraceGroup:((SudokuColorAlertView *)alertView).chosenColorIndex];
            [self updateUI];
        }
    }
    [alertView close];
}

- (void)clickChooseColorButton {
    SudokuColorAlertView *alertView = [[SudokuColorAlertView alloc] initWithTitle:@"Choose Pen Color" withColorArray:[SudokuGridView normalGridTitleColorArray] currentColorIndex:self.sudoku.currentTraceGroup];
    alertView.tag = CHOOSE_COLOR_ALERT_VIEW_TAG;
    [alertView setDelegate:self];
    [alertView show];
}

- (void)clickClearColorButton {
    SudokuColorAlertView *alertView = [[SudokuColorAlertView alloc] initWithTitle:@"Choose a Color to Clear" withColorArray:[SudokuGridView normalGridTitleColorArray] currentColorIndex:self.sudoku.currentTraceGroup];
    alertView.tag = CLEAR_COLOR_ALERT_VIEW_TAG;
    [alertView setDelegate:self];
    [alertView show];
}

# pragma mark - restart and finish

- (void)finish {
    [self pause];
    [self.undoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.undoButton.enabled = NO;
    [self.redoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.redoButton.enabled = NO;
    self.clearGridButton.enabled = NO;
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
        if ([congratulationAlertView.inputName isEqualToString:@""] || [congratulationAlertView.inputName length] > 64) {
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
        [self resetSudokuView];
        [self resume];
        self.alreadyAnimate = NO;
        [self updateUI];
    } else if (alertView.tag == CONGRATULATION_ALERT_VIEW_TAG) {
        SudokuCongratulationAlertView *congratulationAlertView = (SudokuCongratulationAlertView *)alertView;
        NSString *playerName = congratulationAlertView.inputName;
        [self savePlayerName:playerName];
        NSUInteger finishSeconds = self.sudoku.finishSeconds;
        [self addRecordWithPlayerName:playerName withFinishSeconds:@(finishSeconds)];
        [self.sudokuView jumpButtons];
    }
}

- (void)addRecordWithPlayerName:(NSString *)playerName withFinishSeconds:(NSNumber *)finishSeconds
{
    RankRecord *record = [RankRecord rankRecordWithSudokuID:self.sudoku.identifier withPlayerID:[UDID identifier] inManagedObjectContext:self.managedObjectContext];
    if ([finishSeconds unsignedIntegerValue] < [record.finishSeconds unsignedIntegerValue]) {
        //
        record.sudoku = [NSKeyedArchiver archivedDataWithRootObject:self.sudoku];
        record.playerName = playerName;
        record.finishSeconds = finishSeconds;
        record.difficulty = @(self.sudoku.difficulty);
    }
    
    [self sendSudokuRecordToServer:record];
}

- (void)resetSudokuView
{
    [self.sudokuView resetGrid];
    [self.sudokuView setNeedsDisplay];
    [self createSubView];
}

# pragma mark - timer

static const NSUInteger SECONDS_FOR_AUTO_SAVE = 10;

- (void)passOneSecond:(NSTimer *)timer
{
    self.sudoku.playSeconds++;
    if (self.sudoku.playSeconds % SECONDS_FOR_AUTO_SAVE == 0) {
        [self saveSudoku];
    }
    self.title = [NSString stringWithSecondsInShort:self.sudoku.playSeconds];
}

- (void)pause
{
    [self.oneSecondTimer setFireDate:[NSDate distantFuture]];
}

- (void)resume
{
    [self.oneSecondTimer setFireDate:[NSDate distantPast]];
}


# pragma mark - SudokuServerInterfceConnection

- (void)sendSudokuRecordToServer:(RankRecord *)record
{
    SudokuServerInterfceConnection *connection = [[SudokuServerInterfceConnection alloc] init];
    [connection postSudokuRecord:record delegate:self];
}

# pragma mark - other

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.oneSecondTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(passOneSecond:) userInfo:nil repeats:YES];
    [self pause];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resume];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (!self.sudoku.isFinished) {
        [self saveSudoku];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self pause];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
