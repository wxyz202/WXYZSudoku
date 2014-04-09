//
//  RankRecord+Create.m
//  WXYZSudoku
//
//  Created by wxyz on 14-3-30.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "RankRecord+Create.h"
#import "UDID.h"

@implementation RankRecord (Create)

+ (RankRecord *)rankRecordWithSudokuID:(NSString *)sudokuID withPlayerID:(NSString *)playerID inManagedObjectContext:(NSManagedObjectContext *)context
{
    RankRecord *record = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RankRecord"];
    request.predicate = [NSPredicate predicateWithFormat:@"playerID = %@ && sudokuID = %@", playerID, sudokuID];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        // handle error
    } else if ([matches count]) {
        record = [matches firstObject];
    } else {
        record = [NSEntityDescription insertNewObjectForEntityForName:@"RankRecord"
                                           inManagedObjectContext:context];
        record.playerID = playerID;
        record.sudokuID = sudokuID;
        record.finishDate = [NSDate date];
        record.finishSeconds = @(NSUIntegerMax);
    }
    return record;
}

@end
