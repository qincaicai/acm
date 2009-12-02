{$M 65520,0,655360}
var
  n,min:integer;
  f:array[1..100,0..10,0..10] of byte;
  thing:array[1..100] of byte;
procedure init;
  var
    i,j,k:integer;
    ch:char;
  begin
    readln(n);
    for i:=1 to n do
      begin
        readln(ch);
        thing[i]:=ord(ch)-65;
      end;
    for i:=1 to n do
      for j:=0 to 10 do
        for k:=0 to 10 do
          f[i,j,k]:=255;
    min:=255;
  end;
procedure ni(i,a,b,s,v:integer;var new:integer);
  var j,t:integer;
  begin
    j:=i+1;
    while (j<=n) and (j-i<=v) do
      begin
        case thing[j] of
          0:inc(a);
          1:inc(b);
        end;
        inc(j);
      end;
    dec(j);
    new:=j;
    if f[new,a,b]>s+1 then
      begin
        f[new,a,b]:=s+1;
        if new=n then
          begin
            t:=f[new,a,b];
            if a<>0 then inc(t);
            if b<>0 then inc(t);
            if 10-v+j-i-a-b<>0 then inc(t);
            if t<min then min:=t;
          end;
      end;
  end;
procedure solve;
  var
    i,j,k,new,l:integer;
  begin
    ni(0,0,0,0,10,new);
    l:=new;
    for i:=l to n-1 do
      for j:=0 to 10 do
        for k:=0 to 10 do
          if (j+k<11) and (f[i,j,k]<>255) then
            begin
              if j>0 then ni(i,0,k,f[i,j,k],j,new);
              if k>0 then ni(i,j,0,f[i,j,k],k,new);
              if 10-j-k>0 then ni(i,j,k,f[i,j,k],10-j-k,new);
            end;
  end;
begin
  assign(input,'worker.in');
  reset(input);
  init;
  close(input);
  solve;
  assign(output,'worker.out');
  rewrite(output);
  writeln(min-1);
  close(output);
end.

