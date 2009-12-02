var
  n:extended;
  p,w,e:longint;
function divide(var n:extended;p:longint):boolean;
  var
    q:extended;
  begin
    q:=n;
    q:=q/p;
    if int(q)=q then
      begin
        n:=q;
        divide:=true;
      end
    else divide:=false;
  end;
begin
  assign(input,'split.in');
  reset(input);
  readln(n);
  close(input);
  while divide(n,2) do ;
  w:=1;
  for p:=3 to 30000000 do
    begin
      e:=0;
      while divide(n,p) do inc(e);
      w:=w*(e+1);
      if n=1 then break;
    end;
  if n>1 then w:=w*2;
  assign(output,'split.out');
  rewrite(output);
  writeln(w);
  close(output);
end.
