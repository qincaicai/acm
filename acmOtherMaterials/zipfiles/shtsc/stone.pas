var
  a,b,t:longint;
  mu:extended;
begin
  assign(input,'stone.in');
  reset(input);
  assign(output,'stone.out');
  rewrite(output);
  mu:=(1+sqrt(5))/2;
  repeat
    readln(a,b);
    if a>b then
      begin
        a:=a+b;
        b:=a-b;
        a:=a-b;
      end;
    t:=trunc(a/mu)+1;
    if (trunc(mu*t)=a) and (a+t=b) then
       writeln(0)
    else writeln(1);
  until seekeof;
  writeln;
  close(input);
  close(output);
end.
