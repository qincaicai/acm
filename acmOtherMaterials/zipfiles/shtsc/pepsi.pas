var
  n,w1,w2,i:integer;
  a,b,c:int64;
function gcd(a,b:int64):int64;
  var i:int64;
  begin
    repeat
      i:=b;
      b:=a mod b;
      a:=i;
    until b=0;
    gcd:=a;
  end;
procedure solve;
  var i:integer;
      bi,ci,d:int64;
  begin
    a:=n;c:=0;
    for i:=2 to n do
      begin
        inc(a,n div i);
        bi:=n mod i;
        if bi=0 then begin ci:=0;continue;end
        else ci:=i;
        if c=0 then
          begin
            c:=ci;
            b:=bi;
          end
        else
          begin
            b:=b*ci+bi*c;
            c:=c*ci;
            d:=gcd(b,c);
            b:=b div d;
            c:=c div d;
            inc(a,b div c);
            b:=b mod c;
            if b=0 then c:=0;
          end;
      end;
  end;
begin
  assign(input,'pepsi.in');
  reset(input);
  readln(n);
  close(input);
  solve;
  assign(output,'pepsi.out');
  rewrite(output);
  if c=0 then
    writeln(a)
    else begin
  w1:=trunc(ln(a)/ln(10))+1;
  w2:=trunc(ln(c)/ln(10))+1;
  writeln(' ':w1+1,b);
  write(a,' ');
  for i:=1 to w2 do write('-');
  writeln;
  writeln(' ':w1+1,c); end;
  close(output);
end.
