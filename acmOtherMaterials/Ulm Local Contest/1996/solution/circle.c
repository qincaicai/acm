/* University of Ulm Programming Contest 1996
   Problem C: Circle
   Implementation: Mark Dettinger */

#include <stdio.h>
#include <math.h>

#define PI 3.141592653589793
#define pythagoras(a,b) (sqrt((a)*(a)+(b)*(b)))
#define det(a,b,c,d) ((a)*(d)-(b)*(c))
#define cramer1(a,b,c,d,e,f) (det(e,b,f,d)/det(a,b,c,d))
#define cramer2(a,b,c,d,e,f) (det(a,e,c,f)/det(a,b,c,d))

int main()
{
  FILE* input = fopen("circle.in","r");
  int i;
  double x[3],y[3],s,mx,my,r;

  while (1)
    {
      for (i=0; i<3; i++)
	fscanf(input,"%lf %lf",&x[i],&y[i]);
      if (feof(input)) break;
      s = cramer2(y[1]-y[0],y[1]-y[2],x[0]-x[1],x[2]-x[1],
		  0.5*(x[2]-x[0]),0.5*(y[2]-y[0]));
      mx = 0.5*(x[1]+x[2])+s*(y[2]-y[1]);
      my = 0.5*(y[1]+y[2])+s*(x[1]-x[2]);
      r = pythagoras(mx-x[0],my-y[0]);
      printf("%.2f\n",2*PI*r);
    }
  fclose(input);
  return 0;
}

