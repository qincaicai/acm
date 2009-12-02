// --------------------------------------------
// Problem Champions ulm local contest 1999 
// --------------------------------------------
// jury solution by ralf engels
// warning: for every team there has to be one game open
// --------------------------------------------

import java.util.*;
import java.io.*;

public class eurocup
{
  static String teams[] = new String[20];
  static int    nTeams;

  static boolean games[][] = new boolean[20][20];
  static int     points[]  = new int[20];
  static int     bestRank[]  = new int[20];
  static int     worstRank[] = new int[20];

  static int findTeam( String s )
    {
      for( int i=0; i<nTeams; i++ )
	if( teams[i].equals( s ) )
	  return i;

      teams[nTeams++] = s;
      return nTeams-1;
    }

  static void playGames( int x, int y )
    {
      if( y>=nTeams ) // finished
	{
	  // for all teams compute best and worst rank
	  for( int i=0; i<nTeams; i++ )
	    {
	      if( bestRank[i]>1 )
		{
		  int better = 0;
		  for( int j=0; j<nTeams; j++ )
		    if( j!=i && points[j]>points[i] )
		      better++;
		  if( bestRank[i] > 1+better )
		    bestRank[i] = 1+better;
		}
	      if( worstRank[i]<nTeams )
		{
		  int worse = 0;
		  for( int j=0; j<nTeams; j++ )
		    if( j!=i && points[j]<points[i] )
		      worse++;
		  if( worstRank[i] < nTeams-worse )
		    worstRank[i] = nTeams-worse;
		}
	    }
	  return;
	}
      else if( x>=nTeams ) // next line
	{
	  playGames( 0, y+1 );
	}
      else if( x==y )
	{
	  playGames( x+1, y );
	}
      else if( !games[x][y] ) // play
	{
	  points[x]+=3; // wins
	  playGames( x+1, y );
	  points[x]-=2; // draw
	  points[y]+=1;
	  playGames( x+1, y );
	  points[x]-=1; // lose
	  points[y]+=2;
	  playGames( x+1, y );
	  points[y]-=3;
	}
      else
	playGames( x+1, y );
    }

  public static void main(String[] args) throws IOException
    {
      StreamTokenizer tokens = new StreamTokenizer( new BufferedReader( new InputStreamReader( new FileInputStream( "eurocup.in" ))));

      int fall = 1;
      int n, i, j, k, l;
      String a, b;
      while( tokens.nextToken() == tokens.TT_NUMBER )
	{
	  // read teams
	  n = new Long( Math.round( tokens.nval )).intValue();
	  if( n<=0 ) break;


	  System.out.println( "Group #"+ new Integer( fall++ ).toString() );

	  nTeams = 0;

	  for( i=0; i<n; i++ )
	    if( tokens.nextToken() == tokens.TT_WORD )
	      findTeam( tokens.sval );

	  // read games

	  for( i=0; i<nTeams; i++ )
	    for( j=0; j<nTeams; j++ )
	      games[i][j] = false;

	  for( j=0; j<nTeams; j++ )
	    {
	      points[j]    = 0;
	      bestRank[j]  = nTeams;
	      worstRank[j] = 1;
	    }

	  tokens.nextToken();
	  n = new Long( Math.round( tokens.nval )).intValue();

	  for( i=0; i<n; i++ )
	    if( tokens.nextToken() == tokens.TT_WORD )
	      {
		int team1 = findTeam( tokens.sval );
		tokens.nextToken();
		int team2 = findTeam( tokens.sval );
		tokens.nextToken();
		k = new Long( Math.round( tokens.nval )).intValue();
		tokens.nextToken();
		l = new Long( Math.round( tokens.nval )).intValue();
		games[team1][team2] = true;

		if( k>l )
		  points[team1]+=3;
		else if( k<l )
		  points[team2]+=3;
		else
		  {
		    points[team1]+=1;
		    points[team2]+=1;
		  }
	      }

	  // solve Case
	  playGames(0, 0);

	  // print results
	  for( j=0; j<nTeams; j++ )
	    System.out.println( teams[j] + " " + 
				new Integer( bestRank[j] ).toString() + "-" +
				new Integer( worstRank[j] ).toString() );
	  System.out.println();
	}
    }
}
