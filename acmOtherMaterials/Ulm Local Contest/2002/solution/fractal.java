// Problem   The Sierpinski Fractal
// Algorithm Recursion
// Runtime   O(n^2)
// Author    Walter Guttmann
// Date      30.12.2001

import java.io.*;

public class fractal {
  static void recurse (int n, char[][] out, int x, int y)
  {
    if (n == 1)
    {
      out[x][y] = out[x-1][y+1] = '/';
      out[x][y+1] = out[x][y+2] = '_';
      out[x][y+3] = out[x-1][y+2] = '\\';
      return;
    }
    int ofs = 1 << (n-1);
    recurse (n-1, out, x, y);
    recurse (n-1, out, x, y+2*ofs);
    recurse (n-1, out, x-ofs, y+ofs);
  }
  public static void main (String[] arg) throws Exception
  {
    BufferedReader in = new BufferedReader (new FileReader ("fractal.in"));
    StreamTokenizer st = new StreamTokenizer (in);
    while (st.nextToken () != st.TT_EOF)
    {
      int n = (int) st.nval;
      if (n == 0) break;
      int xlen = 1 << n;
      int ylen = 2 * xlen;
      char[][] out = new char[xlen][ylen];
      for (int i=0 ; i<xlen ; i++)
        for (int j=0 ; j<ylen ; j++)
          out[i][j] = ' ';
      recurse (n, out, xlen-1, 0);
      for (int i=0 ; i<xlen ; i++)
        for (int j=ylen-1 ; j>=0 ; j--)
          if (out[i][j] != ' ')
          {
            System.out.println (new String (out[i], 0, j+1));
            break;
          }
      System.out.println ();
    }
  }
}

