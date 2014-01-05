//
//  SudokuGridView.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-4.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuGridView.h"

@interface SudokuGridView ()
@property (strong, nonatomic) UIColor *lineColor;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat gridSize;
@property (strong, nonatomic) NSMutableArray *buttons;
@end

@implementation SudokuGridView

- (UIColor *)lineColor
{
    if (!_lineColor) {
        _lineColor = [UIColor blackColor];
    }
    return _lineColor;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.origin = rect.origin;
    self.size = rect.size;
    self.gridSize = [self calGridSize:rect.size];
    [self updateColor];
    [self drawGrids:rect];
}

- (void)updateColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [self.lineColor CGColor]);
}

static const CGFloat LINE_WIDTH = 1.0;
static const CGFloat BOLD_LINE_WIDTH = 2.0;
static const CGFloat EDGE_SIZE = 10.0;

- (CGFloat)calGridSize:(CGSize)size
{
    CGFloat length = MIN(size.width, size.height);
    CGFloat innerLength = length - EDGE_SIZE * 2;
    CGFloat totalGridSize = innerLength - BOLD_LINE_WIDTH * 4 - LINE_WIDTH * 6;
    return totalGridSize / 9;
}

- (void)drawLineWithWidth:(CGFloat)width point1:(CGPoint)point1 point2:(CGPoint)point2
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, width);
    CGContextMoveToPoint(context, point1.x, point1.y);
    CGContextAddLineToPoint(context, point2.x, point2.y);
    CGContextStrokePath(context);
}

- (void)drawBoldLines:(CGRect)rect
{
    CGFloat pos1 = EDGE_SIZE + BOLD_LINE_WIDTH / 2;
    CGFloat pos2 = pos1 + self.gridSize * 3 + LINE_WIDTH * 2 + BOLD_LINE_WIDTH;
    CGFloat pos3 = pos2 + self.gridSize * 3 + LINE_WIDTH * 2 + BOLD_LINE_WIDTH;
    CGFloat pos4 = pos3 + self.gridSize * 3 + LINE_WIDTH * 2 + BOLD_LINE_WIDTH;
    
    CGFloat pos[4] = {pos1, pos2, pos3, pos4};
    CGFloat xpos[4];
    CGFloat ypos[4];
    for (int i = 0; i < 4; i++){
        xpos[i] = pos[i] + rect.origin.x;
        ypos[i] = pos[i] + rect.origin.y;
    }
    for (int i = 0; i < 4; i++){
        [self drawLineWithWidth:BOLD_LINE_WIDTH point1:CGPointMake(xpos[i], ypos[0]) point2:CGPointMake(xpos[i], ypos[3])];
        [self drawLineWithWidth:BOLD_LINE_WIDTH point1:CGPointMake(xpos[0], ypos[i]) point2:CGPointMake(xpos[3], ypos[i])];
    }
}

- (void)drawNormalLines:(CGRect)rect
{
    CGFloat posFirst = EDGE_SIZE + BOLD_LINE_WIDTH / 2;
    CGFloat posLast = posFirst + (self.gridSize * 3 + LINE_WIDTH * 2 + BOLD_LINE_WIDTH) * 3;
    
    CGFloat xposFirst = posFirst + rect.origin.x;
    CGFloat yposFirst = posFirst + rect.origin.y;
    CGFloat xposLast = posLast + rect.origin.x;
    CGFloat yposLast = posLast + rect.origin.y;
    
    CGFloat pos1 = posFirst + BOLD_LINE_WIDTH / 2 + self.gridSize + LINE_WIDTH / 2;
    CGFloat pos2 = pos1 + self.gridSize + LINE_WIDTH;
    CGFloat pos3 = pos2 + self.gridSize * 2 + LINE_WIDTH + BOLD_LINE_WIDTH;
    CGFloat pos4 = pos3 + self.gridSize + LINE_WIDTH;
    CGFloat pos5 = pos4 + self.gridSize * 2 + LINE_WIDTH + BOLD_LINE_WIDTH;
    CGFloat pos6 = pos5 + self.gridSize + LINE_WIDTH;
    
    CGFloat pos[6] = {pos1, pos2, pos3, pos4, pos5, pos6};
    CGFloat xpos[6];
    CGFloat ypos[6];
    for (int i = 0; i < 6; i++){
        xpos[i] = pos[i] + rect.origin.x;
        ypos[i] = pos[i] + rect.origin.y;
    }
    for (int i = 0; i < 6; i++){
        [self drawLineWithWidth:LINE_WIDTH point1:CGPointMake(xpos[i], yposFirst) point2:CGPointMake(xpos[i], yposLast)];
        [self drawLineWithWidth:LINE_WIDTH point1:CGPointMake(xposFirst, ypos[i]) point2:CGPointMake(xposLast, ypos[i])];
    }
}

- (void)drawGrids:(CGRect)rect
{
    [self drawBoldLines:rect];
    [self drawNormalLines:rect];
}

- (void)createButtons
{
    CGFloat pos1 = EDGE_SIZE + BOLD_LINE_WIDTH;
    CGFloat pos2 = pos1 + self.gridSize + LINE_WIDTH;
    CGFloat pos3 = pos2 + self.gridSize + LINE_WIDTH;
    CGFloat pos4 = pos3 + self.gridSize + BOLD_LINE_WIDTH;
    CGFloat pos5 = pos4 + self.gridSize + LINE_WIDTH;
    CGFloat pos6 = pos5 + self.gridSize + LINE_WIDTH;
    CGFloat pos7 = pos6 + self.gridSize + BOLD_LINE_WIDTH;
    CGFloat pos8 = pos7 + self.gridSize + LINE_WIDTH;
    CGFloat pos9 = pos8 + self.gridSize + LINE_WIDTH;
    CGFloat pos[9] = {pos1, pos2, pos3, pos4, pos5, pos6, pos7, pos8, pos9};

    self.buttons = [[NSMutableArray alloc] init];
    for (int row = 0; row < 9; row++) {
        NSMutableArray *rowButtons = [[NSMutableArray alloc] init];
        for (int column = 0; column < 9; column++) {
            CGFloat xstartPos = pos[row] + self.origin.x;
            CGFloat ystartPos = pos[column] + self.origin.y;
            CGRect frame = CGRectMake(xstartPos, ystartPos, self.gridSize, self.gridSize);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = frame;
            [button setTitle:[NSString stringWithFormat:@"%d_%d", row, column] forState:UIControlStateNormal];
            [self addSubview:button];
            [rowButtons addObject:button];
        }
        [self.buttons addObject:rowButtons];
    }
}

- (NSArray *)buttons
{
    if (!_buttons){
        [self createButtons];
    }
    return _buttons;
}

- (UIButton *)getButtonWithRow:(NSUInteger)row withColumn:(NSUInteger)column
{
    return [[self.buttons objectAtIndex:row] objectAtIndex:column];
}

@end
