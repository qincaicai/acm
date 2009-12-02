
const
  filename = 'date.in1';
  n        = 20;
  p        = 1;

var
  ok       : array[1..n] of boolean;
  ans      : array[1..n, 1..p] of byte;
  i, j, k  : integer;

begin
  randomize;
  assign(output, filename);
  rewrite(output);
  writeln(n, ' ', p);
  for i := 1 to p do
    begin
      fillchar(ok, sizeof(ok), true);
      for j := 1 to n do
        begin
          repeat
            k := random(n) + 1;
          until (ok[k]) and ( (k <> j) or (j = n) );
          ok[k] := false;
          ans[j, i] := k;
        end;
    end;
  for i := 1 to n do
    begin
      for j := 1 to p do
        begin
          write(ans[i, j]);
          if j < p then write(' ');
        end;
      writeln;
    end;
  close(output);
end.
