/* Problem   Genetic Code
 * Algorithm Backtracking
 * Runtime   O(3^n)
 * Author    Walter Guttmann
 * Date      12.03.2003
 */

#include <assert.h>
#include <stdio.h>
#include <string.h>

char s[8192], *end=s, *target=s+5000;

int isThue()
{
  int len;
  for (len=1 ; end-len-len>=s ; len++)
    if (strncmp(end-len-len, end-len, len) == 0)
      return 0;
  return 1;
}

int backtrack()
{
  if (end == target)
    return 1;
  ++end;
  for (end[-1]='N' ; end[-1]<='P' ; end[-1]++)
    if (isThue() && backtrack())
      return 1;
  --end;
  return 0;
}

int main()
{
  int n;
  FILE *in = fopen("genetic.in", "r");
  backtrack();
  while (fscanf(in, " %d ", &n) == 1)
  {
    if (n == 0) break;
    assert(1 <= n && n <= 5000);
    printf("%.*s\n", n, s);
  }
  fclose(in);
  return 0;
}

