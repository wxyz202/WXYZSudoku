//
//  SudokuRankRecordCDTVC.m
//  WXYZSudoku
//
//  Created by wxyz on 14-3-30.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuRankRecordCDTVC.h"
#import "RankRecord+Create.h"
#import "SudokuSetting.h"
#import "NSString+SecondsFormat.h"
#import "SudokuViewController.h"
#import "UDID.h"
#import "SudokuServerInterfceConnection.h"


static const NSUInteger SCOPE_LOCAL = 0;
static const NSUInteger SCOPE_GLOBAL = 1;

@interface SudokuRankRecordCDTVC ()

@property (nonatomic, strong) NSNumber *difficulty;
@property (nonatomic, strong) NSNumber *scope;
@property (strong, nonatomic) UISegmentedControl *difficultySegmentedController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *scopeSwitcher;

@end

@implementation SudokuRankRecordCDTVC

#define RECORD_COUNT 20

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.difficulty = [defaults objectForKey:@"rankRecordDifficulty"];
    if (!self.difficulty) {
        self.difficulty = @(DIFFICULTY_EASY);
    }
    if (!self.scope) {
        self.scope = @(SCOPE_LOCAL);
    }
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    [self startFetch];
    [self downloadRecordFromServer];
}

- (void)setDifficulty:(NSNumber *)difficulty
{
    _difficulty = difficulty;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:difficulty forKey:@"rankRecordDifficulty"];
    [defaults synchronize];
    
    [self startFetch];
}

- (void)setScope:(NSNumber *)scope
{
    _scope = scope;
    if (scope.unsignedIntegerValue == SCOPE_LOCAL) {
        self.scopeSwitcher.title = @"Global";
        self.title = @"Local Rank";
    } else {
        self.scopeSwitcher.title = @"Local";
        self.title = @"Global Rank";
    }
    
    [self startFetch];
}

- (void)startFetch
{
    if (self.managedObjectContext == nil || self.difficulty == nil || self.scope == nil) {
        return;
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RankRecord"];
    if (self.scope.unsignedIntegerValue == SCOPE_LOCAL) {
        request.predicate = [NSPredicate predicateWithFormat:@"difficulty = %@ && playerID = %@", self.difficulty, [UDID identifier]];
    } else {
        request.predicate = [NSPredicate predicateWithFormat:@"difficulty = %@", self.difficulty];
    }
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"finishSeconds"
                                                              ascending:YES
                                 ]
                                ];
    request.fetchLimit = RECORD_COUNT;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self performFetch];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Rank Record Cell"];

    RankRecord *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = record.playerName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [NSString stringWithSeconds:record.finishSeconds.unsignedIntegerValue]];
    cell.imageView.image = nil;//[UIImage imageWithData:photo.thumbnail];
    
    if (self.scope.unsignedIntegerValue == SCOPE_GLOBAL && [record.playerID isEqualToString:[UDID identifier]]) {
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.8 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (IBAction)changeDifficulty:(UISegmentedControl *)sender {
    self.difficulty = @(sender.selectedSegmentIndex);
}

- (IBAction)switchScope:(UIBarButtonItem *)sender {
    if (self.scope.unsignedIntegerValue == SCOPE_LOCAL) {
        self.scope = @(SCOPE_GLOBAL);
    } else {
        self.scope = @(SCOPE_LOCAL);
    }
}

- (void)prepareInViewController:(SudokuViewController *)controller withRecord:(RankRecord *)record
{
    [controller loadSudokuWithData:record.sudoku];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"show record"]) {
                [self prepareInViewController:segue.destinationViewController
                                   withRecord:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            }
        }
    }
}

- (UISegmentedControl *)difficultySegmentedController
{
    if (!_difficultySegmentedController) {
        _difficultySegmentedController = [[UISegmentedControl alloc] initWithItems:DIFFICULTY_NAME_ARRAY];
        _difficultySegmentedController.backgroundColor = [UIColor whiteColor];
        CGRect rect = _difficultySegmentedController.frame;
        rect.size.width = self.view.frame.size.width;
        _difficultySegmentedController.frame = rect;
        [_difficultySegmentedController addTarget:self action:@selector(changeDifficulty:) forControlEvents:UIControlEventValueChanged];
    }
    return _difficultySegmentedController;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.difficultySegmentedController;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)downloadRecordFromServer
{
    SudokuServerInterfceConnection *connection = [[SudokuServerInterfceConnection alloc] init];
    for (NSNumber *difficulty in ALL_DIFFICULTY_ARRAY) {
        [connection getTopSudokuRecordWithDifficulty:difficulty delegate:self];
    }
}

- (void)SudokuServerInterfaceConnection:(SudokuServerInterfceConnection*)connection recordList:(NSArray *)recordList
{
    NSLog(@"%d", [recordList count]);
    for (NSDictionary *recordDict in recordList) {
        RankRecord *record = [RankRecord rankRecordWithSudokuID:recordDict[@"sudoku_id"] withPlayerID:recordDict[@"player_id"] inManagedObjectContext:self.managedObjectContext];
        record.difficulty = recordDict[@"difficulty"];
        record.finishDate = recordDict[@"finish_date"];
        record.finishSeconds = recordDict[@"finish_seconds"];
        record.playerName = recordDict[@"player_name"];
        record.sudoku = recordDict[@"sudoku"];
        NSLog(@"%@ %@", record.difficulty, record.playerID);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.difficultySegmentedController.selectedSegmentIndex = self.difficulty.integerValue;
}

@end
