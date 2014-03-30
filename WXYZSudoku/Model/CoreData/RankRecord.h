//
//  RankRecord.h
//  WXYZSudoku
//
//  Created by wxyz on 14-3-30.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RankRecord : NSManagedObject

@property (nonatomic, retain) NSString * playerID;
@property (nonatomic, retain) NSString * playerName;
@property (nonatomic, retain) NSNumber * finishSecond;
@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSString * sudokuID;
@property (nonatomic, retain) NSNumber * difficulty;

@end
