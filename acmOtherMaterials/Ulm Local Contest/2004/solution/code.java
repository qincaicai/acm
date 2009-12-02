// Problem   Code
// Algorithm Euler Tour (Iterative Depth First Search)
// Runtime   O(10^(n+1))
// Author    Walter Guttmann
// Date      2000.07.13

import java.io.*;

public class code
{
  public static void main(String[] arg) throws Exception
  {
    StreamTokenizer st = new StreamTokenizer(new FileReader("code.in"));
    while (true)
    {
      st.nextToken();
      int n = (int) st.nval;
      if (n == 0) break;
      // There are 10^(n-1) states.
      int nstates = 1;
      for (int k=1 ; k<n ; k++)
        nstates *= 10;
      // From every state, by pressing a key, one of 10 states is reachable.
      boolean[][] edge = new boolean[nstates][10];
      for (int q=0 ; q<nstates ; q++)
        for (int i=0 ; i<10 ; i++)
          edge[q][i] = true;

      // Produce an Euler tour in reverse order.
      int nout = nstates*10;
      char[] out = new char[nout];

      int nstack = 0;
      int stack_q[] = new int[nout+1];
      int stack_i[] = new int[nout+1];
      stack_q[0] = 0;
      stack_i[0] = 0;

      while (true)
      {
        int q = stack_q[nstack];
        int i = stack_i[nstack];
        if (i < 10)
        {
          stack_i[nstack]++;
          if (edge[q][i])
          {
            edge[q][i] = false;
            ++nstack;
            stack_q[nstack] = (q * 10 + i) % nstates;
            stack_i[nstack] = 0;
          }
        }
        else
        {
          if (nstack == 0)
            break;
          --nstack;
          out[--nout] = (char) ((int) '0' + stack_i[nstack] - 1);
        }
      }

      CharArrayWriter caw = new CharArrayWriter();
      // We always start with pressing the 0 key n-1 times.
      for (int k=1 ; k<n ; k++)
        caw.write('0');
      caw.write(out, 0, nstates*10);
      System.out.println(caw.toString());
    }
  }
}

