program mus;{POI99_01}
var
  defeat,vs:array[1..100,1..100] of boolean;
  win:array[1..100] of boolean;
  next:array[1..100] of integer;
  dis,no,s,n,i,j,k:integer;
  done:boolean;
  ch:char;
  f:text;
begin
  assign(f,'mus.in');
  reset(f);
  readln(f,n);
  for i:=1 to n do
    begin
      for j:=1 to n do
        begin
          read(f,ch);
          if ch='1' then defeat[i,j]:=true
          else defeat[i,j]:=false;
        end;
      readln(f);
      next[i]:=i mod n+1;
    end;
  close(f);
  fillchar(vs,sizeof(vs),0);
  for no:=1 to n do
    begin
      vs[no,next[no]]:=true;
    end;
  for dis:=2 to n do
    for i:=1 to n do
      begin
        j:=(i+dis-1) mod n+1;
        k:=next[i];
        while (k<>i) and not vs[i,j] do
          begin
            if vs[i,k] and vs[k,j] and (defeat[i,k] or defeat[j,k]) then
              begin
                vs[i,j]:=true;
              end;
            k:=next[k];
          end;
      end;
  s:=0;
  for i:=1 to n do
    if vs[i,i] then s:=s+1;
  writeln;
  assign(f,'mus.out');
  rewrite(f);
  writeln(f,s);
  for i:=1 to n do
    if vs[i,i] then writeln(f,i);
  close(f);
end.
