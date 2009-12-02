/* Problem   How many Fibs?
 * Algorithm Large Integer Arithmetic
 * Runtime   O(n^2)
 * Author    Walter Guttmann
 * Date      01.07.2000
 */

#include <assert.h>
#include <stdio.h>
#include <string.h>

#define MAXB 128
#define MAXF 512

typedef int big[MAXB];

/* b = 0 */
void big_zero (big b)
{
  int i;
  for (i=0 ; i<MAXB ; i++)
    b[i] = 0;
}

/* b = s */
void big_from_string (char *s, big b)
{
  int i, len=strlen(s);
  assert (len <= MAXB);
  big_zero (b);
  for (i=len-1 ; i>=0 ; i--)
    b[i] = *s++ - '0';
  assert (!*s);
}

/* c = a + b */
void big_add (big a, big b, big c)
{
  int i, carry=0;
  for (i=0 ; i<MAXB ; i++)
  {
    c[i] = carry + a[i] + b[i];
    carry = c[i] / 10;
    c[i] %= 10;
  }
  assert (!carry);
}

/* a <=> b */
int big_cmp (big a, big b)
{
  int i;
  for (i=MAXB-1 ; i>=0 ; i--)
    if (a[i] > b[i])
      return 1;
    else if (a[i] < b[i])
      return -1;
  return 0;
}

big fibs[MAXF];

/* precalculate enough fibonacci numbers by dynamic programming */
void calc_fibs ()
{
  int i;
  big_zero (fibs[0]);
  fibs[0][0] = 1;
  big_zero (fibs[1]);
  fibs[1][0] = 2;
  for (i=2 ; i<MAXF ; i++)
    big_add (fibs[i-2], fibs[i-1], fibs[i]);
  assert (!fibs[i-1][MAXB-1]);
}

int main ()
{
  FILE *in = fopen ("fibs.in", "r");
  assert (in != NULL);
  calc_fibs();
  while (1)
  {
    char sa[MAXB], sb[MAXB];
    big ba, bb, bz;
    int ia, ib;
    fscanf (in, " %s %s ", sa, sb);
    big_from_string (sa, ba);
    big_from_string (sb, bb);
    assert (big_cmp (ba, bb) <= 0);
    /* check for end of input */
    big_zero (bz);
    if (! big_cmp(ba, bz) && ! big_cmp(bb,bz)) break;
    /* search lower bound */
    for (ia=0 ; ia<MAXF ; ia++)
      if (big_cmp (fibs[ia], ba) >= 0) break;
    assert (ia<MAXF);
    /* search upper bound */
    for (ib=0 ; ib<MAXF ; ib++)
      if (big_cmp (fibs[ib], bb) > 0) break;
    assert (ib<MAXF);
    /* number of fibs is the difference */
    printf ("%d\n", ib-ia);
  }
  fclose (in);
  return 0;
}

