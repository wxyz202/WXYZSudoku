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

static const int MAX_EMPTY_GRIDS[6] = {35, 40, 50, 60, 65, 1};
static const int MAX_EMPTY_GRIDS_PER_BLOCK[6] = {4, 5, 6, 7, 9, 3};

static const int sudokuCount = 2;

const int initSudoku[sudokuCount][9][9] = {
    {
        {7,1,9,4,8,2,3,6,5},
        {3,2,4,6,7,5,8,9,1},
        {8,5,6,3,9,1,2,7,4},
        {4,8,2,5,6,3,7,1,9},
        {1,3,5,7,2,9,6,4,8},
        {6,9,7,1,4,8,5,2,3},
        {2,4,3,9,5,7,1,8,6},
        {5,6,8,2,1,4,9,3,7},
        {9,7,1,8,3,6,4,5,2},
    },
    {
        {1,4,3,6,2,8,5,7,9},
        {5,7,2,1,3,9,4,6,8},
        {9,8,6,7,5,4,2,3,1},
        {3,9,1,5,4,2,7,8,6},
        {4,6,8,9,1,7,3,5,2},
        {7,2,5,8,6,3,9,1,4},
        {2,3,7,4,8,1,6,9,5},
        {6,1,9,2,7,5,8,4,3},
        {8,5,4,3,9,6,1,2,7},
    }
};

int myrand(int i)
{
    return rand()%i;
}

void myrandOrder(int map[], int start, int end)
{
    for (int i=start; i<=end; i++) {
        map[i]=i;
    }
    random_shuffle(map+start, map+end, myrand);
}

void randomChange(int input[][9])
{
    int map[10],i,j;
    myrandOrder(map, 1, 9);
    for (i=0; i<9; i++) {
        for (j=0; j<9; j++) {
            input[i][j]=map[input[i][j]];
        }
    }
}

void randomArrangeRow(int input[][9])
{
    int map1[3],map2[3],i,j,k,ninput[9][9];
    myrandOrder(map1, 0, 2);
    for (i=0; i<3; i++) {
        myrandOrder(map2, 0, 2);
        for (j=0; j<3; j++) {
            int old_row = i*3 + j;
            int new_row = map1[i]*3 + map2[j];
            for (k=0; k<9; k++) {
                ninput[new_row][k] = input[old_row][k];
            }
        }
    }
    for (i=0; i<9; i++) {
        for (j=0; j<9; j++) {
            input[i][j] = ninput[i][j];
        }
    }
}

void randomArrangeColumn(int input[][9])
{
    int map1[3],map2[3],i,j,k,ninput[9][9];
    myrandOrder(map1, 0, 2);
    for (i=0; i<3; i++) {
        myrandOrder(map2, 0, 2);
        for (j=0; j<3; j++) {
            int old_column = i*3 + j;
            int new_column = map1[i]*3 + map2[j];
            for (k=0; k<9; k++) {
                ninput[k][new_column] = input[k][old_column];
            }
        }
    }
    for (i=0; i<9; i++) {
        for (j=0; j<9; j++) {
            input[i][j] = ninput[i][j];
        }
    }
}


bool check_difficulty(int temp[][9], int difficulty)
{
    int i,j,u,v;
    int empty_grid = 0;
    for (i=0; i<9; i++) {
        for (j=0; j<9; j++) {
            if (temp[i][j]==0) {
                empty_grid++;
            }
        }
    }
    if (empty_grid > MAX_EMPTY_GRIDS[difficulty]) {
        return false;
    }
    for (i=0; i<9; i++) {
        empty_grid = 0;
        for (j=0; j<9; j++) {
            if (temp[i][j]==0) {
                empty_grid++;
            }
        }
        if (empty_grid > MAX_EMPTY_GRIDS_PER_BLOCK[difficulty]) {
            return false;
        }
        empty_grid = 0;
        for (j=0; j<9; j++) {
            if (temp[j][i]==0) {
                empty_grid++;
            }
        }
        if (empty_grid > MAX_EMPTY_GRIDS_PER_BLOCK[difficulty]) {
            return false;
        }
    }
    for (i=0; i<3; i++) {
        for (j=0; j<3; j++) {
            empty_grid = 0;
            for (u=0; u<3; u++) {
                for (v=0; v<3; v++) {
                    if (temp[i*3+u][j*3+v]==0) {
                        empty_grid++;
                    }
                }
            }
            if (empty_grid > MAX_EMPTY_GRIDS_PER_BLOCK[difficulty]) {
                return false;
            }
        }
    }
    return true;
}

int try_time(int count)
{
    return (8-count)*(8-count);
}

void randomRemove(int input[][9], int difficulty)
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
        bool cd = check_difficulty(temp, difficulty);
        if (cd && solve(temp) == 1) {
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
    for (i=0; i<9; i++) {
        for (j=0; j<9; j++) {
            if (input[i][j]!=0) {
                for (int u=0;u<9;u++) {
                    for (int v=0; v<9; v++) {
                        temp[u][v]=input[u][v];
                    }
                }
                temp[i][j]=0;
                bool cd = check_difficulty(temp, difficulty);
                if (cd && solve(temp) == 1) {
                    input[i][j]=0;
                }
            }
        }
    }
}

void generate(int input[][9], int difficulty)
{
    srand((unsigned)time(NULL));
    
    int i,j;
    int sudokuIndex = myrand(sudokuCount);
    for (i = 0; i < 9; i++)
    {
        for (j = 0; j < 9; j++)
        {
            input[i][j]=initSudoku[sudokuIndex][i][j];
        }
    }
    randomChange(input);
    randomArrangeRow(input);
    randomArrangeColumn(input);
    randomRemove(input, difficulty);
}