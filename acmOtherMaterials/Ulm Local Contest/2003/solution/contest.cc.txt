// Problem   Fixed Partition Contest Management
// Algorithm Brute Force
// Runtime   O(m^n*n^2)
// Author    Walter Guttmann
// Date      22.02.2003

#include <cassert>
#include <cmath>
#include <fstream>
#include <iostream>

using namespace std;

ifstream in ("contest.in");

int main ()
{
  cout.setf(ios::fixed);
  cout.precision(2);
  for (int kase=1 ; ; kase++)
  {
    int m, n;
    in >> m >> n;
    if (n == 0 && m == 0) break;
    assert(1 <= m && m <= 3);
    assert(1 <= n && n <= 10);
    int bright[16];
    for (int h=1 ; h<=m ; h++)
    {
      in >> bright[h];
      assert(1 <= bright[h]);
    }
    // IF soltime[j][h] == 0 THEN problem j cannot be solved by member h
    // ELSE problem j requires time soltime[j][h] if solved by member h
    int soltime[64][16];
    for (int j=1 ; j<=n ; j++)
    {
      int k;
      in >> k;
      assert(1 <= k && k <= 10);
      int s[16], t[16];
      for (int i=1 ; i<=k ; i++)
      {
        in >> s[i] >> t[i];
        assert(1 <= s[i]);
        assert(1 <= t[i]);
      }
      for (int i=1 ; i<=k-1 ; i++)
        assert(s[i] < s[i+1]);
      for (int h=1 ; h<=m ; h++)
      {
        soltime[j][h] = 0;
        for (int i=1 ; i<=k-1 ; i++)
          if (s[i] <= bright[h] && bright[h] < s[i+1])
            soltime[j][h] = t[i];
        if (s[k] <= bright[h])
          soltime[j][h] = t[k];
      }
    }
    int minsumtime = 0, minassign[64], minptime[64];
    // try all m^n assignments of problems to team members
    int mn = 1;
    for (int j=1 ; j<=n ; j++)
      mn *= m;
    for (int q=0 ; q<mn ; q++)
    {
      // in this assignment problem j is assigned to member assign[j]
      int assign[64];
      for (int j=1,qq=q ; j<=n ; j++,qq/=m)
        assign[j] = 1 + qq%m;
      // all problems must be solvable by the assigned members
      bool valid = true;
      for (int j=1 ; j<=n ; j++)
        if (soltime[j][assign[j]] == 0)
          valid = false;
      if (!valid)
        continue;
      // for each member, problems with shorter solution times are solved first
      int sumtime = 0;
      int ptime[64];
      for (int j1=1 ; j1<=n ; j1++)
      {
        int h = assign[j1];
        ptime[j1] = 0;
        for (int j2=1 ; j2<=n ; j2++)
          if (assign[j2] == h)
            if (soltime[j2][h] < soltime[j1][h] ||
                soltime[j2][h] == soltime[j1][h] && j2 <= j1)
              ptime[j1] += soltime[j2][h];
        sumtime += ptime[j1];
      }
      if (minsumtime == 0 || sumtime < minsumtime)
      {
        minsumtime = sumtime;
        for (int j=1 ; j<=n ; j++)
        {
          minassign[j] = assign[j];
          minptime[j] = ptime[j];
        }
      }
    }
    double avgtime = (double) minsumtime / n;
    avgtime = floor(avgtime * 100.0 + 0.5) / 100.0;
    cout << "Case " << kase << endl;
    cout << "Average solution time = " << avgtime << endl;
    for (int j=1 ; j<=n ; j++)
      cout << "Problem " << j << " is solved by member " << minassign[j]
           << " from " << minptime[j]-soltime[j][minassign[j]]
           << " to " << minptime[j] << endl;
    cout << endl;
  }
  return 0;
}

