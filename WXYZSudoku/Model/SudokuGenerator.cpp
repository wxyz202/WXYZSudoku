//
//  SudokuGenerator.cpp
//  WXYZSudoku
//
//  Created by wxyz on 14-1-11.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//

#include <ctime>
#include <cstdlib>
#include <random>
#include "SudokuGenerator.h"
#include "SudokuSolver.h"

using namespace std;

const int initSudoku[9][9] = {
    {7,1,9,4,8,2,3,6,5},
    {3,2,4,6,7,5,8,9,1},
    {8,5,6,3,9,1,2,7,4},
    {4,8,2,5,6,3,7,1,9},
    {1,3,5,7,2,9,6,4,8},
    {6,9,7,1,4,8,5,2,3},
    {2,4,3,9,5,7,1,8,6},
    {5,6,8,2,1,4,9,3,7},
    {9,7,1,8,3,6,4,5,2},
};

int myrand(int i)
{
    return rand()%i;
}

void randomChange(int input[][9])
{
    int map[10],i,j;
    for (i=1;i<=9; i++) {
        map[i]=i;
    }
    random_shuffle(map+1, map+10, myrand);
    for (i=0; i<9; i++) {
        for (j=0; j<9; j++) {
            input[i][j]=map[input[i][j]];
        }
    }
}

int try_time(int count)
{
    return (8-count)*(9-count);
}

void randomRemove(int input[][9])
{
    int i,j;
    int z=7,t;
    int temp[9][9],ex[81],ey[81],ec[81],en;
    t=try_time(z);
    while (z > 0) {
        en=0;
        for (i=0;i<9;i++)
        {
            for (j=0; j<9; j++) {
                temp[i][j]=input[i][j];
                if (temp[i][j]>0) {
                    ex[en]=i;
                    ey[en]=j;
                    ec[en]=en;
                    en++;
                }
            }
        }
        random_shuffle(ec, ec+en, myrand);
        for (i=0; i<z; i++) {
            temp[ex[ec[i]]][ey[ec[i]]]=0;
        }
        int ans = solve(temp);
        if (ans == 1) {
            for (i=0; i<z; i++) {
                input[ex[ec[i]]][ey[ec[i]]]=0;
            }
        } else {
            if (t>0) {
                t--;
            }
            else {
                z--;
                t=try_time(z);
            }
        }
    }
}

void generate(int input[][9])
{
    srand(time(NULL));
    
    int i,j;
    for (i = 0; i < 9; i++)
    {
        for (j = 0; j < 9; j++)
        {
            input[i][j]=initSudoku[i][j];
        }
    }
    randomChange(input);
    randomRemove(input);
}