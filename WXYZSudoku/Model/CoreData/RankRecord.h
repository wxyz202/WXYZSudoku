//
//  RankRecord.h
//  WXYZSudoku
//
//  Created by wxyz on 14-4-9.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RankRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * difficulty;
@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSNumber * finishSeconds;
@property (nonatomic, retain) NSString * playerID;
@property (nonatomic, retain) NSString * playerName;
@property (nonatomic, retain) NSData * sudoku;
@property (nonatomic, retain) NSString * sudokuID;

@end
