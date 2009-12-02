// Problem   The Bottom of a Graph
// Algorithm Strongly Connected Components, Topological Sort, DFS
// Runtime   O(|V|+|E|)
// Author    Walter Guttmann
// Date      26.04.2003

import java.io.*;
import java.util.*;

public class bottom
{
  static final int maxv = 8192;
  static Vector[] adj = new Vector[maxv];
  static int[] scc = new int[maxv];
  static Vector topsort = new Vector();
  static Vector[] transpose = new Vector[maxv];
  static boolean[] used = new boolean[maxv];

  static void dfs_topsort(int node)
  {
    used[node] = true;
    for (int i = 0 ; i < adj[node].size() ; i++)
      if (!used[((Integer)adj[node].elementAt(i)).intValue()])
        dfs_topsort(((Integer)adj[node].elementAt(i)).intValue());
    topsort.addElement(new Integer(node));
  }

  static void dfs_scc(int node)
  {
    used[node] = true;
    for (int i = 0 ; i < transpose[node].size() ; i++)
      if (!used[((Integer)transpose[node].elementAt(i)).intValue()])
      {
        scc[((Integer)transpose[node].elementAt(i)).intValue()] = scc[node];
        dfs_scc(((Integer)transpose[node].elementAt(i)).intValue());
      }
  }

  public static void main(String[] arg) throws Exception
  {
    StreamTokenizer st = new StreamTokenizer(new BufferedReader(new FileReader("bottom.in")));
    while (true)
    {
      st.nextToken();
      int v = (int) st.nval;
      if (v == 0) break;
      for (int i=0 ; i<v ; i++)
        adj[i] = new Vector();
      st.nextToken();
      int e = (int) st.nval;
      for (int i=0 ; i<e ; i++)
      {
        st.nextToken();
        int from = (int) st.nval;
        st.nextToken();
        int to = (int) st.nval;
        adj[from-1].addElement(new Integer(to-1));
      }
      // Transpose the graph.
      for (int i=0 ; i<v ; i++)
        transpose[i] = new Vector();
      for (int i=0 ; i<v ; i++)
        for (int j = 0 ; j < adj[i].size() ; j++)
          transpose[((Integer)adj[i].elementAt(j)).intValue()].addElement(new Integer(i));
      // Sort the nodes in reverse topological order (not a DAG yet).
      topsort = new Vector();
      for (int i=0 ; i<v ; i++)
        used[i] = false;
      for (int i=0 ; i<v ; i++)
        if (!used[i])
          dfs_topsort(i);
      // Calculate the SCCs.
      for (int i=0 ; i<v ; i++)
        used[i] = false;
      for (int j=v-1 ; j>=0 ; j--)
      {
        int i = ((Integer)topsort.elementAt(j)).intValue();
        if (!used[i])
        {
          scc[i] = i;
          dfs_scc(i);
        }
      }
      // Node i represents a strongly connected component if scc[i] == i.
      // The edges between the SCCs in their DAG are not directly available.
      // If an edge leave the SCC, its source is not a sink.
      boolean[] sink = new boolean[maxv];
      for (int i=0 ; i<v ; i++)
        sink[i] = true;
      for (int i=0 ; i<v ; i++)
        for (int j = 0 ; j < adj[i].size() ; j++)
          if (scc[i] != scc[((Integer)adj[i].elementAt(j)).intValue()])
            sink[scc[i]] = false;
      boolean first = true;
      for (int i=0 ; i<v ; i++)
        if (sink[scc[i]])
          if (first)
          {
            first = false;
            System.out.print(i+1);
          }
          else
            System.out.print(" " + (i+1));
      System.out.println();
    }
  }
}

