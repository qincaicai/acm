// Problem   All in All
// Algorithm Greedy
// Runtime   O(n)
// Author    Walter Guttmann
// Date      26.12.2001

import java.io.*;

public class allinall {
  public static void main (String[] arg) throws Exception
  {
    BufferedReader in = new BufferedReader (new FileReader ("allinall.in"));
    StreamTokenizer st = new StreamTokenizer (in);
    st.ordinaryChars ('-', '9');
    st.wordChars ('-', '9');
    while (st.nextToken () != st.TT_EOF)
    {
      String s = st.sval;
      st.nextToken();
      String t = st.sval;
      int is = 0;
      for (int it = 0 ; it < t.length() ; it++)
        if (is < s.length() && s.charAt (is) == t.charAt (it))
          is++;
      System.out.println (is == s.length() ? "Yes" : "No");
    }
  }
}

