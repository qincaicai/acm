/* University of Ulm Local Contest 1998
 * Problem D : Team Queue
 * Author    : Mark Dettinger
 * Algorithm : Implement a queue of queues
 */

#include <stdio.h>
#include <assert.h>

#define MAXTEAMS 1024
#define MAXTEAMSIZE 1024
#define MAXELEMENTS 1048576

#define DBG(x)

FILE *input;
int kase=0;
int numteams;
int team[MAXELEMENTS];   /* team[i] = the team element #i belongs to */
int teampos[MAXTEAMS];   /* teampos[i] = position of team #i in the queue */
int teamsize[MAXTEAMS];  /* teamsize[i] = number of elements of team #i currently in the queue */

int queue[MAXTEAMS][MAXTEAMSIZE]; /* the queue of queues */
int queuehead[MAXTEAMS];          /* the heads of the single queues */ 
int queuetail[MAXTEAMS];          /* the tails of the single queues */
int head,tail;                    /* head and tail of the queue of queues */

int read_case()
{
  int i,j,n,elmt;

  /* read team descriptions */
  fscanf(input,"%d",&numteams);
  if (numteams==0) return 0;
  for (i=0; i<numteams; i++)
    {
      fscanf(input,"%d",&n);
      for (j=0; j<n; j++)
	{
	  fscanf(input,"%d",&elmt);
	  DBG(printf("%d ",elmt));
	  team[elmt] = i;
	}
      DBG(printf("OK\n"));
    }
  return 1;
}

void enqueue (int element)
{
  int t,pos;

  t = team[element];
  if (teamsize[t]==0)  /* create a new team at the tail */
    {
      queue[tail][0] = element;
      queuehead[tail] = 0;
      queuetail[tail] = 1;
      teampos[t] = tail;
      teamsize[t] = 1;
      tail = (tail+1)%MAXTEAMS;
    }
  else                 /* add element to the team */
    {
      pos = teampos[t];
      queue[pos][queuetail[pos]] = element;
      queuetail[pos] = (queuetail[pos]+1)%MAXTEAMSIZE;
      teamsize[t]++;
    }
}

int dequeue()
{
  int element = queue[head][queuehead[head]];
  int t = team[element];

  queuehead[head] = (queuehead[head]+1)%MAXTEAMSIZE;
  teamsize[t]--;
  if (teamsize[t]==0)  /* team is empty => remove it */
    head = (head+1)%MAXTEAMS;
  return element;
}

void solve_case()
{
  char cmd[30];
  int element,t;

  printf("Scenario #%d\n",++kase);

  /* initialize queue */
  head = tail = 0;
  for (t=0; t<numteams; t++)
    teamsize[t] = 0;

  /* simulation */
  while (1)
    {
      fscanf(input,"%s",cmd);
      if (strcmp(cmd,"ENQUEUE")==0)
	{
	  fscanf(input,"%d",&element);
	  enqueue(element);
	}
      else if (strcmp(cmd,"DEQUEUE")==0)
	{
	  printf("%d\n",dequeue());
	}
      else if (strcmp(cmd,"STOP")==0)
	{
	  printf("\n");
	  return;
	}
      else
	{
	  assert(0);
	}
    }
}

int main()
{
  input = fopen("team.in","r");
  assert(input!=NULL);
  while (read_case()) solve_case();
  fclose(input);
  return 0;
}
