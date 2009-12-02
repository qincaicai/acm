{$R-,S-,Q-}

const
  fin = 'pow.in';
  fout = 'pow.out';
  maxl = 2010;
  maxn = 5;

type
  tstring = record
    l : integer;
    ch : array[1 .. maxl] of char;
  end;
  tstrings = array[1 .. maxn] of tstring;

var
  n, result : integer;
  str : tstrings;

procedure prepare;
var
  i : integer;

procedure getstr(p : integer);
begin
  str[p].l := 0;
  with str[p] do while not eoln do begin inc(l); read(ch[l]); end;
  readln;
end;

procedure sort;
var
  i, j, k : integer;
  swap : tstring;
begin
  for i := 1 to n do begin
    k := i;
    for j := i + 1 to n do if str[j].l < str[k].l then k := j;
    if k <> i then begin
      swap := str[i]; str[i] := str[k]; str[k] := swap;
    end;
  end;
end;

begin
  assign(input, fin); reset(input);
  readln(n);
  for i := 1 to n do getstr(i);
  sort;
  close(input);
end;

procedure print;
begin
  assign(output, fout); rewrite(output);
  writeln(result);
  close(output);
end;

procedure main;
var
  base, now, tmp, i : integer;
  next : array[0 .. maxl] of integer;

procedure getnext(base : integer);
var
  i, j : integer;
begin
  next[1] := 0;
  i := 1; j := 0;
  while i <= str[1].l - base do
    if (j = 0) or (str[1].ch[base + i] = str[1].ch[base + j]) then begin
      inc(i); inc(j);
      if str[1].ch[base + i] <> str[1].ch[base + j] then
        next[i] := j
      else next[i] := next[j];
    end else j := next[j];
end;

function matchs(p : integer) : integer;
var
  i, j, max : integer;
begin
  i := 1; j := 1; max := 0;
  while (i <= str[p].l) and (j <= str[1].l - base) do
    if (j = 0) or (str[p].ch[i] = str[1].ch[base + j]) then begin
      inc(i); inc(j);
    end else begin
      if j - 1 > max then max := j - 1;
      j := next[j];
    end;
  if j - 1 > max then max := j - 1;
  matchs := max;
end;

begin
  result := 0;
  for base := 0 to str[1].l - 1 do begin
    getnext(base); now := str[1].l - base;
    for i := 2 to n do begin
      if now <= result then break;
      tmp := matchs(i);
      if tmp < now then now := tmp;
    end;
    if now > result then result := now;
  end;
end;

begin
  prepare;
  main;
  print;
end.
