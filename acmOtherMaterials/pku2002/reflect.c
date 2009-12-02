/* SWERC'98 - Reflections   */
/* 10/04/98 - Matthias Ruhl */

#include <stdio.h>
#include <math.h>
#include <assert.h>

#define MAXSPHERES 25

const double eps = 1e-10;

FILE *inp;
int x[MAXSPHERES],y[MAXSPHERES],r[MAXSPHERES];
double rx,ry,dx,dy;
int n,lasthit;

double hypot(double x, double y)
{
  return sqrt(x*x+y*y);
}

int nexthit()
{
  double tmin;
  double hx,hy,det,a,b;
  int i,hit;

  tmin = 1e100; hit = -1;
  for(i=0;i<n;i++)
    if(i != lasthit)
    {
      det = dx*dx+dy*dy;
      assert(det > 1e-10);
      a = 2.0*(dx*(rx-x[i])+dy*(ry-y[i]))/det;
      b = ((rx-x[i])*(rx-x[i])+(ry-y[i])*(ry-y[i])-r[i]*r[i])/det;
      
      det = a*a/4.0-b;
      if(det < 0.0) continue; /* no intersection */
      if(det < 1e-10) /* not really hitting! */
	{
	  if(-a/2.0 > 0 && -a/2.0 < tmin)
	    {
	      fprintf(stderr,"INPUT ERROR: Ray is touching sphere\n");
	    }
	}
      else
	{
	  if(-a/2.0-sqrt(det) > 0 && -a/2.0-sqrt(det) < tmin)
	    {
	      tmin = -a/2.0-sqrt(det); hit = i;
	    }
	  else
	    if(-a/2.0+sqrt(det) > 0 && -a/2.0+sqrt(det) < tmin)
	      {
		tmin = -a/2.0+sqrt(det); hit = i;
	      }
	}
    }
  if(hit == -1)
    {
      printf("inf"); return -1;
    }
  lasthit = hit;
  hx = tmin*dx+rx;
  hy = tmin*dy+ry;
  if(fabs(dx*(hy-y[hit])-dy*(hx-x[hit])) < eps)
    {
      dx = -dx; dy = -dy;
    }
  else
    {
      a = ((ry-hy)*(hx-x[hit])-(rx-hx)*(hy-y[hit]))/((double)r[hit]*r[hit]);
      dx = rx + 2.0*a*(hy-y[hit]) - hx;
      dy = ry - 2.0*a*(hx-x[hit]) - hy;
    }
  a = (dx*dx+dy*dy);
  dx /= a; dy /= a;
  rx = hx; ry = hy;

  return hit;
}

void process_scene()
{
  int i,h;

  lasthit = -1;
  for(i=0;i<10;i++)
    {
      h = nexthit();
      if(h == -1) return;
      printf("%d ",h+1);
    }
  if(nexthit() != -1) 
    printf("...");
}

void check_scene()
{
  int i,j;

  for(i=0;i<n;i++)
    if(hypot(rx-x[i],ry-y[i]) <= r[i])
      fprintf(stderr,"INPUT ERROR: Ray starts in sphere %d!\n",i+1);
  for(i=0;i<n;i++)
    for(j=i+1;j<n;j++)
      if(hypot(x[i]-x[j],y[i]-y[j]) < r[i]+r[j])
	fprintf(stderr,"INPUT ERROR: Spheres %d and %d intersect!\n",i+1,j+1);
}

int main()
{
  int i,case_no=1;

  inp = fopen("reflect.in","r");
  freopen("reflect.out","w", stdout);
  while(fscanf(inp,"%d",&n) && n != 0)
    {
      printf("Scene %d\n",case_no++);
      for(i=0;i<n;i++)
	fscanf(inp,"%d %d %d",x+i,y+i,r+i);
      fscanf(inp,"%lf %lf %lf %lf",&rx,&ry,&dx,&dy);
      check_scene();
      process_scene();
      printf("\n");
    }
  fclose(inp);
  return 0;
}
