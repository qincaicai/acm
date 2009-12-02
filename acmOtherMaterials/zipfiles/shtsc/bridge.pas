var
 n,t:longint;
begin
  assign(input,'bridge.in');
  reset(input);
  assign(output,'bridge.out');
  rewrite(output);
  readln(n);
  t:=n div 2;
  if odd(n) then
    writeln(t*(t+1))
  else writeln(t*t);
  close(input);
  close(output);
end.
