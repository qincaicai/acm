var
  n,j:int64;
  i,t,s:longint;

begin
  assign(input,'split.in');
  reset(input);
  readln(n);
  close(input);
  while n mod 2=0 do n:=n div 2;
  j:=trunc(sqrt(n));
  if j*j=n then t:=-1 else t:=0;
  for i:=1 to j do
    if odd(i) and (n mod i=0) then inc(t,2);
  assign(output,'split.out');
  rewrite(output);
  writeln(t);
  close(output);
end.
