program kod; {POI00_08}
var
  t:array[0..19] of longint;
  d:array[1..19,1..19] of longint;
  n,k,i,j:longint;
  f:Text;

procedure init;
begin
  fillchar(t,sizeof(t),0);
  t[0]:=1;
  for i:=1 to 19 do
    begin
      for j:=1 to i do
        begin
          d[i,j]:=t[j-1]*t[i-j];
          t[i]:=t[i]+d[i,j];
        end;
    end;
end;

procedure solve(first,k,modu:longint);
var
  i,j:longint;
begin
  if k=0 then exit;
  i:=1; j:=0;
  while (i<=k) and (j+d[k,i]*modu<n) do
    begin
      j:=j+d[k,i]*modu;
      i:=i+1;
    end;
  if i<=k then
    begin
      write(f,chr(i+first-2+ord('a')));
      n:=n-j;
      if i=1 then solve(first+1,k-1,modu)
      else if i=k then solve(first,k-1,modu)
      else
        begin
          solve(first,i-1,modu*t[k-i]);
          solve(first+i,k-i,modu);
        end;
    end;
end;

begin
  assign(f,'kod.in');
  reset(f);
  readln(f,n,k);
  close(f);
  init;
  assign(f,'kod.out');
  rewrite(f);
  solve(1,k,1);
  writeln(f);
  close(f);
end.
