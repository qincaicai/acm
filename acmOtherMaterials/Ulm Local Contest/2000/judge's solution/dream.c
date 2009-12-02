/* Problem   Mondriaan's Dream
 * Algorithm Dynamic Programming, Backtracking
 * Runtime   O(r * (sqrt(2)+1)^c)
 * Author    Walter Guttmann
 * Date      14.12.1999
 */

#include <stdio.h>

static double cnt[12][1<<11];
static int trans[16384][2];
int rows, cols, ntrans;

/* there are ((sqrt(2)+1)^c - (sqrt(2)-1)^c) * (sqrt(2)+2) / 4 transitions
 * which is the solution to T_{c} = 2 * T_{c-1} + T_{c-2}
 */
void backtrack (int n, int from, int to)
{
  if (n > cols) return;
  if (n == cols)
  {
    trans[ntrans][0] = from;
    trans[ntrans][1] = to;
    ++ntrans;
    return;
  }
  backtrack (n+2, from<<2, to<<2);
  backtrack (n+1, from<<1, (to<<1)|1);
  backtrack (n+1, (from<<1)|1, to<<1);
}

int main ()
{
  int r, t;
  FILE* in = fopen ("dream.in", "r");
  while (fscanf (in, " %d %d ", &rows, &cols) == 2)
  {
    if (rows == 0 || cols == 0) break;
    if (rows < cols) { t = rows; rows = cols ; cols = t; }

    /* calculate map of possible transitions by linear backtracking */
    ntrans = 0;
    backtrack (0, 0, 0);

    for (r=0 ; r<=rows ; r++)
      for (t=0 ; t<(1<<cols) ; t++)
        cnt[r][t] = 0;
    cnt[0][0] = 1;
    for (r=0 ; r<rows ; r++) /* the r topmost rows are already filled */
      for (t=0 ; t<ntrans ; t++) /* perform all transitions */
        cnt[r+1][trans[t][1]] += cnt[r][trans[t][0]];
    printf ("%.0f\n", cnt[rows][0]);
  }
  return 0;
}

