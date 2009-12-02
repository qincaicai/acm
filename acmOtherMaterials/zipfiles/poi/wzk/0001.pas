program bro; {POI00_01}
var
  dl,z,d,last,next:array[1..10000] of longint;
  result,r:int64;
  s,n,i,zl,zs,now,sub:longint;
  f:text;
begin
  assign(f,'bro.in');
  reset(f);
  readln(f,n);
  s:=0; zs:=0;
  for i:=1 to n do
    begin
      readln(f,z[i],d[i]);
      s:=s+d[i]; zs:=zs+z[i];
      next[i]:=i+1; last[i]:=i-1;
    end;
  next[n]:=1; last[1]:=n;
  close(f);
  dl[1]:=0;
  for i:=2 to n do
    dl[i]:=dl[i-1]+d[i-1];
  now:=1;
  while (dl[now]<=s-dl[now]) do
    now:=next[now];
  now:=last[now];
  i:=0; r:=0; zl:=0;
  repeat
    i:=i+1;
    r:=r+z[i]*dl[i]; zl:=zl+z[i];
  until i=now;
  while i<n do
    begin
      i:=i+1; r:=r+z[i]*(s-dl[i]);
    end;
  sub:=0; result:=r;
  for i:=2 to n do
    begin
      sub:=sub+d[i-1];
      dl[i-1]:=s+dl[i-1];
      zl:=zl-z[i-1];
      r:=r+int64(d[i-1])*(zs-zl-zl);
      while (now<>i) and ((dl[now]-sub)<=(s-dl[now]+sub)) do
        begin
          now:=next[now];
          r:=r+z[now]*(dl[now]*2-sub*2-s);
          zl:=zl+z[now];
        end;
      r:=r-z[now]*(dl[now]*2-sub*2-s);
      zl:=zl-z[now];
      now:=last[now];
      if r<result then result:=r;
    end;
  assign(f,'bro.out');
  rewrite(f);
  writeln(f,result);
  close(f);
end.
