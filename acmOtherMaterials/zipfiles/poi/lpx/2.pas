program
    Brewery_POI;

const
    maxn = 10000;

var
    demand,dist:array[0..maxn] of comp;
    n:longint;
    c:comp;

procedure Readin;
var
    i:longint;
begin
    read(n);
    c:=0;
    for i:=0 to n-1 do begin
        read(demand[i],dist[i]);
        c:=c+dist[i];
        end;
end;

procedure Solve;
var
    i,mid:longint;
    ld,rd,half,dl,s:comp;
    best,current:comp;
begin
    half:=int(c /2);
    current:=0;
    mid:=0;
    ld:=0; rd:=0;
    dl:=0;
    s:=0;
    for i:=1 to n-1 do begin
        s:=s+dist[i-1];
        if s<=half then begin
            mid:=i; dl:=s;
            current:=current+s*demand[i];
            rd:=rd+demand[i];
            end
        else begin
            current:=current+(c-s)*demand[i];
            ld:=ld+demand[i];
            end;
        end;
    best:=current;
    for i:=1 to n-1 do begin
        ld:=ld+demand[i-1];
        current:=current+(ld-rd)*dist[i-1];
        rd:=rd-demand[i];
        dl:=dl-dist[i-1];
        while dl+dist[mid]<=half do begin
            dl:=dl+dist[mid];
            mid:=(mid+1) mod n;
            current:=current-(c-dl-dl)*demand[mid];
            ld:=ld-demand[mid];
            rd:=rd+demand[mid];
            end;
        if current<best then best:=current;
        end;
    writeln(best:0:0);
end;

begin
    assign(input,'bro.in'); reset(input);
    assign(output,'bro.out'); rewrite(output);
    Readin;
    Solve;
    close(input); close(output);
end.

