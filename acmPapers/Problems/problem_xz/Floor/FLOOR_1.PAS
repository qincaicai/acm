const b:array[1..2,1..2] of byte=((0,1),(1,0));
var i,j,n,m:byte;
    total:longint;
    a:array[1..100,1..100] of word;

procedure try(i,j:byte;k:word);
var l:byte;
begin
     if k-1=n*m div 2 then
        begin
             total:=total+1;
             exit;
        end;
     while a[i,j]>0 do
           begin j:=j mod m+1;if j=1 then i:=i+1 end;
     for l:=1 to 2 do
         if a[i+b[l,1],j+b[l,2]]=0 then
            begin
                 a[i,j]:=k;a[i+b[l,1],j+b[l,2]]:=k;
                 try(i,j,k+1);
                 a[i,j]:=0;a[i+b[l,1],j+b[l,2]]:=0;
            end;
end;

begin
     write('N=');readln(n);
     write('M=');readln(m);
     fillchar(a,sizeof(a),10);
     for i:=1 to n do
         for j:=1 to m do a[i,j]:=0;
     if n*m mod 2=0 then try(1,1,1)
        else
            for i:=1 to n do
                for j:=1 to m do
                    begin
                         a[i,j]:=n*m div 2+1;
                         try(1,1,1);
                         a[i,j]:=0;
                    end;
     writeln('Total=',total);
end.
