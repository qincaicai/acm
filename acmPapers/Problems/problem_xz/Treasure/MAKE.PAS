const n=100;
      m=100;
      len=250;
      c:array[1..4,1..2] of shortint=((0,1),(1,0),(0,-1),(-1,0));
var f:text;
    x,y,i,j:integer;
    a:array[1..100,1..100] of longint;
begin
     randomize;
     assign(f,'input.00a');rewrite(f);
     writeln(f,n,' ',m);
     for i:=1 to n do begin
         for j:=1 to m do begin
             a[i,j]:=random(50)+30;
             write(f,a[i,j]:3);
         end;
         writeln(f);
     end;
     writeln(f,len);
     x:=random(n)+1;y:=random(m)+1;
     for i:=1 to len do begin
         repeat
               j:=random(4)+1;
         until (x+c[j,1]>0) and (x+c[j,1]<=n) and (y+c[j,2]>0) and (y+c[j,2]<=m);
         write(f,a[x,y]+integer(integer(random(3)-1)):3);
         inc(x,c[j,1]);inc(y,c[j,2]);
     end;
     writeln(f);
     close(f);
end.