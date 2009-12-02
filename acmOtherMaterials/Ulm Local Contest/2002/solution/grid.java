// Problem   Paths on a Grid
// Algorithm Binomial Coefficients
// Runtime   O(n)
// Author    Walter Guttmann
// Date      26.12.2001

import java.io.*;
import java.math.*;

public class grid {
  static BigInteger choose (BigInteger k, BigInteger n)
  {
    if (k.compareTo (n.subtract (k)) > 0)
      k = n.subtract (k);
    BigInteger c = n.valueOf (1);
    for (BigInteger i = n.valueOf (0) ; i.compareTo (k) < 0 ; i = i.add (n.valueOf (1)))
      c = c.multiply (n.subtract (i)).divide (i.add (n.valueOf (1)));
    return c;
  }

  public static void main (String[] arg) throws Exception
  {
    BufferedReader in = new BufferedReader (new FileReader ("grid.in"));
    StreamTokenizer st = new StreamTokenizer (in);
    st.ordinaryChars ('-', '9');
    st.wordChars ('-', '9');
    while (true)
    {
      st.nextToken();
      BigInteger n = new BigInteger (st.sval);
      st.nextToken();
      BigInteger m = new BigInteger (st.sval);
      if (n.signum() == 0 && m.signum() == 0) break;
      System.out.println(choose (n, n.add (m)));
    }
  }
}

