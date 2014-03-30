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

@end

@implementation SudokuRankRecordCDTVC

#define RECORD_COUNT 20

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.difficulty = @(DIFFICULTY_EASY);
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

- (void)prepareInViewController:(SudokuViewController *)controller withRecord:(RankRecord *)record
{
    [controller loadSudokuWithData:record.sudoku];
    controller.restartButton.enabled = NO;
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

@end
