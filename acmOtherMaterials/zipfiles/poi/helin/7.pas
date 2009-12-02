const
  fin = 'lan.in';
  fout = 'lan.out';
  maxn = 1000;
  maxl = 90;

type
  thigh = object
    l : integer;
    data : array[1 .. maxl] of integer;

    procedure setvalue(v : integer);
    procedure mul2;
    procedure add1;
    function ok : boolean;
    procedure show;
  end;

procedure thigh.show;
var
  i, j : integer;
  s : string;
begin
  write(data[l]);
  for i := l - 1 downto 1 do begin
    str(data[i], s);
    for j := 1 to 4 - length(s) do s := '0' + s;
    write(s);
  end;
  writeln;
end;

procedure thigh.setvalue(v : integer);
begin
  fillchar(self, sizeof(self), 0);
  l := 1; data[1] := v;
end;

procedure thigh.mul2;
var
  c, i : integer;
begin
  if not ok then exit;
  c := 0;
  for i := 1 to l do begin
    data[i] := data[i] + data[i] + c;
    if data[i] >= 10000 then begin
      data[i] := data[i] - 10000; c := 1;
    end else c := 0;
  end;
  if c <> 0 then begin inc(l); data[l] := c end;
end;

procedure thigh.add1;
begin
  if not ok then exit;
  inc(data[1]);
end;

function thigh.ok : boolean;
begin
  ok := data[1] >= 0;
end;

var
  n : integer;
  f : array[1 .. maxn, 0 .. 1] of thigh;
  d : array[1 .. maxn] of byte;

procedure getinfo;
var
  i, x : integer;
begin
  assign(input, fin); reset(input);
  readln(n);
  for i := 1 to n do read(d[i]);
  close(input);
  f[1, 0].setvalue(1); f[1, 1].setvalue(0);
  if d[n] = 0 then f[1, 0].setvalue(-1) else f[1, 1].setvalue(-1);
end;

procedure main;
var
  i : integer;
begin
  for i := 2 to n do
  if d[n - i + 1] = 1 then begin
    f[i, 0] := f[i - 1, 1]; f[i, 0].mul2; f[i, 0].add1;
    f[i, 1] := f[i - 1, 0]; f[i, 1].mul2;
  end else begin
    f[i, 0] := f[i - 1, 0]; f[i, 0].mul2; f[i, 0].add1;
    f[i, 1] := f[i - 1, 1]; f[i, 1].mul2;
  end;
end;

procedure print;
begin
  assign(output, fout); rewrite(output);
  if f[n, 0].ok then f[n, 0].show else f[n, 1].show;
  close(output);
end;

begin
  getinfo;
  main;
  print;
end.
