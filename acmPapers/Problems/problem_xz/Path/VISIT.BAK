const st1='input.txt';
      st2='output.txt';
      b:array[1..4,1..2] of shortint=((1,0),(0,1),(-1,0),(0,-1));
type node=record
              w:longint;
              x,y:byte;
     end;
     arr=array[0..10001] of node;
     point=record
                 x,y:integer;
     end;
var a:array[0..101,0..101] of integer;
    reached:array[1..10] of boolean;
    c:array[0..10] of point;
    dist:array[0..10,0..10] of longint;
    pos:array[0..101,0..101] of word;
    h:^arr;
    n,m,p:byte;
    t:word;
    min:longint;

procedure readp;
var f:text;
    i,j:byte;
begin
     assign(f,st1);reset(f);
     readln(f,n,m);
     for i:=1 to n do
         for j:=1 to m do
             read(f,a[i,j]);
     readln(f,p);
     for i:=1 to p do readln(f,c[i].x,c[i].y);
     close(f);
end;

procedure swap(i,j:word);
var k:node;
begin
     k:=h^[i];h^[i]:=h^[j];h^[j]:=k;
     pos[h^[i].x,h^[i].y]:=i;
     pos[h^[j].x,h^[j].y]:=j;
end;

procedure heap1(i:word);
begin
     if (i*2=t) and (h^[i*2].w<h^[i].w) then begin
        swap(i,i*2);
        heap1(i*2);
     end
     else if i*2+1<=t then
             if h^[i*2].w<h^[i*2+1].w then begin
                if h^[i*2].w<h^[i].w then begin
                   swap(i,i*2);
                   heap1(i*2);
                end
             end
             else if h^[i*2+1].w<h^[i].w then begin
                     swap(i,i*2+1);
                     heap1(i*2+1);
                  end;
end;

procedure heap2(i:word);
begin
     if (i<>1) and (h^[i div 2].w>h^[i].w) then begin
        swap(i div 2,i);
        heap2(i div 2);
     end;
end;

procedure find(no:integer);
var h1,h2,i,j,num:longint;
begin
     for i:=1 to n do
         for j:=1 to m do
             pos[i,j]:=10001;
     for i:=1 to n do begin
         pos[i,0]:=0;pos[i,m+1]:=0;
     end;
     for i:=1 to m do begin
         pos[0,i]:=0;pos[n+1,i]:=0;
     end;
     h^[10001].w:=maxlongint;h^[0].w:=0;
     h^[1].w:=0;h^[1].x:=c[no].x;h^[1].y:=c[no].y;
     pos[c[no].x,c[no].y]:=1;t:=1;num:=0;
     repeat
           for i:=1 to p do
               if (c[i].x=h^[1].x) and (c[i].y=h^[1].y) then
                  dist[no,i]:=h^[1].w;
           inc(num);
           for i:=1 to 4 do begin
               h1:=h^[1].x+b[i,1];h2:=h^[1].y+b[i,2];
               if h^[pos[h1,h2]].w=maxlongint then begin
                  inc(t);
                  with h^[t] do begin
                       w:=h^[1].w+sqr(a[h^[1].x,h^[1].y]-a[h1,h2])+1;
                       x:=h1;y:=h2;
                       pos[x,y]:=t;
                  end;
                  heap2(t);
               end
               else if h^[1].w+sqr(a[h^[1].x,h^[1].y]-a[h1,h2])+1<h^[pos[h1,h2]].w then begin
                       h^[pos[h1,h2]].w:=h^[1].w+sqr(a[h^[1].x,h^[1].y]-a[h1,h2])+1;
                       heap2(pos[h1,h2]);
                    end;
           end;
           swap(1,t);pos[h^[t].x,h^[t].y]:=0;dec(t);
           heap1(1);
     until num=m*n;
end;

procedure try(i,last:byte;t:longint);
var j:byte;
begin
     if t>=min then exit;
     if i=p+1 then begin
        min:=t;exit;
     end;
     for j:=1 to p do
         if not reached[j] then begin
            reached[j]:=true;
            try(i+1,j,t+dist[last,j]);
            reached[j]:=false;
         end;
end;

procedure main;
var i:integer;
    f:text;
begin
     new(h);
     c[0].x:=1;c[0].y:=1;
     for i:=0 to p do find(i);
     min:=maxlongint;
     try(1,0,0);
     assign(f,st2);rewrite(f);
     writeln(f,min);
     close(f);
end;

begin
     readp;
     main;
end.