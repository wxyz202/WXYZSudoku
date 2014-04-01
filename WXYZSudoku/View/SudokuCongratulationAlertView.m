//
//  SudokuCongratulationAlertView.m
//  WXYZSudoku
//
//  Created by wxyz on 14-1-29.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import "SudokuCongratulationAlertView.h"

@interface SudokuCongratulationAlertView ()
@property (nonatomic, strong, readonly) UITextField *nameTextField;
@end

@implementation SudokuCongratulationAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle defaultName:(NSString *)defaultName {
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles: otherButtonTitle, nil];
    
    if (self) {
        self.alertViewStyle = UIAlertViewStylePlainTextInput;
        self.nameTextField.text = defaultName;
    }
    
    return self;
}

- (UITextField *)nameTextField
{
    return [self textFieldAtIndex:0];
}

- (NSString *)inputName
{
    return self.nameTextField.text;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
