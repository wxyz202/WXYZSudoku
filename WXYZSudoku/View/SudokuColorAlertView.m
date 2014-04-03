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
@property (nonatomic, readwrite) NSUInteger chosenColorIndex;

@end

static const NSInteger COLOR_BUTTON_TAG_BASE = 1000;

@implementation SudokuColorAlertView

- (instancetype)initWithColorArray:(NSArray *)colorArray currentColorIndex:(NSUInteger)currentColorIndex;
{
    self = [super init];
    self.colorArray = colorArray;
    self.chosenColorIndex = currentColorIndex;
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
    [self addTitleView];
    [self addColorView];
}

- (void)addTitleView
{
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Choose Your Pen Color" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:[UIFont labelFontSize]]}];
    CGRect rect = self.dialogView.bounds;
    rect.size.height /= 5.0;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:rect];
    titleLabel.attributedText = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    [self.dialogView addSubview:titleLabel];
}

- (void)addColorView
{
    CGFloat size = 50.0;
    CGFloat space = 10.0;
    CGFloat borderSpace = (self.dialogView.bounds.size.width - (size * [self.colorArray count] + space * ([self.colorArray count] - 1))) / 2;
    for (NSInteger i = 0; i < [self.colorArray count]; i++) {
        CGRect rect = CGRectMake(borderSpace + (size + space) * i, self.dialogView.bounds.size.height / 2 - size / 2, size, size);
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        button.tag = i + COLOR_BUTTON_TAG_BASE;
        [button setTitle:@"6" forState:UIControlStateNormal];
        [button setTitleColor:self.colorArray[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:25.0]];
        //button.backgroundColor = self.colorArray[i];
        [button addTarget:self action:@selector(chooseColor:) forControlEvents:UIControlEventTouchUpInside];
        [self.dialogView addSubview:button];
    }
    [self showChosen];
}

- (void)chooseColor:(UIButton *)sender
{
    self.chosenColorIndex = sender.tag - COLOR_BUTTON_TAG_BASE;
    [self showChosen];
}

- (void)showChosen
{
    for (NSInteger i = 0; i < [self.colorArray count]; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i+COLOR_BUTTON_TAG_BASE];
        [button.layer setBorderWidth:1.0];
        [button.layer setBorderColor:[UIColor blackColor].CGColor];
    }
    UIButton *button = (UIButton *)[self viewWithTag:self.chosenColorIndex+COLOR_BUTTON_TAG_BASE];
    [button.layer setBorderWidth:5.0];
    [button.layer setBorderColor:[UIColor blueColor].CGColor];
}

- (BOOL)isConfirmChangeColorButton:(NSInteger)buttonIndex
{
    return [[SudokuColorAlertView buttonTitles][buttonIndex] isEqualToString:[SudokuColorAlertView buttonOKTitles]];
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
