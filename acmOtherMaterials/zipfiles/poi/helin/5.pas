{$R-,S-,Q-}

const
  fin = 'ant.in';
  fout = 'ant.out';
  pr : array[1 .. 9] of integer =
  (2, 3, 5, 7, 11, 13, 17, 19, 23);
  maxl = 1460;
  maxexp = 30;

type
  tnode = record value, f : longint end;
  tlist = record
    l : integer;
    data : array[1 .. maxl] of tnode;
  end;

var
  n : longint;
  lst : tlist;

procedure prepare;
begin
  assign(input, fin); reset(input);
  readln(n);
  close(input);
  lst.l := 0;
end;

procedure search(d, max: integer; sum : real; ex : longint);
var
  i : integer;
begin
  if sum > ln(n) then exit;
  if d > 9 then with lst do begin
    inc(l); data[l].f := ex;
    data[l].value := round(exp(sum));
    exit;
  end;
  for i := max downto 0 do
    search(d + 1, i, sum + i * ln(pr[d]), ex * (1 + i));
end;

procedure sort;
var
  i : integer;
  tmp : tnode;

procedure sift(s, t : integer);
var
  i, j : integer;
begin
  with lst do begin
    i := s; j := s + s; tmp := data[i];
    while j <= t do begin
      if (j < t) and (data[j + 1].value > data[j].value) then inc(j);
      if tmp.value >= data[j].value then j := t + 1 else begin
        data[i] := data[j]; i := j; j := i + i;
      end;
    end;
    data[i] := tmp;
  end;
end;

begin
  for i := lst.l shr 1 downto 1 do sift(i, lst.l);
  with lst do
  for i := l downto 2 do begin
    tmp := data[1]; data[1] := data[i]; data[i] := tmp;
    sift(1, i - 1);
  end;
end;

procedure print;
var
  i : integer;
  result, max : longint;
begin
  assign(output, fout); rewrite(output);
  max := 0; result := 0;
  with lst do
  for i := 1 to l do if data[i].f > max then begin
    max := data[i].f;
    if data[i].value > n then break;
    result := data[i].value;
  end;
  writeln(result);
  close(output);
end;

begin
  prepare;
  search(1, maxexp, 0, 1);
  sort;
  print;
end.
