program ant; {POI01_03}
const
  maxnum=2000000000;
  maxsize=trunc(sqrt(maxnum));
var
  prime,fac,s:array[1..5000] of longint;
  max,c,b,m,k,i,j,p,primes:longint;
  l:extended;
  f:text;
  min:int64;

procedure search(left,last,p:longint; k:int64);
var
  i:longint;
begin
  if (left<=1) then
    begin
      if (k<min) then min:=k;
      exit;
    end;
  if k>=min then exit;
  if k>max then exit;
  if p>=primes then exit;
  p:=p+1;
  for i:=2 to last do
    begin
      k:=k*prime[p];
      if k>=min then exit;
      if left mod i=0 then
        search(left div i,i,p,k);
    end;
end;

function found(n:longint):longint;
begin
  found:=-1;
  k:=0; m:=n;
  for i:=1 to primes do
    if m mod prime[i]=0 then
      begin
        inc(k); fac[k]:=prime[i]; s[k]:=0;
        while (m>0) and (m mod prime[i]=0) do
          begin
            m:=m div prime[i]; inc(s[k]);
          end;
      end;
  if m>1 then exit;
  min:=1; p:=0;
  for i:=1 to k do
    for j:=1 to s[i] do
      inc(p);
  min:=1; p:=0;
  for i:=k downto 1 do
    begin
      for j:=1 to s[i] do
        begin
          inc(p);
          l:=exp((fac[i]-1)*ln(prime[p]));
          if l*min>max then min:=max+1
          else min:=min*round(l);
          if min>max then break;
        end;
      if min>max then break;
    end;
  search(n,n,0,1);
  if min<=max then found:=min;
end;

procedure creat_primelist;
var
  i,j:longint;
  visited:array[2..maxsize] of boolean;
begin
  primes:=0;
  fillchar(visited,sizeof(visited),0);
  for i:=2 to maxsize do
    if not visited[i] then
      begin
        primes:=primes+1;
        prime[primes]:=i;
        j:=i+i;
        while j<=maxsize do
          begin
            visited[j]:=true;
            j:=j+i;
          end;
      end;
end;

begin
  creat_primelist;
  assign(f,'ant.in');
  {         ant.out}
  reset(f);
  readln(f,max);
  close(f);
  assign(f,'ant.out');
  rewrite(f);
  for c:=2000 downto 1 do
    begin
      b:=found(c);
      if b>0 then
        begin
          writeln(f,b); break;
        end;
    end;
  close(f);
end.
