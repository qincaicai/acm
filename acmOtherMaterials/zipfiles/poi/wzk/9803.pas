program poi9803; {POI98_03}
var
  d:array[1..10000] of integer;
  sum,flag,n,i,j,s:longint;
  f:text;
begin
  assign(f,'sum.in');
  reset(f);
  readln(f,n);
  readln(f,sum);
  close(f);
  s:=n*(n-1) div 2;
  assign(f,'sum.out');
  rewrite(f);
  if odd(s-sum) or (sum>s) or (sum<-s) then
    writeln(f,'NIE')
  else
    begin
      s:=(s-sum) div 2;
      d[1]:=0;
      for i:=n-1 downto 1 do
        if s>=i then
          begin
            s:=s-i;
            d[n+1-i]:=-1;
          end
        else d[n+1-i]:=1;
      j:=0;
      for i:=1 to n do
        begin
          j:=j+d[i];
          writeln(f,j);
        end;
    end;
  close(f);
end.
