program lan;{POI01_15}
type
  arr=array[0..500] of longint;
var
  r,d:arr;
  s,t:array[1..1000] of longint;
  last,n,i:longint;
  f:text;

procedure add(var a:arr; b:arr);
var
  i:longint;
begin
  if b[0]<=a[0] then
    for i:=1 to b[0] do
      a[i]:=a[i]+b[i]
  else
    begin
      for i:=1 to a[0] do
        a[i]:=a[i]+b[i];
      for i:=a[0]+1 to b[0] do
        a[i]:=b[i];
      a[0]:=b[0];
    end;
  for i:=1 to a[0]-1 do
    if a[i]>=10 then
      begin
        dec(a[i],10); inc(a[i+1]);
      end;
  if a[a[0]]>=10 then
    begin
      dec(a[a[0]],10); inc(a[0]);
      a[a[0]]:=1;
    end;
end;

procedure div2;
var
  i,j:longint;
begin
  j:=0;
  for i:=d[0] downto 1 do
    begin
      j:=j*10+d[i];
      d[i]:=j div 2;
      j:=j mod 2;
    end;
  if d[d[0]]=0 then dec(d[0]);
end;

begin
  assign(f,'lan3.in');
  {         lan3.out}
  reset(f);
  readln(f,n);
  for i:=1 to n do
    begin
      read(f,s[i]); t[i]:=0;
    end;
  close(f);
  last:=0;
  for i:=n downto 2 do
    if s[i]<>t[i] then
      begin
        last:=i; break;
      end;
  d[0]:=1; d[1]:=1;
  for i:=2 to last do
    add(d,d);
  dec(d[1]);
  r[0]:=1; r[1]:=0;
  i:=last;
  while i>=2 do
    begin
      if s[i]<>t[i] then
        begin
          r[1]:=r[1]+1; add(r,d);
          t[i-1]:=1;
        end;
      i:=i-1; div2;
    end;
  if s[1]<>t[1] then
    begin
      d[0]:=1; d[1]:=1;
      add(r,d);
    end;
  assign(f,'con');
  rewrite(f);
  if r[0]=0 then write(f,0);
  for i:=r[0] downto 1 do
    write(f,r[i]);
  writeln(f);
  close(f);
end.
