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

+ (RankRecord *)newRankRecordInManagedObjectContext:(NSManagedObjectContext *)context
{
    RankRecord *record = [NSEntityDescription insertNewObjectForEntityForName:@"RankRecord"
                                           inManagedObjectContext:context];
    
    record.finishDate = [NSDate date];
    record.playerID = [UDID identifier];
    
    return record;
}

@end
