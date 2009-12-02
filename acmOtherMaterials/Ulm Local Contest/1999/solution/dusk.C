// Jury program for Ulm local Contest 1999
// ---------------------------------------
//  Problem b: from dusk till dawn
//  Ralf Engels 1999
// ---------------------------------------

#include <stdio.h>
#include <string.h>

char cities[100][32];
int  nCities;

int findCity( char *s )
{
  for( int i=0; i<nCities; i++ )
    if( !strcmp( s, cities[i] ))
      return i;
  
  strcpy( cities[ nCities++ ], s );
  return nCities-1;
}

struct Connection 
{
  int from, to;
  int fromTime, toTime;
};

#define oo 9999999 // largest time in problem 100 * 24

Connection connections[1000];
int cityTimes[100];

void relax( int connNr )
{
  if( cityTimes[connections[ connNr ].from]<oo )
    {
      if( (cityTimes[connections[ connNr ].from]%24) >
	  connections[connNr].fromTime && // must wait a whole day
	  cityTimes[connections[ connNr ].to] > 
	  (cityTimes[connections[ connNr ].from]/24+1)*24+connections[connNr].toTime ) 
	cityTimes[connections[ connNr ].to] = 
	  (cityTimes[connections[ connNr ].from]/24+1)*24+connections[connNr].toTime;
      
      if( (cityTimes[connections[ connNr ].from]%24) <=
	  connections[connNr].fromTime && // does not have to wait
	  cityTimes[connections[ connNr ].to] > 
	  (cityTimes[connections[ connNr ].from]/24)*24+connections[connNr].toTime ) 
	cityTimes[connections[ connNr ].to] = 
	  (cityTimes[connections[ connNr ].from]/24)*24+connections[connNr].toTime;
    }
}

int main()
{
  FILE *in = fopen( "dusk.in", "r" );
  int  i, j;
  int  num;
  int  fall=1;

  fscanf( in, "%d", &num );

  while( num-- )
    {
      int nConnections;

      printf("Test Case %d.\n", fall++ );

      // --- read input ---
      fscanf( in, "%d", &nConnections );
      
      i       = 0;
      nCities = 0;
      for( j=0; j<nConnections; j++ ) // read input and omit false routes
	{
	  char buffer1[32], buffer2[32];
	  int  travelTime;

	  fscanf( in, "%s %s %d %d", 
		  buffer1, 
		  buffer2, 
		  &(connections[i].fromTime),
		  &travelTime );

	  connections[i].from = findCity( buffer1 );
	  connections[i].to   = findCity( buffer2 );

	  if( travelTime > 12 )
	    continue;

	  if( connections[i].fromTime >= 6 && 
	      connections[i].fromTime <  18  )
	    continue;

	  if( (connections[i].fromTime+travelTime) % 24 > 6 && 
	      (connections[i].fromTime+travelTime) % 24 < 18  )
	    continue;

	  connections[i].fromTime -= 18; // 18.00 is hour 0
	  if( connections[i].fromTime < 0 )
	    connections[i].fromTime += 24;

	  connections[i].toTime = connections[i].fromTime +travelTime ;
	  i++;
	}

      nConnections = i;

      // --- initialize ---
      for( i=0; i<nCities; i++ )
	cityTimes[i] = oo;
      
      char buffer[32];
      fscanf( in, "%s", buffer );
      cityTimes[ findCity(buffer) ] = 0;

      for( i=0; i<nCities; i++ )
	for( j=0; j<nConnections; j++ )
	  relax( j );
      
      fscanf( in, "%s", buffer );
      i = cityTimes[findCity(buffer)];

      if( i==oo )
	printf( "There is no route Vladimir can take.\n" );
      else
	printf( "Vladimir needs %d litre(s) of blood.\n", i/24 );

      /* for( i=0; i<nCities; i++ )
	 printf( "Time %s: %d\n", cities[i], cityTimes[i] ); */
      
    }

  fclose( in );

  return 0;
}
