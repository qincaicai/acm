#include<iostream.h>

#define maxn 200
#define maxk 6

int n,k;
int f[maxn+1][maxk+1];

int main()
{
	int i,j;

	cin>>n>>k;
	
	f[0][0]=1;	
	for(i=1;i<=n;i++)
		for(j=1;j<=k;j++)
			if(i>=j)
				f[i][j]=f[i-j][j]+f[i-1][j-1];
				
	cout<<f[n][k]<<endl;
	
	return 0;
}