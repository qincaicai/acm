const
  w:array[1..4,1..2] of shortint=((0,-1),(-1,0),(0,1),(1,0));
type
  arr=array[1..100,1..100] of longint;
var
  h,f:^arr;
  r,c,i,j:integer;
  max:longint;
procedure init;
  var i,j:integer;
  begin
    new(h);
    new(f);
    fillchar(f^,sizeof(f^),0);
    readln(r,c);
    for i:=1 to r do
      begin
        for j:=1 to c do
          read(h^[i,j]);
        readln;
      end;
  end;
procedure solve(i,j:integer);
  var
    long:longint;
    k:integer;
  begin
    if f^[i,j]<>0 then exit;
    long:=0;
    for k:=1 to 4 do
    if (i+w[k,1]>0) and (i+w[k,1]<=r) and (j+w[k,2]>0) and (j+w[k,2]<=c)
        and (h^[i+w[k,1],j+w[k,2]]>h^[i,j]) then
      begin
        solve(i+w[k,1],j+w[k,2]);
        if long<f^[i+w[k,1],j+w[k,2]] then long:=f^[i+w[k,1],j+w[k,2]];
      end;
    f^[i,j]:=long+1;
  end;
begin
  assign(input,'ski.in');
  reset(input);
  init;
  close(input);
  max:=0;
  for i:=1 to r do
    for j:=1 to c do
      begin
        solve(i,j);
        if max<f^[i,j] then
          max:=f^[i,j];
      end;
  assign(output,'ski.out');
  rewrite(output);
  writeln(max);
  close(output);
end.