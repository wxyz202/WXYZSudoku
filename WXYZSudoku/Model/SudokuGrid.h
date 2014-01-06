//
//  SudokuGrid.h
//  WXYZSudoku
//
//  Created by wxyz on 14-1-5.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SudokuGridType){
    SudokuGridTypeEmpty,
    SudokuGridTypeConst,
    SudokuGridTypeFilled
};

@interface SudokuGrid : NSObject

@property (nonatomic) NSUInteger value;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isConfilcting) BOOL confilcting;

- (BOOL)isConst;

- (instancetype)initGridEmpty;
- (instancetype)initGridConstWithValue:(NSUInteger)value;

@end
