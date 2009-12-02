const
  fin = 'gen.in';
  fout = 'gen.out';
  maxn = 10000;
  maxl = 26;
  maxlen = 100;

type
  tpower = array[0 .. maxl] of longint;

var
  power : tpower;
  result, contain : integer;
  make : array[0 .. maxl, 0 .. maxl] of longint;
  g : array[0 .. maxlen, 0 .. maxlen] of longint;
  goal : string;

procedure calcpower;
var
  i : integer;
begin
  power[0] := 1;
  for i := 1 to maxl do power[i] := power[i - 1] shl 1;
end;

procedure getinfo;
var
  s, s1, s2 : char;
  rule, i : integer;
begin
  fillchar(make, sizeof(make), 0);
  readln(rule);
  for i := 1 to rule do begin
    readln(s, s1, s2);
    make[ord(s1) - 65, ord(s2) - 65] := make[ord(s1) - 65, ord(s2) - 65] or power[ord(s) - 65];
  end;
end;

procedure calcg;
var
  i, s, l, x : integer;

procedure getg(a, b : longint; var c : longint);
var
  i, j : integer;
begin
  for i := 0 to maxl - 1 do if power[i] and a <> 0 then
    for j := 0 to maxl - 1 do if power[j] and b <> 0 then
      c := c or make[i, j];
end;

begin
  fillchar(g, sizeof(g), 0);
  for i := 1 to length(goal) do g[i, 1] := g[i, 1] or power[ord(goal[i]) - 65];
  for l := 2 to length(goal) do
    for s := 1 to length(goal) - l + 1 do
      for x := 1 to l - 1 do
        getg(g[s, x], g[s + x, l - x], g[s, l]);
end;

procedure main;
var
  i, x : integer;
  f : array[0 .. maxlen] of integer;
begin
  f[0] := 0;
  for i := 1 to length(goal) do begin
    f[i] := length(goal) + 1;
    for x := 0 to i - 1 do if g[x + 1, i - x] and power[ord('S') - 65] <> 0 then
      if f[x] + 1 < f[i] then f[i] := f[x] + 1;
  end;
  result := f[length(goal)];
end;

begin
  assign(input, fin); reset(input); assign(output, fout); rewrite(output);
  calcpower;
  getinfo;
  readln(contain);
  while contain > 0 do begin
    readln(goal);
    calcg;
    main;
    if result > length(goal) then writeln('NIE') else writeln(result);
    dec(contain);
  end;
  close(input); close(output);
end.
