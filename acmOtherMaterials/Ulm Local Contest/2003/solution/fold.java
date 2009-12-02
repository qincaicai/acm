// Problem   Fold
// Algorithm Dynamic Programming
// Runtime   O(n^3)
// Author    Walter Guttmann
// Date      21.04.2003

import java.io.*;

public class fold
{
  static boolean av(char c1, char c2)
  {
    return c1=='A' && c2=='V' || c1=='V' && c2=='A';
  }

  public static void main(String[] arg) throws Exception
  {
    StreamTokenizer st = new StreamTokenizer (new FileReader ("fold.in"));
    while (st.nextToken() != st.TT_EOF)
    {
      String s = st.sval;
      int n = s.length();
      int[] match = new int[n];
      // match[i] is the maximal d such that s[i-d..i-1] and s[i+1..i+d]
      // are reverse complementary, i.e., the 2*(d+1) stripes i-d..i
      // and i+1..i+d+1 can be folded upon each other.
      for (int k=0 ; k<n ; k++)
        for (int i=k-1,j=k+1 ; 0<=i && j<n && av(s.charAt(i), s.charAt(j)) ; i--,j++)
          ++match[k];
      ++n;
      int[][] dp = new int[n][n];
      // dp[i][j], where i<=j, is the minimum number of folding steps
      // required to produce the turns between stripes i and j,
      // inclusively, i.e., those described in s[i..j-1].
      for (int d=1 ; d<n ; d++)
        for (int i=0,j=i+d ; j<n ; i++,j++)
        {
          dp[i][j] = n;
          for (int k=i,l=k+1 ; k<j ; k++,l++)
            if (match[k] >= Math.min(k-i, j-l))
              dp[i][j] = Math.min(dp[i][j], 1+Math.max(dp[i][k], dp[l][j]));
        }
      System.out.println(dp[0][n-1]);
    }
  }
}

