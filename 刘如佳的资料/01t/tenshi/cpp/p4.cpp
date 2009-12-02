#include<iostream.h>
#include<fstream.h>
#include<string.h>
#include<math.h>

#define maxn 100

#define maxk 41

int cityno,caseno;
double px[maxn*4],py[maxn*4];
int city[maxn*4];
double flyfee,roadfee[maxn];
int A,B,n;
double value[maxn*4];
int mk[maxn*4];

double sqr(double x)
{
	return x*x;
}

int IsZero(double x)
{
	if( (x>1e-12) || (x<-1e12) )
		return 0;
	else
		return 1;
}

double distance(double x1,double y1,double x2,double y2)
{
	return sqrt(sqr(x1-x2)+sqr(y1-y2));
}

int CuiZhi(double x0,double y0,double x1,double y1,double x2,double y2)
{
	return IsZero((y1-y0)*(y2-y0)+(x1-x0)*(x2-x0));
}

double CountDistance(int i,int j)
{
	if(city[i]!=city[j])
		return distance(px[i],py[i],px[j],py[j])*flyfee;
	else
		return distance(px[i],py[i],px[j],py[j])*roadfee[city[i]];
}

void iswap(int  &x,int &y)
{
	int tmp=x;
	x=y;
	y=tmp;
}

int main()
{
	char filename[100];
	cin>>filename;
	ifstream cin(filename);
	
	int i,j,u,v;
	
	cin>>caseno;	
	while(caseno-->0)
	{
		cin>>cityno>>flyfee>>A>>B;
		n=cityno*4;
		for(i=0;i<cityno;i++)
		{
			int i0=4*i;
			int i1=i0+1;
			int i2=i0+2;
			int i3=i0+3;
			cin>>px[i0]>>py[i0]>>px[i1]>>py[i1]>>px[i2]>>py[i2]>>roadfee[i];
			if( !CuiZhi(px[i0],py[i0],px[i1],py[i1],px[i2],py[i2]) )
			{
				if( CuiZhi(px[i1],py[i1],px[i0],py[i0],px[i2],py[i2]) )
					iswap(i1,i0);
				else
					iswap(i2,i0);
			}
			px[i3]=px[i1]+px[i2]-px[i0];
			py[i3]=py[i1]+py[i2]-py[i0];			
			city[i0]=city[i1]=city[i2]=city[i3]=i;
			if( (i==A-1) || (i==B-1) )
				roadfee[i]=0;
		}
		
		//Dijkstra;	
		for(i=0;i<n;i++)
			value[i]=1e12;
		A=(A-1)*4;
		B=(B-1)*4;
		value[A]=0;
		u=A;
		memset(mk,0,sizeof(mk));				
		while(u!=B)
		{
			for(v=0;v<n;v++)
				if( (!mk[v]) && (value[u]+CountDistance(u,v)<value[v]) )
					value[v]=value[u]+CountDistance(u,v);
			mk[u]=1;
			u=-1;
			for(i=0;i<n;i++)
				if( (!mk[i]) && ( (u<0) || (value[i]<value[u]) ) )
					u=i;
		}
		cout.precision(2);
		cout.setf(ios::fixed);
		cout<<value[B]<<endl;
	}	
	return 0;
}