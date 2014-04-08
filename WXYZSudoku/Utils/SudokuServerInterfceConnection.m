//
//  SudokuServerInterfceConnection.m
//  WXYZSudoku
//
//  Created by wxyz on 14-4-8.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuServerInterfceConnection.h"
#import "NSString+MD5.h"

#define SHARED_KEY @"$F$#GagG#GgGH("

#define POST_SUDOKU_RECORD_URL @"http://wxyz-sudoku.webapp.163.com/upload_record"

@interface SudokuServerInterfceConnection ()
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, weak) id delegate;
@end

@implementation SudokuServerInterfceConnection

- (NSMutableData *)data
{
    if (!_data) {
        _data = [[NSMutableData alloc] init];
    }
    return _data;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"receive!");
    NSLog(@"%@", [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]);
}

- (void)postSudokuRecord:(RankRecord *)record delegate:(id)delegate
{
    self.delegate = delegate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *finishDate = [dateFormatter stringFromDate:record.finishDate];
    NSString *sudoku = [record.sudoku base64EncodedStringWithOptions:0];
    NSNumber *timestamp =  @((NSUInteger)[[NSDate date] timeIntervalSince1970]);
    
    NSMutableDictionary *postDataDict = [@{
        @"difficulty": record.difficulty,
        @"finish_date": finishDate,
        @"finish_seconds": record.finishSeconds,
        @"player_id": record.playerID,
        @"player_name": record.playerName,
        @"sudoku": sudoku,
        @"timestamp": timestamp
    } mutableCopy];
    
    NSString *signOriginalString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", timestamp, record.difficulty, finishDate, record.finishSeconds, record.playerID, record.playerName, sudoku, SHARED_KEY];
    postDataDict[@"sign"] = [NSString md5OfString:signOriginalString];
    
    NSString *jsonBody = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:postDataDict options:0 error:NULL] encoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:POST_SUDOKU_RECORD_URL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];

    NSData *data = [jsonBody dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];

    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
}

@end
