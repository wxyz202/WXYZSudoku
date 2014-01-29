//
//  SudokuResultRecord.h
//  WXYZSudoku
//
//  Created by wxyz on 14-1-29.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SudokuResultRecord : NSObject

@property (nonatomic, strong, readonly) NSString *playerName;
@property (nonatomic, readonly) NSUInteger playSeconds;
@property (nonatomic, strong, readonly) NSDate *date;

- (instancetype)initWithPlayerName:(NSString *)playerName playSeconds:(NSUInteger)playSeconds;

@end


@interface SudokuResultRecordCollection : NSObject

+ (void)addSudokuRecord:(SudokuResultRecord *)record difficulty:(NSUInteger)difficulty;

@end