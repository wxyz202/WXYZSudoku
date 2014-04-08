//
//  SudokuSetting.h
//  WXYZSudoku
//
//  Created by wxyz on 14-4-8.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#ifndef WXYZSudoku_SudokuSetting_h
#define WXYZSudoku_SudokuSetting_h

#define DEMO_OPEN

#define DIFFICULTY_EASY 0
#define DIFFICULTY_NORMAL 1
#define DIFFICULTY_HARD 2
#define DIFFICULTY_NIGHTMARE 3
#define DIFFICULTY_HELL 4



#ifdef DEMO_OPEN


#define DIFFICULTY_DEMO 5

#define ALL_DIFFICULT_ARRAY @[@(DIFFICULTY_EASY),@(DIFFICULTY_NORMAL),@(DIFFICULTY_HARD),@(DIFFICULTY_NIGHTMARE),@(DIFFICULTY_HELL),@(DIFFICULTY_DEMO)]

#define DIFFICULTY_NAME_DICT @{@(DIFFICULTY_EASY):@"Easy",\
    @(DIFFICULTY_NORMAL):@"Normal",\
    @(DIFFICULTY_HARD):@"Hard",\
    @(DIFFICULTY_NIGHTMARE):@"Nightmare",\
    @(DIFFICULTY_HELL):@"Hell",\
    @(DIFFICULTY_DEMO):@"Demo"\
}

#define DIFFICULTY_NAME_ARRAY @[@"Easy",@"Normal",@"Hard",@"Nightmare",@"Hell",@"Demo"]

#else

#define ALL_DIFFICULT_ARRAY @[@(DIFFICULTY_EASY),@(DIFFICULTY_NORMAL),@(DIFFICULTY_HARD),@(DIFFICULTY_NIGHTMARE),@(DIFFICULTY_HELL)]

#define DIFFICULTY_NAME_DICT @{@(DIFFICULTY_EASY):@"Easy",\
    @(DIFFICULTY_NORMAL):@"Normal",\
    @(DIFFICULTY_HARD):@"Hard",\
    @(DIFFICULTY_NIGHTMARE):@"Nightmare",\
    @(DIFFICULTY_HELL):@"Hell"\
}

#define DIFFICULTY_NAME_ARRAY @[@"Easy",@"Normal",@"Hard",@"Nightmare",@"Hell"]


#endif


#endif
