/* Contest   : Ulm Local Contest 1997 
 * Problem G : Globetrotter
 * Method    : Vector Geometry
 * Author    : Mark Dettinger
 * Date      : June 13, 1997
 */

#include <stdio.h>
#include <string.h>
#include <math.h>

#define PI 3.141592653589793
#define R 6378

typedef struct { char name[30]; double x,y,z; } city;

FILE* input;

int cities=0;
city c[1000];

int read_city()
{
  double longitude,latitude;

  /* read city description */

  fscanf(input,"%s",c[cities].name);
  if (strcmp(c[cities].name,"#")==0) return 0;
  fscanf(input,"%lf %lf",&latitude,&longitude);

  /* compute 3-D coordinate representation of city */

  longitude *= PI/180.0;
  latitude *= PI/180.0;
  c[cities].x = sin(longitude)*cos(latitude);
  c[cities].y = cos(longitude)*cos(latitude);
  c[cities].z = sin(latitude);

  /* insert city into table */

  cities++;
  return 1;
}

double distance (int i, int j)  /* distance between city i and city j */
{
  double alpha = acos(c[i].x*c[j].x+c[i].y*c[j].y+c[i].z*c[j].z);
  return alpha*R;
}
 
int solve_case()
{
  char src[30],dst[30];
  int i,j;

  /* read source and destination city */

  fscanf(input,"%s %s",src,dst);
  if (strcmp(src,"#")==0) return 0;
  printf("%s - %s\n",src,dst);

  /* search table for cities */

  for (i=0; i<cities && strcmp(c[i].name,src); i++);
  for (j=0; j<cities && strcmp(c[j].name,dst); j++);

  /* compute and print distance between cities */

  if (i==cities || j==cities)
    printf("Unknown\n\n");
  else
    printf("%.0f km\n\n",distance(i,j));
  return 1;
}

int main()
{
  input = fopen("globetrotter.in","r");
  while (read_city());
  while (solve_case());
  fclose(input);
  return 0;
}
