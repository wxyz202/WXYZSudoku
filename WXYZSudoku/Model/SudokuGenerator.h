//
//  SudokuGenerator.h
//  WXYZSudoku
//
//  Created by wxyz on 14-1-11.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#ifndef WXYZSudoku_SudokuGenerator_h
#define WXYZSudoku_SudokuGenerator_h

const int DIFFICULTY_EASY = 0;
const int DIFFICULTY_NORMAL = 1;
const int DIFFICULTY_HARD = 2;

void generate(int input[][9], int difficulty=DIFFICULTY_NORMAL);

#endif
