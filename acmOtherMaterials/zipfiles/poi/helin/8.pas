const
  fin = 'xor.in';
  fout = 'xor.out';
  maxn = 102;
  maxm = 3002;

type
  tlist = array[0 .. maxn + 1] of byte;
  tdata = record
    last1, last2 : integer;
    result : tlist;
    done : boolean;
  end;

var
  count : longint;
  n, m, stop : integer;
  a, b : tlist;
  data : array[-maxn .. maxm] of tdata;

procedure prepare;
var
  i : integer;
  ch : char;
begin
  fillchar(data, sizeof(data), 0);
  assign(input, fin); reset(input);
  readln(n, m, stop);
  for i := 1 to m do begin
    readln(data[i].last1, data[i].last2);
  end;
  for i := 1 to n do begin
    read(ch); a[i] := ord(ch) - 48;
  end;
  readln;
  for i := 1 to n do begin
    read(ch); b[i] := ord(ch) - 48;
  end;
  close(input);
  for i := 1 to n do with data[-i] do begin
    done := true; result[i] := 1;
  end;
end;

procedure calc(p : integer);
var
  i : integer;
begin
  if data[p].done then exit;
  data[p].done := true;
  calc(data[p].last1); calc(data[p].last2);
  for i := 1 to n do with data[p] do
    result[i] := data[last1].result[i] xor data[last2].result[i];
end;

procedure print;
begin
  assign(output, fout); rewrite(output);
  writeln(count);
  close(output);
end;

procedure main;
var
  one : integer;

function same : boolean;
var
  i : integer;
begin
  same := false;
  for i := n downto 1 do if a[i] <> b[i] then exit;
  same := true;
end;

function countone : integer;
var
  s, i : integer;
begin
  s := 0;
  for i := 1 to n do inc(s, a[i] and data[stop].result[i]);
  countone := s;
end;

procedure addone;
var
  i : integer;
begin
  i := n; while a[i] = 1 do begin a[i] := 0; dec(i); end;
  inc(a[i]);
end;

begin
  count := 0;
  if odd(countone) then inc(count);
  while not same do begin
    addone;
    if odd(countone) then inc(count);
  end;
end;

begin
  prepare;
  calc(stop);
  main;
  print;
end.
