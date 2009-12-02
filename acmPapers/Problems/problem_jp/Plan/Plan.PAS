{$A+,B-,D+,E-,F-,G+,I+,L+,N-,O-,P-,Q+,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,655360}
program Course_Selecting;
const
    fin = 'plan.in';
    fon = 'plan.out';
    maxN = 3000;
    infinite = maxlongint;
type
    pEdge              =        ^tEdge;
    tEdge              =        record
                                  v : integer;
                                  f, c : longint;
                                  g, next : pedge;
                                end;
    tPath              =        record
                                  d : longint;
                                  w : pedge;
                                end;
var
    fi, fo             :        text;
    credit             :        array[1..maxn+2]of longint;
    graph              :        array[1..maxn+2]of pEdge;
    pre                :        array[1..maxn+2]of integer;
    path               :        array[1..maxn+2]of tPath;
    profit,
    flow               :        longint;
    N,
    i,j,k              :        integer;

function Min(a, b: longint): longint;
  begin
  if a < b then min:=a
           else min:=b
  end;

procedure Insert(u,v: integer; c: longint);
  var p, q : pedge;
  begin
  new(p); new(q);
  p^.g:=q; q^.g:=p;

  p^.next:=graph[u];
  graph[u]:=p;
  q^.next:=graph[v];
  graph[v]:=q;

  p^.v:=v; p^.c:=c; p^.f:=0;
  q^.v:=u; q^.c:=0; q^.f:=0;
  end;

procedure Init;
  begin
  assign(fi,fin); reset(fi);
  readln(fi, n);
  for i:=1 to n do
    begin
    read(fi, credit[i]);
    while not eoln(fi) do
      begin
      read(fi, j);
      insert(j, i, infinite);
      end;
    readln(fi);
    end;
  close(fi);
  end;

procedure Ford(s0, t0 : integer);
  var x  :  pEdge;
      d  :  longint;
  function Path_Exist : boolean;
    var q : array[1..maxn+2]of integer;
        h, t : integer;
    begin
    fillchar(pre,sizeof(pre),0);
    h:=1; t:=2; q[1]:=s0;
    path[s0].d:=infinite;
    repeat
      i:=q[h]; x:=graph[i];
      while x <> nil do
        with x^ do
          begin
          d := c-f;
          if (pre[v]=0) and (d>0) then
            begin
            q[t]:=v; inc(t);
            pre[v] := i;
            path[v].d := min(d, path[i].d);
            path[v].w := x;
{            write(v,' ');}
            if v = t0 then
              begin
{             writeln;}
              path_exist:=true; exit;
              end;
            end;
          x := next;
          end;
      inc(h);
    until h >= t;
    path_exist:=false; {writeln;}
    end;
  procedure Append_Flow;
    begin
    i:=t0; d:=path[t0].d;
    repeat
      x := path[i].w;
      with x^ do
        begin
        f := f + d;
        g^.f := -f;
        end;
      i := pre[i];
    until i = s0;
    flow := flow + d;
    end;
  begin
  while path_exist do
    append_flow;
  end;

procedure Done;
  begin
  assign(fo,fon); rewrite(fo);
  writeln(fo, profit-flow);
  for i:=1 to n do
    if pre[i] = 0 then
      writeln(fo, i);
  close(fo);
  end;

begin
  init;
  for i:=1 to n do
   if credit[i] < 0
    then insert(n+1, i, -credit[i])
    else begin
      insert(i, n+2, credit[i]);
      profit:=profit+credit[i];
      end;
  ford(n+1,n+2);
  done;
end.