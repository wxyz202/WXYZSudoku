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

#define GET_TOP_SUDOKU_RECORD_URL @"http://wxyz-sudoku.webapp.163.com/top_rank?difficulty=%@"
#define POST_SUDOKU_RECORD_URL @"http://wxyz-sudoku.webapp.163.com/upload_record"

#define TYPE_POST_RECORD @"TYPE_POST_RECORD"
#define TYPE_GET_RECORD @"TYPE_GET_RECORD"


@interface SudokuServerInterfceConnection ()
@property (nonatomic, strong) NSMutableDictionary *connectionPool;
@property (nonatomic) NSUInteger connectionIndex;
@property (nonatomic, weak) id delegate;
@end

@implementation SudokuServerInterfceConnection

- (NSMutableDictionary *)connectionPool
{
    if (!_connectionPool) {
        _connectionPool = [[NSMutableDictionary alloc] init];
        self.connectionIndex = 1;
    }
    return _connectionPool;
}

- (void)startConnection:(NSURLConnection *)connection withType:(NSString *)type
{
    self.connectionPool[@(self.connectionIndex)] = @{@"connection": connection, @"data": [[NSMutableData alloc] init], @"type": type};
    self.connectionIndex++;
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    for (NSNumber *connectionIndex in [self.connectionPool.keyEnumerator allObjects]) {
        NSDictionary *connectionInfo = self.connectionPool[connectionIndex];
        if (connection == connectionInfo[@"connection"]) {
            [connectionInfo[@"data"] appendData:data];
            break;
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    for (NSNumber *connectionIndex in [self.connectionPool.keyEnumerator allObjects]) {
        NSDictionary *connectionInfo = self.connectionPool[connectionIndex];
        if (connection == connectionInfo[@"connection"]) {
            NSString *responseString = [[NSString alloc] initWithData:connectionInfo[@"data"] encoding:NSUTF8StringEncoding];
            
            if ([connectionInfo[@"type"] isEqualToString:TYPE_GET_RECORD]) {
                NSArray *recordList = [self analyzeResponse:responseString];
                NSLog(@"%d", [recordList count]);
                [self.delegate SudokuServerInterfaceConnection:self recordList:recordList];
            }
                 
            break;
        }
    }
}

- (void)SudokuServerInterfaceConnection:(SudokuServerInterfceConnection*)connection recordList:(NSArray *)recordList
{
    
}

- (NSArray *)analyzeResponse:(NSString *)responseString
{
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    NSMutableArray *records = [[NSMutableArray alloc] init];
    
    for (NSDictionary *record in jsonObject[@"result"]) {
        NSMutableDictionary *mutableRecord = [record mutableCopy];
        
        mutableRecord[@"sudoku"] = [[NSData alloc] initWithBase64EncodedString:mutableRecord[@"sudoku"] options:0];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        mutableRecord[@"finish_date"] = [dateFormatter dateFromString:mutableRecord[@"finish_date"]];
        
        [records addObject:[mutableRecord copy]];
    }
    return [records copy];
}

- (NSString *)packPostBody:(RankRecord *)record
{
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
                                           @"sudoku_id": record.sudokuID,
                                           @"timestamp": timestamp
                                           } mutableCopy];
    
    NSString *signOriginalString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", timestamp, record.difficulty, finishDate, record.finishSeconds, record.playerID, record.playerName, sudoku, record.sudokuID, SHARED_KEY];
    postDataDict[@"sign"] = [NSString md5OfString:signOriginalString];
    
    NSString *jsonBody = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:postDataDict options:0 error:NULL] encoding:NSUTF8StringEncoding];
    
    return jsonBody;
}

- (void)postSudokuRecord:(RankRecord *)record delegate:(id)delegate
{
    self.delegate = delegate;
    
    NSString *jsonBody = [self packPostBody:record];
    
    NSURL *url = [NSURL URLWithString:POST_SUDOKU_RECORD_URL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];

    NSData *data = [jsonBody dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];

    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self startConnection:connection withType:TYPE_POST_RECORD];
}

- (void)getTopSudokuRecordWithDifficulty:(NSNumber *)difficulty delegate:(id)delegate
{
    self.delegate = delegate;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:GET_TOP_SUDOKU_RECORD_URL, difficulty]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self startConnection:connection withType:TYPE_GET_RECORD];
}

@end
