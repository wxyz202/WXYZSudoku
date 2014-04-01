//
//  SudokuRankRecordCDTVC.m
//  WXYZSudoku
//
//  Created by wxyz on 14-3-30.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuRankRecordCDTVC.h"
#import "RankRecord.h"
#import "SudokuGenerator.h"
#import "NSString+SecondsFormat.h"
#import "SudokuViewController.h"

@interface SudokuRankRecordCDTVC ()

@property (nonatomic, strong) NSNumber *difficulty;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedController;

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
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (self.managedObjectContext != nil && self.difficulty != nil) {
        [self startFetch];
    }
}

- (void)setDifficulty:(NSNumber *)difficulty
{
    _difficulty = difficulty;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:difficulty forKey:@"rankRecordDifficulty"];
    [defaults synchronize];
    
    if (self.managedObjectContext != nil && self.difficulty != nil) {
        [self startFetch];
    }
}

- (void)startFetch
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RankRecord"];
    request.predicate = [NSPredicate predicateWithFormat:@"difficulty = %@", self.difficulty];
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
    
    return cell;
}

- (IBAction)changeDifficulty:(UISegmentedControl *)sender {
    self.difficulty = @(sender.selectedSegmentIndex);
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.difficultySegmentedController.selectedSegmentIndex = self.difficulty.integerValue;
}

@end
