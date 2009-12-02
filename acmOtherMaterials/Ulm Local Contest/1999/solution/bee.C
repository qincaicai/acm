// Jury program for Ulm local Contest 1999
// ---------------------------------------
//  Problem b: bee maja
//  Ralf Engels 1999
// ---------------------------------------

#include <stdio.h>
#include <string.h>

int fieldX[100001];
int fieldY[100001];

int posX;
int posY;
int currentStep;

void south( int nr )
{
  while( nr-- )
    {
      posY++;
      fieldX[currentStep] = posX;
      fieldY[currentStep] = posY;
      currentStep++;
    }
}

void north( int nr )
{
  while( nr-- )
    {
      posY--;
      fieldX[currentStep] = posX;
      fieldY[currentStep] = posY;
      currentStep++;
    }
}

void southEast( int nr )
{
  while( nr-- )
    {
      posX++;
      fieldX[currentStep] = posX;
      fieldY[currentStep] = posY;
      currentStep++;
    }
}

void southWest( int nr )
{
  while( nr-- )
    {
      posX--;
      posY++;
      fieldX[currentStep] = posX;
      fieldY[currentStep] = posY;
      currentStep++;
    }
}
void northWest( int nr )
{
  while( nr-- )
    {
      posX--;
      fieldX[currentStep] = posX;
      fieldY[currentStep] = posY;
      currentStep++;
    }
}

void northEast( int nr )
{
  while( nr-- )
    {
      posX++;
      posY--;
      fieldX[currentStep] = posX;
      fieldY[currentStep] = posY;
      currentStep++;
    }
}

int main()
{
  FILE *in = fopen( "bee.in", "r" );
  int field;

  currentStep = 1;
  posX        = 0;
  posY        = -1;
  south( 2 );

  for( int schale = 1; currentStep < 10000; schale ++ )
    {
      northWest( schale );
      north( schale );
      northEast( schale );
      southEast( schale );
      south( schale + 1 );
      southWest( schale );
    }

  while( fscanf( in, "%d", &field )==1 )
    {
      printf( "%d %d\n", fieldX[field], fieldY[field] );
    }

  return 0;
}
