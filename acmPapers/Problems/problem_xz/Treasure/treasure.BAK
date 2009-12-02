const st1='input.txt';
      st2='output.txt';
      maxn=100;
      maxl=250;
      c:array[1..4,1..2] of shortint=((0,1),(1,0),(0,-1),(-1,0));
type arr=array[0..maxn+1] of longint;
var min,n,m,len:longint;
    table:array[1..maxn,1..maxn] of integer;
    p:array[1..maxl] of word;
    a,b:array[0..maxn+1] of ^arr;

procedure readp;
var f:text;
    st:string;
    i,j:integer;
begin
     assign(f,st1);reset(f);
     readln(f,n,m);
     for i:=1 to n do
         for j:=1 to m do
             read(f,table[i,j]);
     read(f,len);
     for i:=1 to len do read(f,p[i]);
     close(f);
end;

procedure main;
var i,j,k,l,o:longint;
    f:text;
begin
     for i:=0 to n+1 do begin
         new(a[i]);new(b[i]);
     end;
     for i:=1 to n do begin
         a[i]^[0]:=99999999;a[i]^[m+1]:=99999999;
     end;
     for i:=1 to m do begin
         a[0]^[i]:=99999999;a[n+1]^[i]:=99999999;
     end;
     for i:=1 to n do
         for j:=1 to m do
             a[i]^[j]:=0;
     for i:=1 to len do begin
         for j:=0 to n+1 do
             for k:=0 to m+1 do
                 b[j]^[k]:=99999999;
         for j:=1 to n do
             for k:=1 to m do begin
                 o:=sqr(table[j,k]-p[i]);
                 for l:=1 to 4 do
                     if a[j+c[l,1]]^[k+c[l,2]]+o<b[j]^[k] then
                        b[j]^[k]:=a[j+c[l,1]]^[k+c[l,2]]+o;
             end;
         for j:=0 to n+1 do a[j]^:=b[j]^;
     end;
     min:=99999999;
     for i:=1 to n do
         for j:=1 to m do
             if a[i]^[j]<min then min:=a[i]^[j];
     assign(f,st2);rewrite(f);
     writeln(f,min);
     close(f);
end;

begin
     readp;
     main;
end.