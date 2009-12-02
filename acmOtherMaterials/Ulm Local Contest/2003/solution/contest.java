// Problem   Fixed Partition Contest Management
// Algorithm Brute Force
// Runtime   O(m^n*n^2)
// Author    Walter Guttmann
// Date      22.02.2003

import java.io.*;
import java.text.*;

public class contest
{
  public static void main(String[] arg) throws Exception
  {
    StreamTokenizer st = new StreamTokenizer (new FileReader ("contest.in"));
    for (int kase=1 ; ; kase++)
    {
      st.nextToken();
      int m = (int) st.nval;
      st.nextToken();
      int n = (int) st.nval;
      if (m == 0 && n == 0) break;
      int[] bright = new int[16];
      for (int h=1 ; h<=m ; h++)
      {
        st.nextToken();
        bright[h] = (int) st.nval;
      }
      // IF soltime[j][h] == 0 THEN problem j cannot be solved by member h
      // ELSE problem j requires time soltime[j][h] if solved by member h
      int[][] soltime = new int[64][16];
      for (int j=1 ; j<=n ; j++)
      {
        st.nextToken();
        int k = (int) st.nval;
        int[] s = new int[16];
        int[] t = new int[16];
        for (int i=1 ; i<=k ; i++)
        {
          st.nextToken();
          s[i] = (int) st.nval;
          st.nextToken();
          t[i] = (int) st.nval;
        }
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
      int minsumtime = 0;
      int[] minassign = new int[64];
      int[] minptime = new int[64];
      // try all m^n assignments of problems to team members
      int mn = 1;
      for (int j=1 ; j<=n ; j++)
        mn *= m;
      for (int q=0 ; q<mn ; q++)
      {
        // in this assignment problem j is assigned to member assign[j]
        int[] assign = new int[64];
        for (int j=1,qq=q ; j<=n ; j++,qq/=m)
          assign[j] = 1 + qq%m;
        // all problems must be solvable by the assigned members
        boolean valid = true;
        for (int j=1 ; j<=n ; j++)
          if (soltime[j][assign[j]] == 0)
            valid = false;
        if (!valid)
          continue;
        // for each member, problems with shorter solution times are solved first
        int sumtime = 0;
        int[] ptime = new int[64];
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
      avgtime = Math.floor(avgtime * 100.0 + 0.5) / 100.0;
      String avg = new DecimalFormat("#0.00").format(avgtime);
      System.out.println("Case " + kase);
      System.out.println("Average solution time = " + avg);
      for (int j=1 ; j<=n ; j++)
        System.out.println("Problem " + j +
            " is solved by member " + minassign[j] +
            " from " + (minptime[j]-soltime[j][minassign[j]]) +
            " to " + minptime[j]);
      System.out.println();
    }
  }
}

