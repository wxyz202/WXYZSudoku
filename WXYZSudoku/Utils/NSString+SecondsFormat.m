//
//  NSString+SecondsFormat.m
//  WXYZSudoku
//
//  Created by wxyz on 14-3-31.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "NSString+SecondsFormat.h"

@implementation NSString (SecondsFormat)

+ (NSString *)stringWithSeconds:(NSUInteger)seconds
{
    NSUInteger minute = seconds / 60;
    NSUInteger second = seconds % 60;
    if (minute > 0) {
        return [NSString stringWithFormat:@"%@ minutes %@ seconds", @(minute), @(second)];
    } else {
        return [NSString stringWithFormat:@"%@ seconds", @(second)];
    }
}

+ (NSString *)stringWithSecondsInShort:(NSUInteger)seconds
{
    int minute = seconds / 60;
    int second = seconds % 60;
    return [NSString stringWithFormat:@"%d:%02d", minute, second];
}

@end
