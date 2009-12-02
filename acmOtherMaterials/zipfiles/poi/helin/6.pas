{$R-,S-,Q-}
{$M 65520,0,655360}

const
  fin = 'gol.in';
  fout = 'gol.out';
  maxlimit = 2000000000;
  maxprime = 44721;
  maxl = 4648;
  min = 27;
  base : array[10 .. min - 1] of string =
        ('3 7', '11', '5 7', '13', '3 11', '3 5 7', '5 11', '17', '7 11', '19',
         '3 17', '3 7 11', '3 19', '3 7 13', '11 13', '5 7 13', '3 5 7 11');

var
  value : longint;
  all, l : integer;
  pr : array[1 .. maxl] of word;

procedure getprime;
var
  i, j : longint;
  p : array[1 .. maxprime] of boolean;
begin
  fillchar(p, sizeof(p), true); p[1] := false;
  i := 2;
  while i <= maxprime do begin
    if p[i] then begin
      j := i + i;
      while j <= maxprime do begin p[j] := false; j := j + i end;
    end;
    inc(i);
  end;
  l := 0;
  for i := 1 to maxprime do if p[i] then begin
    inc(l); pr[l] := i;
  end;
end;

function prime(x : longint) : boolean;
var
  i : integer;
begin
  prime := false;
  for i := 1 to l do
    if pr[i] >= x then break else
    if x mod pr[i] = 0 then exit;
  prime := true;
end;

procedure main;
var
  mid : longint;
  lr : integer;
  s, t : string;
begin
  s := '';
  while value >= min do begin
    mid := value shr 1 + 1;
    while not prime(mid) do
      inc(mid);
    dec(value, mid);
    str(mid, t); s := t + ' ' + s;
  end;
  s := base[value] + ' ' + s;
  mid := 0;
  for lr := 1 to length(s) do if s[lr] = ' ' then inc(mid);
  writeln(mid);
  writeln(s);
end;

begin
  getprime;
  assign(input, fin); reset(input);
  assign(output, fout); rewrite(output);
  readln(all);
  while all > 0 do begin
    readln(value);
    main;
    dec(all);
  end;
  close(output); close(input);
end.

