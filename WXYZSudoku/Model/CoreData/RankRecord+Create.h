//
//  RankRecord+Create.h
//  WXYZSudoku
//
//  Created by wxyz on 14-3-30.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "RankRecord.h"
#import "Sudoku.h"

@interface RankRecord (Create)
+ (RankRecord *)newRankRecordInManagedObjectContext:(NSManagedObjectContext *)context;
@end
