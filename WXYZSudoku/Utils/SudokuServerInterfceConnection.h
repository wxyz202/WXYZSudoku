//
//  SudokuServerInterfceConnection.h
//  WXYZSudoku
//
//  Created by wxyz on 14-4-8.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RankRecord.h"


@interface SudokuServerInterfceConnection : NSObject

- (void)postSudokuRecord:(RankRecord *)record delegate:(id)delegate;

@end
