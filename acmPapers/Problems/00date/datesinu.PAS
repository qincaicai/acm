type Tarr = array[1..200] of byte;
var n, p, i, j, k : integer;
    data       : array[1..200] of Tarr;
    now, temp  : Tarr;
    ans        : longint;
    yes        : boolean;

begin
  assign(input, 'date.in'); reset(input);
  assign(output, ''); rewrite(output);
  readln(n, p);
  for j := 1 to n do for i := 1 to p do read(data[i, j]);
  for i := 1 to n do now[i] := i;
  k := 1; ans := 0;
  repeat
    inc(ans);
    if ans mod 1000000 = 0 then writeln(ans);
    for i := 1 to n do
      temp[ data[k, i] ] := now[i];
    now := temp;
    inc(k);
    if k > p then k := 1;
    yes := true;
    for i := 1 to n do
      if now[i] <> i then
        begin
          yes := false;
          break;
        end;
    if yes then break;
  until false;
  writeln(ans);
  close(input); close(output);
end.
