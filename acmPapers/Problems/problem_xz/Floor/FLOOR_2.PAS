{$R+,N+}
const p:array[1..12] of word=(1,2,4,8,16,32,64,128,256,512,1024,2048);
var a,b:array[0..2047] of comp;
    m,n:integer;

procedure main;
var i,j,now:word;

    procedure try(o:integer);
    begin
         while j and p[o]=p[o] do inc(o);
         if o=m+1 then begin
            b[now]:=b[now]+a[j];exit
         end;
         now:=now+p[o];
         try(o+1);
         now:=now-p[o];
         if (o<m) and (j and p[o+1]=0) then try(o+2);
    end;

begin
     a[0]:=1;
     for i:=1 to n do begin
         for j:=0 to p[m+1]-1 do
             if a[j]<>0 then begin
                now:=0;
                try(1);
             end;
         a:=b;
         fillchar(b,sizeof(b),0);
     end;
     writeln(a[0]:0:0);
end;

begin
     readln(m,n);
     main;
end.