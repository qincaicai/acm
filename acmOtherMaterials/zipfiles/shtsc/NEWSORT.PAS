{$N+}
var
  n,t:integer;
  f:array[1..20,0..190] of comp;
  num:array[1..20] of integer;
procedure solve;
  var
    i,j,k:integer;
  begin
    fillchar(f,sizeof(f),0);
    f[1,0]:=1;
    for i:=2 to n do
      for j:=0 to t do
        for k:=1 to i do
          if j-k+1>=0 then
            f[i,j]:=f[i,j]+f[i-1,j-k+1];
    writeln(f[n,t]:0:0);
  end;
procedure made;
  var i,j,s,k:integer;
  begin
    s:=n;
    for i:=1 to n do
      num[i]:=i;
    for i:=n downto 2 do
      for j:=1 to s do
        if f[i-1,t-j+1]<>0 then
          begin
            write(num[j],' ');
            t:=t-j+1;
            dec(s);
            for k:=j to s do num[k]:=num[k+1];
            break;
          end;
    writeln(num[1],' ');
  end;
begin
  assign(input,'newsort.in');
  reset(input);
  readln(n,t);
  close(input);
  assign(output,'newsort.out');
  rewrite(output);
  solve;
  made;
  close(output);
end.