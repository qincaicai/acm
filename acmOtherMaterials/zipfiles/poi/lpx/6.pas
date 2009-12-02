program
    OKN_POI;

const
    maxd = 10000;
    maxn = 5000;
    sleft = 1; sright =2;

type
    TBLine = array[0..maxd] of boolean;
    TLine = array[0..maxn] of integer;

var
    n,m,dx,dy:integer;
    s: array[1..maxn] of record
        x,yu,yl,side:integer;
        end;
    x1,y1,x2,y2:integer;

procedure Init;
var
    i:integer;
    vx,vy:TLine;

procedure compress(var vxy:TLine; var b1,b2,d:integer);
var
    buck: array[0..maxd] of integer;
    i:integer;
begin
    fillchar(buck,sizeof(buck),0);
    for i:=1 to n do buck[vxy[i]]:=1;
    buck[b1]:=1; buck[b2]:=1;
    d:=0;
    for i:=0 to maxd do if buck[i]=1 then begin
        inc(d);
        buck[i]:=d;
        end;
    for i:=1 to n do vxy[i]:=buck[vxy[i]];
    b1:=buck[b1]; b2:=buck[b2];
end;

begin
    read(x1,y1,x2,y2);
    read(n);
    for i:=1 to n do
        read(vx[i],vy[i]);
    compress(vx,x1,x2,dx);
    compress(vy,y1,y2,dy);
    vx[0]:=vx[n]; vy[0]:=vy[n];
    m:=0;
    for i:=1 to n do
        if vx[i-1]=vx[i] then begin
            inc(m);
            with s[m] do
            if vy[i]>vy[i-1] then begin
                yu:=vy[i]; yl:=vy[i-1]; x:=vx[i];
                side:=sleft;
                end
            else begin
                yl:=vy[i]; yu:=vy[i-1]; x:=vx[i];
                side:=sright;
                end;
            end;
end;

procedure Solve;
var
    color:array[0..1] of TBLine;
    uy,ly:integer;
    ans,c:longint;
    j,k,x,pre,now,xl,xr:integer;
begin
    ans:=0;
    fillchar(color,sizeof(color),0);
    now:=0;
    for uy:=y1 downto y2+1 do begin
        pre:=now; now:=1-pre;
        ly:=uy-1;
        fillchar(color[now],sizeof(TBLine),0);
        for j:=1 to m do with s[j] do if (yu>=uy)and(yl<=ly) then
            color[now,x]:=true;
        j:=1;
        repeat
            while (j<=dx) and not color[now,j] do inc(j);
            if j>dx then break;
            k:=j; repeat inc(k) until color[now,k];
            c:=0;
            color[now,j]:=false; color[now,k]:=false;
            if j<x1 then xl:=x1 else xl:=j;
            if k<x2 then xr:=k-1 else xr:=x2-1;
            j:=k+1;
            if xl>xr then continue;
            for x:=xl to xr do
                if x=xl then
                    inc(c,ord(color[pre,x]))
                else inc(c,ord(color[pre,x]>color[pre,x-1]));
            inc(ans,1-c);
            for x:=xl to xr do color[now,x]:=true;
        until false;
        end;
    writeln(ans);
end;

begin
    assign(input,'okn.in'); reset(input);
    assign(output,'okn.out'); rewrite(output);
    Init;
    Solve;
    close(input); close(output);
end.
