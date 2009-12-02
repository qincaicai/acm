// Problem   Assistance Required
// Algorithm Precalculation
// Runtime   O(n*l[n])
// Author    Walter Guttmann
// Date      16.07.2000

import java.io.*;

public class assist
{
  public static void main(String[] arg) throws Exception
  {
    final int maxl = 33810;
    int[] l = new int[4096];
    boolean b[] = new boolean[maxl];
    // precalculate all lucky numbers (the 3000th one is 33809) by simulation
    // this would also suit the "Freiburg Method" for larger values of n
    for (int i=0 ; i<maxl ; i++)
      b[i] = true;
    for (int n=1,start=1 ; n<=3000; n++)
    {
      ++start;
      while (!b[start]) ++start;
      l[n] = start;
      for (int m=start ; m<maxl ; )
      {
        b[m] = false;
        for (int i=0 ; i<start ; i++)
        {
          ++m;
          while (m<maxl && !b[m]) ++m;
        }
      }
    }
    StreamTokenizer st = new StreamTokenizer (new FileReader ("assist.in"));
    while (true)
    {
      st.nextToken();
      int n = (int) st.nval;
      if (n == 0) break;
      System.out.println(l[n]);
    }
  }
}

