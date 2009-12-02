{$R-}
{$M 4096,0,655360}
const st1='input.txt';
      st2='output.txt';
      p:array[1..13] of word=(1,2,4,8,16,32,64,128,256,512,1024,2048,4096);
type arr=array[0..15] of word;
var a,b:array[0..4095] of ^arr;
    m,n:integer;
    t:string;

procedure readp;
var f:text;
begin
     assign(f,st1);reset(f);
     readln(f,n,m);
     close(f);
end;

procedure main;
var i,j,now:word;
    f:text;

    procedure jia(var a,b:arr);
    var i:integer;
        o:longint;
    begin
         if b[0]>a[0] then a[0]:=b[0];
         o:=0;
         for i:=1 to a[0] do begin
             inc(o,a[i]+b[i]);
             a[i]:=o mod 10000;
             o:=o div 10000;
         end;
         if o<>0 then begin
            inc(a[0]);a[a[0]]:=o
         end;
    end;

    procedure try(o:integer);
    begin
         while j and p[o]=p[o] do inc(o);
         if o=m+1 then begin
            jia(b[now]^,a[j]^);exit
         end;
         now:=now+p[o];
         try(o+1);
         now:=now-p[o];
         if (o<m) and (j and p[o+1]=0) then try(o+2);
    end;

begin
     if n<m then begin
        i:=m;m:=n;n:=i;
     end;
     for i:=0 to p[m+1]-1 do begin
         new(a[i]);fillchar(a[i]^,sizeof(arr),0);
         new(b[i]);fillchar(b[i]^,sizeof(arr),0);
     end;
     a[0]^[0]:=1;a[0]^[1]:=1;
     for i:=1 to n do begin
         for j:=0 to p[m+1]-1 do
             if a[j]^[0]<>0 then begin
                now:=0;
                try(1);
             end;
         for j:=0 to p[m+1]-1 do begin
             a[j]^:=b[j]^;
             fillchar(b[j]^,sizeof(arr),0);
         end;
     end;
     assign(f,st2);rewrite(f);
     write(a[0]^[a[0]^[0]]);
     for i:=a[0]^[0]-1 downto 1 do begin
         str(a[0]^[i],t);
         while length(t)<4 do t:='0'+t;
         write(f,t);
     end;
     writeln(f);
     close(f);
end;

begin
     readp;
     main;
end.