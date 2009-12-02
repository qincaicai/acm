program
    Promotion_POI2000;

const
    maxn = 1000000;

type
    pTHeap = ^THeap;
    THeap = object
        friend:pTHeap;
        partner,value : array[1..maxn] of longint;
        hsize:longint;
        procedure moveup(var k:longint);
        procedure movedown(var k:longint);
        procedure insert(v,vpart:longint; var k:longint);
        procedure delete(k:longint);
        procedure swap(var i:longint; j:longint);
        function pop:longint;
        end;

var
    min,max:THeap;
    n:longint;

procedure THeap.swap(var i:longint; j:longint);
var
    t:longint;
begin
    t:=value[i]; value[i]:=value[j]; value[j]:=t;
    t:=partner[i]; partner[i]:=partner[j]; partner[j]:=t;
    if partner[i]>0 then
        friend^.partner[partner[i]]:=i;
    if partner[j]>0 then
        friend^.partner[partner[j]]:=j;
    i:=j;
end;

procedure THeap.moveup(var k:longint);
begin
    while (k>1) and (value[k]<value[k div 2]) do
        swap(k,k div 2);
end;

procedure THeap.movedown(var k:longint);
begin
    while ((k*2<=hsize) and (value[k]>value[k*2])) or
        ((k*2<hsize) and (value[k]>value[k*2+1])) do
        if (k*2=hsize) or (value[k*2]<value[k*2+1]) then
            swap(k,k*2)
        else
            swap(k,k*2+1);
end;

procedure THeap.insert(v,vpart:longint; var k:longint);
begin
    inc(hsize);
    value[hsize]:=v;
    partner[hsize]:=vpart;
    k:=hsize;
    moveup(k);
end;

procedure THeap.delete(k:longint);
var
    ok:longint;
begin
    ok:=k;
    swap(k,hsize);
    dec(hsize);
    k:=ok;
    if (k>1) and (value[k]<value[k div 2]) then
        moveup(k)
    else
        movedown(k);
end;

function THeap.pop:longint;
var
    k:longint;
begin
    k:=1;
    swap(k,hsize);
    pop:=value[hsize];
    friend^.delete(partner[hsize]);
    dec(hsize);
    k:=1;
    movedown(k);
end;

procedure Init;
begin
    min.hsize:=0; max.hsize:=0;
    min.friend:=@max; max.friend:=@min;
end;

procedure Solve;
var
    i,j,k,v:longint;
    ans:comp;
    mini,maxi:longint;
begin
    ans:=0;
    read(n);
    for i:=1 to n do begin
        read(k);
        for j:=1 to k do begin
            read(v);
            min.insert(v,-1,mini);
            max.insert(-v,mini,maxi);
            min.partner[mini]:=maxi;
            end;
        ans:=ans-max.pop-min.pop;
        end;
    writeln(ans:0:0);
end;

begin
    assign(input,'pro.in'); reset(input);
    assign(output,'pro.out'); rewrite(output);
    Init;
    Solve;
    close(input); close(output);
end.


