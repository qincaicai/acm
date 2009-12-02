/* Ulm Local Contest 1999    */
/* Problem F: Friends        */
/* Author:    Ralf Engels    */

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

FILE *in;
char buffer[256];
int  pos;

void error()
{
  printf("error at %s\n", &(buffer[pos]) );
  exit( 1 );
}

int parseUnion();

int parseGroup()
{
  int res = 0;

  if( buffer[pos++]!='{' )
    error();

  while( isalpha( buffer[pos] ) )
    {
      if( buffer[pos] >= 'A' && buffer[pos] <= 'Z' )
	res |= 1 << (buffer[pos++]-'A');
      else
	error();
    }

  if( buffer[pos++]!='}' )
    error();
  
  return res;
}

int parseBrace()
{
  if( buffer[pos]!='(' )
    return parseGroup();
  else
    {
      pos++;

      int res = parseUnion();
      
      if( buffer[pos++]!=')' )
	error();

      return res;
    }
}

int parseIntersection()
{
  int res = parseBrace();

  while( buffer[pos]=='*' )
    {
	pos++;
	res &= parseBrace();
    }

  return res;
}

int parseUnion()
{
  int res = parseIntersection();

  while( buffer[pos]=='+' ||
	 buffer[pos]=='-' )
    {
      if( buffer[pos]=='+' )
	{
	  pos++;
	  res |= parseIntersection();
	}
      else if( buffer[pos]=='-' )
	{
	  pos++;
	  res &= ~parseIntersection();
	}
    }
  return res;
}

int main()
{
  in = fopen( "friends.in", "r" );
  while( fscanf( in, "%s", buffer )==1 )
    {
      pos = 0;
      int res = parseUnion();

      printf("{");
      for( int i = 0; i<27; i++ )
	if( res & ( 1 << i ) )
	  printf("%c", i + 'A');
      printf("}\n");
    }

  fclose( in );
  return 0;
}
