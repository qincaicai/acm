program
    Gra_POI;

var
    n:longint;
    a1,a2,a3:longint;
    e1,e2,e3:longint;

procedure swap(var a,b:longint);
var
    t:longint;
begin
    if a>b then begin
        t:=a; a:=b; b:=t;
        end;
end;

begin
    assign(input,'gra.in'); reset(input);
    assign(output,'gra.out'); rewrite(output);
    read(n);
    read(a1,a2,a3);
    swap(a1,a2); swap(a2,a3); swap(a1,a2);
    e1:=a2-a1-1; e2:=a3-a2-1; e3:=n-3-e1-e2;
    swap(e1,e2); swap(e2,e3); swap(e1,e2);
    if (e2>0) and ((e1+e2+e3) mod 2=0) then
        writeln('NIE')
    else
        writeln('TAK');
    close(input); close(output);
end.

