program gra; {POI99_04}
var
  i,j,t,n:longint;
  d,c:array[1..3] of longint;
  f:text;

function dis(a,b:longint):longint;
begin
  if b>=a then dis:=b-a-1
  else dis:=n-a+b-1;
end;

begin
  assign(f,'gra.in');
  reset(f);
  readln(f,n);
  readln(f,c[1],c[2],c[3]);
  inc(c[1]); inc(c[2]); inc(c[3]);
  for i:=1 to 3 do
    for j:=1 to 2 do
      if c[j]>c[j+1] then
        begin
          t:=c[j]; c[j]:=c[j+1]; c[j+1]:=t;
        end;
  d[1]:=dis(c[1],c[2]); d[2]:=dis(c[2],c[3]); d[3]:=dis(c[3],c[1]);
  for i:=1 to 3 do
    for j:=1 to 2 do
      if d[j]>d[j+1] then
        begin
          t:=d[j]; d[j]:=d[j+1]; d[j+1]:=t;
        end;
  assign(f,'gra.out');
  rewrite(f);
  if (d[1]=0) and (d[2]=0) then writeln(f,'TAK')
  else
    if (d[1]+d[2]+d[3]) mod 2=0 then writeln(f,'NIE')
    else writeln(f,'TAK');
  close(f);
end.
