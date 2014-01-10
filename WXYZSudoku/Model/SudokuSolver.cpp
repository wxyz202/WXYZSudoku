//
//  SudokuSolver.cpp
//  WXYZSudoku
//
//  Created by wxyz on 14-1-10.
//  Copyright (c) 2014年 wxyz. All rights reserved.
//
//  Copied from tudejian

#include "SudokuSolver.h"

#include<stdio.h>
#include<string.h>
#include<algorithm>
using namespace std;
const int maxn=10;
const int INF=1<<20;

struct Node{
	int r,c,b;
} node[maxn*maxn];

int map[maxn][maxn];
int res[maxn][maxn];
int row[maxn];
int col[maxn];
int block[maxn];
int ncount,ans;
int ep[1<<10];
int lis[1<<10][maxn];
int len[1<<10];

int Column(int c)
{
	if(c<3) return 0;
	else if(c<6) return 1;
	else return 2;
}

int Block(int r,int c)
{
	if(r<3) return Column(c);
	else if(r<6) return Column(c)+3;
	else return Column(c)+6;
}

void Preprocess()
{
	int i,j,n,k=(1<<9)-1;
	for(i=0;i<k;i++)
	{
		n=i;
		for(j=0;j<9;j++)
		{
			if(!(n&1)) ep[i]++,lis[i][len[i]++]=j;
			n>>=1;
		}
	}
}

void search(int cur)
{
	if(cur==ncount)
	{
		ans++;
		if(ans==1) memcpy(res,map,sizeof(map));
		return ;
	}
	int i,j,k,pos,r=node[cur].r,c=node[cur].c,b=node[cur].b,min;
	Node t;
	if(cur+6<ncount)
	{
		min=INF;
		for(j=cur+1;j<=cur+6;j++)
		{
            k=ep[row[node[j].r]|col[node[j].c]|block[node[j].b]];
            if(min>k) {min=k; pos=j;}
		}
		if(pos!=cur+1) { t=node[cur+1]; node[cur+1]=node[pos]; node[pos]=t; }
	}
	k=row[r]|col[c]|block[b];
	for(j=0;j<len[k];j++)
	{
		i=lis[k][j];
		row[r]^=(1<<i); col[c]^=(1<<i); block[b]^=(1<<i);
		map[r][c]=i+1;
		search(cur+1);
		row[r]^=(1<<i); col[c]^=(1<<i); block[b]^=(1<<i);
	}
}

int F(Node a)
{
	return ep[row[a.r]|col[a.c]|block[a.b]];
}

bool compare(Node a,Node b)
{
	return F(a)<F(b);
}

int solve(int input[][9])
{
	int i,j;
	Preprocess();
    
    memset(row,0,sizeof(row));
    memset(col,0,sizeof(col));
    memset(block,0,sizeof(block));
    ncount=0;
    for(i=0;i<9;i++)
        for(j=0;j<9;j++)
        {
            if(input[i][j]==0)
                map[i][j]=0, node[ncount].r=i, node[ncount].c=j, node[ncount++].b=Block(i,j);
            else
                map[i][j]=input[i][j], row[i]^=1<<(map[i][j]-1),col[j]^=1<<(map[i][j]-1),block[Block(i,j)]^=1<<(map[i][j]-1);
        }
    sort(node,node+ncount,compare);
    ans=0;
    search(0);
    
    for(i=0;i<9;i++)
    {
        for(j=0;j<9;j++)
            input[i][j]=res[i][j];
    }
    
    return ans;
}