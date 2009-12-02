type
  point=^node;
  node=record
         j:integer;
         next,same:point;
         ck:shortint;
       end;
var
  n,m:integer;
  s,cx,cy:array[0..999] of boolean;
  map:array[0..999] of point;
procedure init;
  var
    i,x,y:integer;
    p,q:point;
  begin
    readln(n,m);
    for i:=0 to n-1 do s[i]:=true;
    fillchar(map,sizeof(map),0);
    for i:=1 to m do
      begin
        readln(x,y);
        s[x]:=false;
        s[y]:=false;
        new(p);
        new(q);
        p^.j:=y;
        p^.ck:=1;
        p^.next:=map[x];
        p^.same:=q;
        map[x]:=p;
        q^.j:=x;
        q^.ck:=1;
        q^.next:=map[y];
        q^.same:=p;
        map[y]:=q;
      end;
  end;
function find(u:integer):boolean;
  var
    i,j:integer;
    p,q:point;
  begin
    find:=false;
    p:=map[u];
    while p<>nil do
      begin
        i:=p^.j;
        if not cy[i] then
          if not s[i] then
            begin
              p^.ck:=-p^.ck;
              p^.same^.ck:=-p^.same^.ck;
              find:=true;
              s[i]:=true;
              exit;
            end
          else
            begin
              cy[i]:=true;
              q:=map[i];
              while q<>nil do
              begin
                j:=q^.j;
                if not cx[j] and (q^.ck=-1) then
                  begin
                    cx[j]:=true;
                    if find(j) then
                      begin
                        p^.ck:=-p^.ck;
                        p^.same^.ck:=-p^.same^.ck;
                        q^.ck:=-q^.ck;
                        q^.same^.ck:=-q^.same^.ck;
                        find:=true;
                        exit;
                      end;
                  end;
                q:=q^.next;
              end;
            end;
        p:=p^.next;
      end;
  end;
procedure match;
  var
    u,i:integer;
  begin
    u:=0;
    while u<=n do
      begin
        if not s[u] then
          begin
            fillchar(cx,sizeof(cx),0);
            fillchar(cy,sizeof(cy),0);
            cx[u]:=true;
            if find(u) then s[u]:=true;
          end;
        inc(u);
      end;
  end;
procedure print;
  var
    i,t:integer;
    p:point;
  begin
    t:=0;
    for i:=0 to n-1 do
      begin
        p:=map[i];
        while p<>nil do
          begin
            if p^.ck=-1 then inc(t);
            p:=p^.next;
          end;
      end;
    writeln(n-t div 2);
  end;
begin
  assign(input,'ball.in');
  reset(input);
  init;
  close(input);
  match;
  assign(output,'ball.out');
  rewrite(output);
  print;
  close(output);
end.
