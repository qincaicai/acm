program BallGame;
const
  inputfile = 'ballgame.in';
  outputfile = 'ballgame.out';
  maxn = 20000;
var
  a:array[1..maxn]of integer;
  b:array[1..maxn]of boolean;
  n:integer;

procedure init;
var i:integer;
begin
  readln(n);
  fillchar(b,sizeof(b),0);
  for i:=1 to n do begin
    readln(a[i]);
    if b[a[i]] or (a[i] <1) or (a[i] > n) then writeln('ERROR')
               else b[a[i]] := true;
  end;
end;

procedure solve;
var i,k,max,len,now,count :integer;
begin
  max := 0;
  count:=0;
  for i:=1 to n do if a[i] <> 0 then begin
    inc(count);
    now := i;
    len := 0;
    repeat
      k := now;
      now := a[k];
      a[k]:=0;
      inc(len);
    until a[now] = 0;
    if len > max then max := len;
  end;
  writeln(n-count);
  if max > 2
    then writeln(2)
    else if max = 2
           then writeln(1)
           else writeln(0);
end;

begin
  assign(input,inputfile);
  reset(input);
  assign(output,outputfile);
  rewrite(output);
  init;
  solve;
  close(input);
  close(output);
end.