// Problem   Hike on a Graph
// Algorithm Breadth First Search
// Runtime   O(n^3)
// Author    Walter Guttmann
// Date      06.06.2000

#include <cassert>
#include <fstream>
#include <queue>

ifstream in ("hike.in");

typedef pair<int,int> ipair;
typedef pair<int,ipair> itriple;
typedef queue<itriple> itque;

char color[128][128];
int dist[128][128][128];

main ()
{
  int n, p1, p2, p3;
  while (in >> n)
  {
    if (n == 0) break;
    assert (1 <= n && n <= 100);
    in >> p1 >> p2 >> p3;
    --p1; --p2; --p3;
    assert (0 <= p1 && p1 < n);
    assert (0 <= p2 && p2 < n);
    assert (0 <= p3 && p3 < n);
    for (int i=0 ; i<n ; i++)
      for (int j=0 ; j<n ; j++)
        in >> color[i][j];
    for (int i=0 ; i<n ; i++)
      for (int j=0 ; j<n ; j++)
        assert (color[i][j] == color[j][i]);
    for (int i=0 ; i<n ; i++)
      for (int j=0 ; j<n ; j++)
        for (int k=0 ; k<n ; k++)
          dist[i][j][k] = n*n*n;
    itque que;
    dist[p1][p2][p3] = 0;
    que.push (itriple (p1, ipair (p2, p3)));
    while (1)
    {
      if (que.empty ())
      {
        cout << "impossible" << endl;
        break;
      }
      itriple t = que.front ();
      que.pop ();
      p1 = t.first;
      p2 = t.second.first;
      p3 = t.second.second;
      if (p1 == p2 && p1 == p3)
      {
        cout << dist[p1][p2][p3] << endl;
        break;
      }
      int d = dist[p1][p2][p3] + 1;
      for (int k=0 ; k<n ; k++)
      {
        if (color[p1][k] == color[p2][p3] && d < dist[k][p2][p3])
          dist[k][p2][p3] = d, que.push (itriple (k, ipair (p2, p3)));
        if (color[p2][k] == color[p1][p3] && d < dist[p1][k][p3])
          dist[p1][k][p3] = d, que.push (itriple (p1, ipair (k, p3)));
        if (color[p3][k] == color[p1][p2] && d < dist[p1][p2][k])
          dist[p1][p2][k] = d, que.push (itriple (p1, ipair (p2, k)));
      }
    }
  }
  return 0;
}

