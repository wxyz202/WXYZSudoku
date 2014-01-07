//
//  SudokuGrid.h
//  WXYZSudoku
//
//  Created by wxyz on 14-1-5.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SudokuGrid : NSObject

@property (nonatomic) NSUInteger value;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isRelated) BOOL related;
@property (nonatomic, getter = isConfilcting) BOOL confilcting;
@property (nonatomic, readonly, getter = isConstant) BOOL constant;
@property (nonatomic, getter = isFilled) BOOL filled;

- (instancetype)initGridEmpty;
- (instancetype)initGridConstWithValue:(NSUInteger)value;

@end
