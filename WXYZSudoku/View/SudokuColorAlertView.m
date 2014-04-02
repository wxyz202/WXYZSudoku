//
//  SudokuColorAlertView.m
//  WXYZSudoku
//
//  Created by wxyz on 14-4-2.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuColorAlertView.h"

@interface SudokuColorAlertView ()

@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic) NSUInteger chosenColorIndex;

@end

@implementation SudokuColorAlertView

- (instancetype)initWithColorArray:(NSArray *)colorArray currentColor:(UIColor *)currentColor
{
    self = [super init];
    self.colorArray = colorArray;
    self.chosenColorIndex = [colorArray indexOfObject:currentColor];
    [self setButtonTitles:[SudokuColorAlertView buttonTitles]];
    return self;
}

+ (NSArray *)buttonTitles
{
    return @[[SudokuColorAlertView buttonCancelTitles], [SudokuColorAlertView buttonOKTitles]];
}

+ (NSString *)buttonOKTitles
{
    return @"OK";
}

+ (NSString *)buttonCancelTitles
{
    return @"Cancel";
}

- (void)show
{
    [super show];
    [self setContentView];
}

- (void)setContentView
{
    // TODO: draw the contentView
    NSLog(@"%@", NSStringFromCGRect(self.dialogView.bounds));
}

- (void)addTitleView
{
    
}

- (void)addColorView
{
    self.dialogView.backgroundColor = [UIColor blackColor];
}

- (BOOL)isConfirmChangeColorButton:(NSInteger)buttonIndex
{
    return [[SudokuColorAlertView buttonTitles][buttonIndex] isEqualToString:[SudokuColorAlertView buttonOKTitles]];
}

- (UIColor *)chosenColor
{
    return self.colorArray[self.chosenColorIndex];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
