#include<iostream.h>
#include<math.h>

int main()
{
	double a,b,c,d;
	double ansx[3],f[3],x;
	int i,j;
	
	cin>>a>>b>>c>>d;
	
	for(i=0;i<3;i++)
		f[i]=1e12;
	for(x=-100.00;x<=100.00;x+=0.01)
	{
		double tmp=(d+x*(c+x*(b+x*a)));
		j=0;
		for(i=1;i<3;i++)
			if(f[i]>f[j])
				j=i;
		if(fabs(tmp)<f[j])
		{
			f[j]=fabs(tmp);
			ansx[j]=x;
		}
	}
	for(i=0;i<3;i++)
		for(j=i+1;j<3;j++)
			if(ansx[i]>ansx[j])
			{
				double tmp=ansx[i];
				ansx[i]=ansx[j];
				ansx[j]=tmp;
			}
	
	cout.precision(2);
	cout.setf(ios::fixed);
	cout<<ansx[0]<<" "<<ansx[1]<<" "<<ansx[2]<<endl;
	
	return 0;	
}