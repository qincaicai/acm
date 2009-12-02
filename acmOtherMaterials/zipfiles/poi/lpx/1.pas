program
    Word_Equation_POI;

const
    maxlen = 10000;

type
    TLine = array[1..maxlen*2] of integer;

var
    a,b,g,next,t: TLine;
    len , first : array[0..26] of integer;
    m,n,l,ll,i : integer;
    ans : longint;

procedure Readin;
 procedure ReadStr(var r:TLine);
 var
    i,j,k,alpha:integer;
    p:char;
 begin
    readln(k);
    l:=0;
    for i:=1 to k do begin
        read(p);
        if (p='0') or (p='1') then begin
            inc(l);
            r[l]:=ord(p)-ord('0')+1;
            end
        else begin
            alpha:=ord(p)-ord('a')+1;
            for j:=0 to len[alpha]-1 do begin
                inc(l);
                r[l]:=first[alpha]+j;
                end;
            end;
        end;
    readln;
 end;

var
    i:integer;
begin
    readln(n);
    first[0]:=3;
    len[0]:=0;
    for i:=1 to n do begin
        read(len[i]);
        first[i]:=first[i-1]+len[i-1];
        end;
    readln;
    readstr(a);
    ll:=l;
    readstr(b);
end;

procedure Solve;
var
    i:integer;
    tail:integer;
    vis : array[1..maxlen*2] of boolean;

 procedure Insert(u,v:integer);
 begin
    inc(tail);
    t[tail]:=v; next[tail]:=g[u]; g[u]:=tail;
    inc(tail);
    t[tail]:=u; next[tail]:=g[v]; g[v]:=tail;
 end;
 procedure Search(p:integer);
 var
    i:integer;
 begin
    if vis[p] then exit;
    vis[p]:=true;
    i:=g[p];
    while i<>0 do begin
        search(t[i]);
        i:=next[i];
        end;
 end;

begin
    tail:=0;
    fillchar(g,sizeof(g),0);
    for i:=1 to l do
        insert(a[i],b[i]);
    fillchar(vis,sizeof(vis),0);
    search(1);
    ans:=-1;
    if not vis[2] then
        for i:=2 to first[n]+len[n]-1 do if not vis[i] then begin
            inc(ans);
            search(i);
            end;
end;

procedure Outp;
const
    base = 1000000000;
    lbase = 9;
var
    i,j,len:integer;
    l : array[1..maxlen] of longint;
    w,v : longint;
    s:string;
begin
    if ans=-1 then begin
        writeln(0);
        exit;
        end;
    l[1]:=1; len:=1;
    for i:=1 to ans do begin
        w:=0;
        for j:=1 to len do begin
            v:=l[j]+l[j]+w;
            w:=0;
            if v>base then begin
                dec(v,base);
                w:=1;
                end;
            l[j]:=v;
            end;
        if w>0 then begin
            inc(len);
            l[len]:=w;
            end;
        end;
    write(l[len]);
    for i:=len-1 downto 1 do begin
        str(l[i],s);
        while length(s)<lbase do s:='0'+s;
        write(s);
        end;
    writeln;
end;

begin
    assign(input,'row.in'); reset(input);
    assign(output,'row.out'); rewrite(output);
    readln(m);
    for i:=1 to m do begin
        Readin;
        if l=ll then
                Solve
        else
                ans:=-1;
        Outp;
        end;
    close(input);
    close(output);
end.
