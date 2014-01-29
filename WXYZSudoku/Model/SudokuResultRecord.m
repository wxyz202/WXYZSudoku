//
//  SudokuResultRecord.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-29.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuResultRecord.h"
#import "SudokuGenerator.h"

static NSUInteger MAX_RECORD_PER_DIFFICULTY = 10;

@interface SudokuResultRecord ()
@property (nonatomic, strong, readwrite) NSString *playerName;
@property (nonatomic, readwrite) NSUInteger playSeconds;
@property (nonatomic, strong, readwrite) NSDate *date;
@end

@implementation SudokuResultRecord

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.playerName forKey:@"playerName"];
    [encoder encodeObject:@(self.playSeconds) forKey:@"playSeconds"];
    [encoder encodeObject:self.date forKey:@"date"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.playerName = [decoder decodeObjectForKey:@"playerName"];
        self.playSeconds = [[decoder decodeObjectForKey:@"playSeconds"] unsignedIntegerValue];
        self.date = [decoder decodeObjectForKey:@"date"];
    }
    return self;
}

- (instancetype)initWithPlayerName:(NSString *)playerName playSeconds:(NSUInteger)playSeconds
{
    self = [super init];
    if (self) {
        self.playerName = playerName;
        self.playSeconds = playSeconds;
        self.date = [NSDate date];
    }
    return self;
}

- (NSComparisonResult)compare:(SudokuResultRecord *)otherObject
{
    if (self.playSeconds == otherObject.playSeconds) {
        return [self.date compare:otherObject.date];
    } else if (self.playSeconds < otherObject.playSeconds) {
        return NSOrderedAscending;
    } else {
        return NSOrderedDescending;
    }
}

- (BOOL)isEqual:(SudokuResultRecord *)object {
    return ([self compare:object] == NSOrderedSame);
}

@end


@interface SudokuResultRecordCollection ()
@property (nonatomic, strong) NSMutableDictionary *recordDict;
@end

@implementation SudokuResultRecordCollection

+ (NSMutableDictionary *)getRecordDict {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *recordData = [defaults objectForKey:@"sudokuResultRecord"];
    NSMutableDictionary *recordDict;
    if (!recordData) {
        recordDict = [[NSMutableDictionary alloc] init];
        [recordDict setObject:[[NSMutableArray alloc] init] forKey:@((NSUInteger)DIFFICULTY_EASY)];
        [recordDict setObject:[[NSMutableArray alloc] init] forKey:@((NSUInteger)DIFFICULTY_NORMAL)];
        [recordDict setObject:[[NSMutableArray alloc] init] forKey:@((NSUInteger)DIFFICULTY_HARD)];
    } else {
        recordDict = [NSKeyedUnarchiver unarchiveObjectWithData:recordData];
    }
    return recordDict;
}

+ (void)saveRecordDict:(NSMutableDictionary *)recordDict {
    NSData *recordData = [NSKeyedArchiver archivedDataWithRootObject:recordDict];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:recordData forKey:@"sudokuResultRecord"];
    [defaults synchronize];
}

+ (void)addSudokuRecord:(SudokuResultRecord *)record difficulty:(NSUInteger)difficulty
{
    NSMutableDictionary *recordDict = [SudokuResultRecordCollection getRecordDict];
    NSMutableArray *currentDifficultyRecords = [recordDict objectForKey:@(difficulty)];
    [currentDifficultyRecords addObject:record];
    [currentDifficultyRecords sortUsingSelector:@selector(compare:)];
    if ([currentDifficultyRecords count] > MAX_RECORD_PER_DIFFICULTY) {
        [currentDifficultyRecords removeLastObject];
    }
    [SudokuResultRecordCollection saveRecordDict:recordDict];
}

@end