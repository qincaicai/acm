/*
PROG:wissqu
ID:bluedog001
LANG:C++
*/
#include<iostream.h>
#include<stdio.h>
#include<stdlib.h>
#include<assert.h>
#include<string>
#include<ctype.h>
using namespace std;

FILE *inp,*outp;
struct ttp{char ch;int x,y;} ans[17];
int i,j,a[6][6],cow[6],vis[5][5];
char ch;
long tot;
void King(int k){
	int i,j,w,a1;
	if (k>16){
		tot++;
		if (tot==1){
			for (i=1;i<=16;i++) 
			  fprintf(outp,"%c %d %d\n",ans[i].ch,ans[i].x,ans[i].y);
		};
		return;
	};
	for (w=1;w<=5;w++){
	  if (cow[w]==0) continue;
	  if (k==1&&w!=4) continue;
	  for (i=1;i<=4;i++)
	  for (j=1;j<=4;j++){
	    if (vis[i][j]==1) continue;	  
		if (a[i-1][j-1]==w||a[i-1][j]==w||a[i-1][j+1]==w||
			a[i][j-1]==w  ||a[i][j]==w  ||a[i][j+1]==w||
			a[i+1][j-1]==w||a[i+1][j]==w||a[i+1][j+1]==w)	continue;
		cow[w]--;vis[i][j]=1;a1=a[i][j];a[i][j]=w;
		ans[k].ch=char(w+64);ans[k].x=i;ans[k].y=j;
		King(k+1);
		cow[w]++;vis[i][j]=0;a[i][j]=a1;
	  }
    }
}
main(){
	inp=fopen("wissqu.in","r");assert(inp);
	outp=fopen("wissqu.out","w");assert(outp);
	memset(a,255,sizeof(a));
	for (i=1;i<=4;i++)
	for (j=1;j<=4;j++){
      do{fscanf(inp,"%c",&ch);}while(!isalpha(ch));
	  a[i][j]=int(ch)-64;
	}
	memset(vis,0,sizeof(vis));
	tot=0;
	cow[1]=3;cow[2]=3;cow[3]=3;cow[4]=4;cow[5]=3;
	King(1);
	fprintf(outp,"%ld\n",tot);
	fclose(outp);
}