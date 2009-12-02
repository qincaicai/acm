program poi9704; {POI97_04}
const
  maxn=100; maxm=3000;
type
  arr=array[1..maxn] of longint;
  num=array[0..35] of longint;
var
  s1,s2:array[1..maxm] of longint;
  low,high:arr;
  start:array[-maxn..maxm] of longint;
  status:array[1..maxn] of longint;
  power2:array[0..100] of num;
  ch:char;
  r:num;
  n,m,t,i,j,k:longint;
  found:boolean;
  f:text;

procedure plus(var a:num; b:num);
var
  i:longint;
begin
  if a[0]<=b[0] then
    begin
      for i:=1 to a[0] do
        a[i]:=a[i]+b[i];
      for i:=a[0]+1 to b[0] do
        a[i]:=b[i];
      a[0]:=b[0];
    end
  else for i:=1 to b[0] do
      a[i]:=a[i]+b[i];
  for i:=1 to a[0]-1 do
    if a[i]>=10 then
      begin
        dec(a[i],10); inc(a[i+1]);
      end;
  if a[a[0]]>=10 then
    begin
      dec(a[a[0]],10);
      inc(a[0]); a[a[0]]:=1;
    end;
end;

procedure sub(var a:num; b:num);
var
  i:longint;
begin
  for i:=1 to b[0] do
    a[i]:=a[i]-b[i];
  for i:=1 to a[0]-1 do
    if a[i]<0 then
      begin
        inc(a[i],10); dec(a[i+1]);
      end;
  while (a[0]>0) and (a[a[0]]=0) do
    dec(a[0]);
end;

function count(now:arr):num;
var
  i,j:longint;
  r:num;
begin
  r[0]:=0; j:=0;
  for i:=1 to k-1 do
    if now[i]=1 then
      begin
        if status[i]=1 then j:=j xor 1;
        plus(r,power2[n-i-1]);
      end;
  j:=j xor 1;
  if j<now[k] then plus(r,power2[n-k])
  else if j=now[k] then
    begin
      for i:=k+1 to n do
        if now[i]=1 then
          plus(r,power2[n-i]);
      plus(r,power2[0]);
    end;
  count:=r;
end;

begin
  assign(f,'xor.in');
  {         xor.out}
  reset(f);
  readln(f,n,m,t);
  for i:=1 to m do
    readln(f,s1[i],s2[i]);
  for i:=1 to n do
    begin
      read(f,ch);
      if ch='1' then low[i]:=1
      else low[i]:=0;
    end;
  readln(f);
  for i:=1 to n do
    begin
      read(f,ch);
      if ch='1' then high[i]:=1
      else high[i]:=0;
    end;
  close(f);
  fillchar(start,sizeof(start),0);
  start[t]:=1;
  repeat
    found:=false;
    for i:=m downto 1 do
      if start[i]=1 then
        begin
          start[i]:=0;
          start[s1[i]]:=start[s1[i]] xor 1;
          start[s2[i]]:=start[s2[i]] xor 1;
          found:=true;
        end;
  until not found;
  for i:=1 to n do
    status[i]:=start[-i];
  k:=0;
  for i:=n downto 1 do
    if status[i]>0 then
      begin
        k:=i; break;
      end;
  if k=0 then
    begin
      writeln(0); exit;
    end;
  power2[0,0]:=1; power2[0,1]:=1;
  for i:=1 to n do
    begin
      power2[i]:=power2[i-1];
      plus(power2[i],power2[i]);
    end;
  r[0]:=0;
  r:=count(high);
  sub(r,count(low));
  j:=0;
  for i:=1 to n do
    if (status[i]>0) and (low[i]=1) then
      j:=j xor 1;
  if j=1 then
    begin
      plus(r,power2[0]);
    end;
  if r[0]=0 then write(0);
  for i:=r[0] downto 1 do
    write(r[i]);
  writeln;
end.
