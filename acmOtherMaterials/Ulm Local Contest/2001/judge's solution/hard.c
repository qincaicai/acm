/* Problem   Hard to Believe, but True!
** Algorithm Straight-Forward
** Runtime   O(1)
** Author    Walter Guttmann
** Date      14.06.2001
*/

#include <assert.h>
#include <stdio.h>
#include <string.h>

int main ()
{
  FILE *in = fopen ("hard.in", "r");
  char s[32], t[32];
  int a, b, c, i, l;
  while (fscanf (in, " %s ", s) == 1)
  {
    l = strlen (s);
    t[l] = 0;
    for (i=0 ; i<l ; i++)
      t[l-i-1] = s[i];
    assert (sscanf (t, "%d=%d+%d", &c, &b, &a) == 3);
    printf (a+b==c ? "True\n" : "False\n");
    if (a == 0 && b == 0 && c == 0) break;
  }
  return 0;
}

