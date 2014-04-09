//
//  SudokuChallengeTableViewController.m
//  WXYZSudoku
//
//  Created by wxyz on 14-4-9.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuChallengeTableViewController.h"
#import "SudokuServerInterfceConnection.h"
#import "UDID.h"
#import "SudokuSetting.h"
#import "NSString+SecondsFormat.h"

@interface SudokuChallengeTableViewController ()
@property (nonatomic, strong) NSArray *challengeRecordList;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *otherRefreshControl;
@end

@implementation SudokuChallengeTableViewController

- (void)downloadChallengeRecordFromServer
{
    SudokuServerInterfceConnection *connection = [[SudokuServerInterfceConnection alloc] init];
    [connection getChallengeSudokuRecordWithPlayerID:[UDID identifier] delegate:self];
}

- (void)SudokuServerInterfaceConnection:(SudokuServerInterfceConnection*)connection recordList:(NSArray *)recordList
{
    self.challengeRecordList = recordList;
    [self.otherRefreshControl stopAnimating];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.otherRefreshControl startAnimating];
    self.otherRefreshControl.hidesWhenStopped = YES;
    [self downloadChallengeRecordFromServer];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.challengeRecordList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Challenge Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Challenge Cell"];
    }
    
    // Configure the cell...
    NSDictionary *record = [self.challengeRecordList objectAtIndex:indexPath.row];
    cell.textLabel.text = DIFFICULTY_NAME_DICT[record[@"difficulty"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [NSString stringWithSeconds:[record[@"finish_seconds"] unsignedIntegerValue]]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
