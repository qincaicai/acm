// Problem   Fiber Network
// Algorithm Floyd-Warshall, Transitive Hull, Bit Encoding
// Runtime   O(n^3)
// Author    Walter Guttmann
// Date      10.05.2001

#include <cassert>
#include <cctype>
#include <fstream>
#include <string>

ifstream in ("fiber.in");

int m[256][256];

int main ()
{
  while (1)
  {
    int n;
    in >> n;
    if (n == 0) break;
    assert (1 <= n && n <= 200);
    for (int i=1 ; i<=n ; i++)
      for (int j=1 ; j<=n ; j++)
        m[i][j] = i==j ? ~0 : 0;
    // read graph
    while (1)
    {
      int a, b;
      in >> a >> b;
      if (a == 0 && b == 0) break;
      assert (1 <= a && a <= n && 1 <= b && b <= n);
      string s;
      in >> s;
      for (unsigned int i=0 ; i<s.size() ; i++)
      {
        assert (islower (s[i]));
        m[a][b] |= 1 << (s[i] - 'a');
      }
    }
    // transitive hull
    for (int k=1 ; k<=n ; k++)
      for (int i=1 ; i<=n ; i++)
        for (int j=1 ; j<=n ; j++)
          m[i][j] |= m[i][k] & m[k][j];
    // queries
    while (1)
    {
      int a, b;
      in >> a >> b;
      if (a == 0 && b == 0) break;
      assert (1 <= a && a <= n && 1 <= b && b <= n);
      for (char c='a' ; c<='z' ; c++)
        if (m[a][b] & (1 << (c-'a')))
          cout << c;
      if (! m[a][b])
        cout << "-";
      cout << endl;
    }
    cout << endl;
  }
  return 0;
}

