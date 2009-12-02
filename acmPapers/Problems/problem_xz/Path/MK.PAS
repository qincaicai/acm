const n=100;
      m=100;
      p=10;
var f:text;
    i,j:integer;

function max(i,j:integer):integer;
begin
     if i>j then max:=i else max:=j;
end;

begin
     assign(f,'input.00a');rewrite(f);
     writeln(f,n,' ',m);
     randomize;
     for i:=1 to n do begin
         for j:=1 to m do
             write(f,max(max(i,j),max(n+1-i,m+1-j))*100:6);
         writeln(f);
     end;
     writeln(f,p);
     for i:=1 to p do
         writeln(f,random(n)+1,' ',random(m)+1);
     close(f);
end.