//
//  SudokuGenerator.h
//  WXYZSudoku
//
//  Created by wxyz on 14-1-11.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#ifndef WXYZSudoku_SudokuGenerator_h
#define WXYZSudoku_SudokuGenerator_h

extern const int DIFFICULTY_EASY;
extern const int DIFFICULTY_NORMAL;
extern const int DIFFICULTY_HARD;
extern const int DIFFICULTY_NIGHTMARE;
extern const int DIFFICULTY_HELL;
extern const int DIFFICULTY_DEMO;

void generate(int input[][9], int difficulty);

#endif
