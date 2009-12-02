/* Ulm Local Contest 1999   */
/* Problem E: Euro Cup 2000 */
/* Author: Mark Dettinger   */
/* Method: Backtracking     */

#include <stdio.h>
#include <assert.h>

FILE *input;
int group=0;
int num_teams, num_games;
char name[32][32];
int game[32][32];
int best_place[32];
int worst_place[32];
int points[32];

int get_team_number (char* s)
{
  int i;
  for (i=0; i<num_teams; i++)
    if (strcmp(s,name[i])==0) break;
  assert(i<num_teams);
  return i;
}

int read_case()
{
  fscanf(input,"%d",&num_teams);
  if (num_teams==0) return 0;
  for (int i=0; i<num_teams; i++)
    {
      fscanf(input,"%s",name[i]);
      points[i] = 0;
      for (int j=0; j<num_teams; j++)
	game[i][j] = 0;
    }
  fscanf(input,"%d",&num_games);
  for (int k=0; k<num_games; k++)
    {
      char a[32],b[32];
      int i,j,score_i,score_j;

      fscanf(input,"%s %s %d %d",a,b,&score_i,&score_j);
      i = get_team_number(a);
      j = get_team_number(b);
      assert(game[i][j]==0);
      game[i][j] = 1;
      if (score_i > score_j)
	{
	  points[i] += 3;
	}
      else if (score_i == score_j)
	{
	  points[i]++;
	  points[j]++;
	}
      else if (score_i < score_j)
	{
	  points[j] += 3;
	}
      else assert(0);
    }
  return 1;
}

void visit (int i, int j)
{
  if (j>=num_teams)
    {
      visit(i+1,0);
      return;
    }
  if (i>=num_teams)
    {
      for (int k=0; k<num_teams; k++)
	{
	  int num_better = 0;
	  int num_worse = 0;
	  for (int i=0; i<num_teams; i++)
	    {
	      if (points[i] > points[k]) num_better++;
	      if (points[i] < points[k]) num_worse++;
	    }
	  best_place[k] = best_place[k] <? num_better+1;
	  worst_place[k] = worst_place[k] >? (num_teams-num_worse);
	}
      return;
    }
  if (i==j || game[i][j])
    {
      visit(i,j+1);
      return;
    }

  /* simulate the game */
  points[i] += 3;
  visit(i,j+1);
  points[i] -= 3;

  points[i]++;
  points[j]++;
  visit(i,j+1);
  points[i]--;
  points[j]--;

  points[j] += 3;
  visit(i,j+1);
  points[j] -= 3;
}

void solve_case()
{
  for (int i=0; i<num_teams; i++)
    {
      best_place[i] = num_teams;
      worst_place[i] = 1;
    }
  visit(0,0);
  printf("Group #%d\n",++group);
  for (int i=0; i<num_teams; i++)
    printf("%s %d-%d\n",name[i],best_place[i],worst_place[i]);
  printf("\n");
}

int main()
{
  input = fopen("eurocup.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
