// Data Generator by Rujia Liu
// DO NOT beat me, this problems is NOT written by me...
// Problem by Chen Hong
// Solutions by Fu Wenjie and Yu Wei
// Grading method by Zhang Yifei

#include<stdio.h>
#include<stdlib.h>
#include<assert.h>
#include<string.h>

// Graph Types
#define GRAPH_TYPE_ANY      0
#define GRAPH_TYPE_TREE     1
#define GRAPH_TYPE_STAR     2
#define GRAPH_TYPE_RING     3


/*
  Test Cases:

  n < 100:
  Case 1: from zyf
  Case 2: from zyf
  Case 3: n = 12, m = 3, density = 50, Skill = 1~2
  Case 4: n = 20, m = 100, density = 100, skill = 0~100 
  
  n = 100:
  Case 5:  Tree, Skill = 1~10
  Case 6:  Density = 100, Skill = 1~10
  Case 7:  Ring, Skill = 0~5             
  Case 8:  Star, Brach = 10; animal 1 with high B. (last time, 9 teaches 1!)
  Case 9:  Density = 8,  Skill = 1
  Case 10: Density = 70, Skill = 1~3

*/

// parameters
int n = 100;
int m = 20;
int density = 100;              // for genral graph
int branch = 10;                // for star
int gr_type = GRAPH_TYPE_TREE;
int skill_lower_bound = 1;
int skill_upper_bound = 10;

// Skill
int forbidden[100];
int know[100][100];
int skill_ok[100];

// Graph
int gr[100][100];
int degree[100];
int mark[100];
int last[100];
int edgecount;

void dfs(int u)
{
	int i;
	mark[u] = 1;
	for(i = 0; i < n; i++)
		if(gr[u][i] && !mark[i]) dfs(i);
}

void main()
{
	FILE *fp;
	int i, j, k, count;
	
	// I don't use srand
	fp = fopen("star.in","w");
	assert(fp != NULL);
	
/*  -----------------------------   Graph Generation ------------------------  */
	memset(gr, 0, sizeof(gr));
	memset(forbidden, 0, sizeof(forbidden));
	switch(gr_type){
		case GRAPH_TYPE_ANY:
			for(i = 0; i < n; i++)
				for(j = i + 1; j < n; j++)
					gr[i][j] = gr[j][i] = (rand() % 100 < density);

			// Make it connected
			while(1){
				memset(mark, 0, sizeof(mark));
				dfs(0);
				for(i = 0; i < n; i++)
					if(!mark[i]) break;         // unmarked vertex
				if(i == n || mark[i]) break;
				else{
					while(1){					// find a vertex in the set v(1)
						j = rand() % n;
						if(mark[j]) break;
					}
					gr[i][j] = gr[j][i] = 1;	// connect
				}
			}
			break;
		
		case GRAPH_TYPE_TREE:
			memset(mark, 0, sizeof(mark));
			memset(degree, 0 ,sizeof(degree));
			mark[0] = 1;
			for(i = 0; i < n - 1; i++){
				while(1){
					j = rand() % n;
					if(mark[j]) break;
				}
				while(1){
					k = rand() % n;
					if(!mark[k]) break;
				}
				gr[j][k] = gr[k][j] = 1;
				degree[j]++;
				degree[k]++;
				mark[k] = 1;
			}
			for(i = 0; i < n; i++)
				if(degree[i] > 1) forbidden[i] = 1;
			break;
		
		case GRAPH_TYPE_STAR:
			for(i = 1; i < branch; i++){
				gr[0][i] = gr[i][0] = 1;
				last[i-1] = i;
			}
			for(i = branch; i < n; i++){		// connect to the end of a chain
				j = rand() % branch;
				gr[i][last[j]] = gr[last[j]][i] = 1;
				last[j] = i;
			}
			for(i = 0; i < branch; i++)
				forbidden[last[i]] = 1;
			for(i = 0; i < n; i++)
				forbidden[i] = 1 - forbidden[i];
			break;

		case GRAPH_TYPE_RING:
			for(i = 0; i < n; i++)
				gr[i][(i+1)%n] = gr[(i+1)%n][i] = 1;
			break;
	}

	edgecount = 0;
	for(i = 0; i < n; i++)
		for(j = i + 1; j < n; j++)
			if(gr[i][j]) edgecount++;

/*  ----------------  Skills Generation ----------------------  */
	memset(know, 0, sizeof(know));
	memset(skill_ok, 0, sizeof(skill_ok));
	for(i = 0; i < n; i++){
		if(forbidden[i]) continue;
		count = rand() % (skill_upper_bound - skill_lower_bound + 1) + skill_lower_bound;
		for(j = 0; j < count; j++)
			while(1){
				k = rand() % m;
				if(!know[i][k]){
					know[i][k] = 1;
					skill_ok[k] = 1;
					break;
				}
			}

	}
	// Check if any skill is NOT learned by ANYONE
    for(i = 0; i < m; i++)
		if (!skill_ok[i]){
			while(1){
				j = rand() % n;
				if(!forbidden[j]) break;
			}
			know[j][i] = 1;
		}
	
/*  ------------------- Output -----------------------  */
	fprintf(fp, "%d %d\n", n, m);
	for(i = 0; i < n; i++){
		for(j = 0; j < m; j++)
			fprintf(fp, "%d ", know[i][j]);
		fprintf(fp, "\n");
	}
	for(i = 0; i < n; i++){
		j = rand() % 20 + 1;
		k = rand() % 20 + 1;
		fprintf(fp, "%d %d\n", j, k);
	}
	fprintf(fp, "%d\n", edgecount);
	for(i = 0; i < n; i++)
		for(j = i + 1; j < n; j++)
			if(gr[i][j]) fprintf(fp, "%d %d\n", i+1, j+1);

	fclose(fp);
}
