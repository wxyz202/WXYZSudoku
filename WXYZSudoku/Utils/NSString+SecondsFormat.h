//
//  NSString+SecondsFormat.h
//  WXYZSudoku
//
//  Created by wxyz on 14-3-31.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SecondsFormat)
+ (NSString *)stringWithSeconds:(NSUInteger)seconds;
+ (NSString *)stringWithSecondsInShort:(NSUInteger)seconds;
@end
