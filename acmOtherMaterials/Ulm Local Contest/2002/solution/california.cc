// Problem   California Jones and the Gate to Freedom
// Algorithm Index of Combination, Binomial Coefficients
// Runtime   O(n^2)
// Author    Walter Guttmann
// Date      06.12.1999

#include <algorithm>
#include <cassert>
#include <cmath>
#include <fstream>
#include <string>

ifstream in ("california.in");

int binomial (int n, int k)
{
  if (n-k < k) k = n-k;
  double b = 1;
  for (int i=0 ; i<k ; i++)
    b = (b * (n-i)) / (i+1);
  assert (b == floor (b));
  return (int) floor (b);
}

main ()
{
  int n;
  while (in >> n)
  {
    if (n == 0) break;
    assert (n % 2 == 0);
    assert (2 <= n && n <= 32);

    int names[32];
    for (int i=0 ; i<n ; i++)
      in >> names[i];

    int k;
    in >> k;
    while (k--)
    {
      // read number in binary representation
      string s;
      in >> s;
      int comb = 0;
      for (string::iterator it = s.begin() ; it != s.end() ; ++it)
        comb = (comb * 2) + (*it - '0');

      // read subset of selected stones
      bool selected[32];
      fill_n (selected, n, false);
      for (int i=0 ; i<n/2 ; i++)
      {
        int stone;
        in >> stone;
        int index = find (names, names+n, stone) - names;
        assert (0 <= index && index < n);
        selected[index] = true;
      }

      // calculate index of selected combination
      int selcomb = 0;
      int left = n/2;
      for (int i=0 ; i<n ; i++)
        if (selected[i])
          --left;
        else
          if (left > 0)
            selcomb += binomial (n-i-1, left-1);

      cout << (comb == selcomb ? "TRUE" : "FALSE") << endl;
    }
  }
  return 0;
}

