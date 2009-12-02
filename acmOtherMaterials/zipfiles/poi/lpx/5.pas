program
    Pie_POI;

const
    maxn=1000;

type
    pTNode = ^TNode;
    TNode = record
        t:integer;
        next:pTNode;
        end;

var
    ind,outd:array[1..maxn] of longint;
    g:array[1..maxn] of pTNode;
    extra:longint;
    ans,m:longint;

procedure Readin;
var
    i:longint;
    l,r,last:longint;
    map: array[1..maxn] of integer;

    function insert(lr:integer):integer;
    begin
        if map[lr]=0 then begin
            inc(last);
            map[lr]:=last;
            end;
        insert:=map[lr];
    end;
    procedure add(u,v:integer);
    var
        p:pTNode;
    begin
        new(p);
        with p^ do begin
            next:=g[u];
            t:=v;
            end;
        g[u]:=p;
    end;



begin
    fillchar(ind,sizeof(ind),0);
    fillchar(outd,sizeof(outd),0);
    fillchar(map,sizeof(map),0);
    for i:=1 to maxn do g[i]:=nil;
    read(m); last:=0;
    for i:=1 to m do begin
        read(l,r);
        l:=insert(l); r:=insert(r);
        inc(ind[r]);
        inc(outd[l]);
        add(l,r); add(r,l);
        end;
end;

procedure fill(p:longint);
var
    q:pTNode;
begin
    if ind[p]+outd[p]=0 then exit;
    if ind[p]<>outd[p] then extra:=0;
    inc(ans,abs(ind[p]-outd[p]));
    ind[p]:=0; outd[p]:=0;
    q:=g[p];
    while q<>nil do with q^ do begin
        fill(t);
        q:=next;
        end;
end;

procedure Solve;
var
    i:longint;
begin
    ans:=0;
    for i:=1 to maxn do if ind[i]+outd[i]>0 then begin
        extra:=2;
        fill(i);
        inc(ans,extra);
        end;
    writeln(m+ans div 2);
end;

begin
    assign(input,'pie.in'); reset(input);
    assign(output,'pie.out'); rewrite(output);
    readin;
    solve;
    close(input); close(output);
end.
