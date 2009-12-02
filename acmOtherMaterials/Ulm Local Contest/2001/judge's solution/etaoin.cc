// Problem   Etaoin Shrdlu
// Algorithm Straight-Forward
// Runtime   O(n)
// Author    Walter Guttmann
// Date      12.05.2001

#include <cassert>
#include <cstdio>
#include <fstream>
#include <string>

ifstream in ("etaoin.in");

int freq[128][128];

int main ()
{
  while (1)
  {
    string line;
    getline (in, line);
    int n;
    sscanf (line.c_str(), " %d ", &n);
    if (n == 0) break;
    line = "";
    string all;
    while (n--)
    {
      getline (in, line);
      all += line;
    }
    for (int i=0 ; i<128 ; i++)
      for (int j=0 ; j<128 ; j++)
        freq[i][j] = 0;
    for (unsigned int k=0, l=1 ; k<all.size()-1 && l<all.size() ; k++, l++)
      freq[all[k]][all[l]]++;
    for (int top=0 ; top<5 ; top++)
    {
      int mi, mj, mf = 0;
      for (int i=0 ; i<128 ; i++)
        for (int j=0 ; j<128 ; j++)
          if (freq[i][j] > mf)
          {
            mi = i;
            mj = j;
            mf = freq[i][j];
          }
      assert (mf > 0);
      cout.form ("%c%c %d %0.6f\n", mi, mj, mf, (double)mf / (all.size()-1));
      freq[mi][mj] = 0;
    }
    cout << endl;
  }
  return 0;
}

