#include<iostream.h>
#include<fstream.h>
#include<string.h>

#define maxn 205
#define maxk 41

int p,n,k,caseno;
char s[maxn];
int mlen[maxn];
char word[6][maxn];
int g[maxn][maxn];
int h[maxn][maxk];

int main()
{
	ifstream cin("input3.dat");
	
	int i,j,u,v;	
	
	cin>>caseno;
	while(caseno-->0)
	{
		// init;
		cin>>p>>k;
		n=p*20;
		for(i=1;i<=n;i++)
			cin>>s[i];	
		cin>>p;
		for(i=0;i<p;i++)
			cin>>word[i];
		s[n+1]=0;
			
		//precalc mlen
		for(i=1;i<=n;i++)
		{
			mlen[i]=maxn;
			for(j=0;j<p;j++)
				if( (strstr(s+i,word[j])==s+i) && (strlen(word[j])<mlen[i]) )
					mlen[i]=strlen(word[j]);
		}
			
		//precalc g
		for(i=1;i<=n;i++)
			for(j=i;j<=n;j++)
			{
				g[i][j]=0;
				for(u=i;u<=j;u++)
					if(u+mlen[u]-1<=j)
						g[i][j]++;
			}
		
		// Dynamic Programming
		memset(h,0,sizeof(h));
		for(j=1;j<=k;j++)
			for(u=j;u<=n;u++)
				for(v=u;v<=n;v++)
					if(h[u-1][j-1]+g[u][v]>h[v][j])
						h[v][j]=h[u-1][j-1]+g[u][v];
		cout<<h[n][k]<<endl;
	}
	
	return 0;
}