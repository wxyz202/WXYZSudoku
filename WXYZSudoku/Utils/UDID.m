//
//  UDID.m
//  WXYZSudoku
//
//  Created by wxyz on 14-3-30.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "UDID.h"

@implementation UDID

+ (NSString *)identifier
{
    return  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

@end
