program tro;{POI97_14}
var
  d:array[1..1000] of longint;
  n,m,i,j,k:longint;
  f:text;
begin
  assign(f,'tro.in');
  reset(f);
  readln(f,n);
  readln(f,m);
  fillchar(d,sizeof(d),0);
  for i:=1 to m do
    begin
      readln(f,j,k);
      inc(d[j]); inc(d[k]);
    end;
  close(f);
  k:=0;
  for i:=1 to n do
    k:=k+d[i]*(n-1-d[i]);
  k:=k div 2;
  assign(f,'tro.out');
  rewrite(f);
  writeln(f,n*(n-1)*(n-2) div 6-k);
  close(f);
end.
