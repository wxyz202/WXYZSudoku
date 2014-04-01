//
//  SudokuCongratulationAlertView.h
//  WXYZSudoku
//
//  Created by wxyz on 14-1-29.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SudokuCongratulationAlertView : UIAlertView

@property (nonatomic, strong, readonly) NSString *inputName;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle defaultName:(NSString *)defaultName;

@end
