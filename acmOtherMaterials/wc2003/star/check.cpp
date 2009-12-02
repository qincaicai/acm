#include<stdio.h>
#include<string.h>
#include<math.h>

/*
  Parameters:  .in  .out  .ans
  Eval: 
  - first line:  score
  - second line: message
*/
#define MAXN 200
#define MAXM 200

int	n, m, k;
int num_a[MAXN], num_b[MAXN];
int ability[MAXN][MAXM];
int gr[MAXN][MAXN];
double ans;

void readinput(FILE *fp)
{
	int i, j, u, v;

	fscanf(fp, "%d%d", &n, &m);
	for(i = 0; i < n; i++)
		for(j = 0; j < m; j++)
			fscanf(fp, "%d", &ability[i][j]);
	for(i = 0; i < n; i++)
		fscanf(fp, "%d%d", &num_a[i], &num_b[i]);
	fscanf(fp, "%d", &k);
	memset(gr, 0, sizeof(gr));
	for(i = 0; i < k; i++){
		fscanf(fp, "%d%d", &u, &v);
		gr[u-1][v-1] = gr[v-1][u-1] = 1;
	}
}

double CalcAnswer(FILE *fp)
{
	int i, j, jj, l, count;
	int a, b, s, t, star;
	double time;
	int teach[MAXM];
	int teachers[MAXN];
	fscanf(fp, "%d", &count);
        if(count == 0) return -100.0;
	time = 0.0;
	for(i = 0; i < count; i++){
		fscanf(fp, "%d", &t);
		a = 0;
		for(l = 0; l < m; l++)
			teach[l] = 1;

		for(j = 0; j < t; j++){
			fscanf(fp, "%d", &teachers[j]);
                        if(teachers[j] < 1 || teachers[j] > n) return -100.0;
			for(l = 0; l < m; l++)
				teach[l] &= ability[teachers[j]-1][l];
			a += num_a[teachers[j]-1];
		}
		fscanf(fp, "%d", &s);
                if(s < 1 || s > n) return -100.0;

		for(j = 0; j < t; j++){
			if(teachers[j] == s) return -100.0;
			for(jj = j + 1; jj < t; jj++)
				if(teachers[j] == teachers[jj]) return -100.0;
		}
		for(j = 0; j < t; j++)
			if(!gr[teachers[j]-1][s-1]) return -100.0;
		b = num_b[s-1];
		time += (double)b / (double)a;

		for(l = 0; l < m; l++)
			ability[s-1][l] |= teach[l];
	}
	fscanf(fp, "%d", &star);
	for(l = 0; l < m; l++)
		if(ability[star-1][l] == 0) return -100.0;
	return time;
}

void main(int argc, char * argv[])
{
	char inname[200], outname[200];
	FILE *in, *out;

	sprintf(inname, "star%s.in", argv[1]);
	sprintf(outname, "star%s.out", argv[1]);

	in = fopen(inname, "r");
	out = fopen(outname, "r");
	if(in == NULL || out == NULL)
		printf("File not found.\n");
	else{
		readinput(in);
		ans = CalcAnswer(out);
		if(ans < -10.0)
			printf("Illegal Solution\n");
		else
			printf("Your Answer = %.8lf\n", ans);
	  fclose(out);
	  fclose(in);
	}
}
