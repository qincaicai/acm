(*
   Problem : FrogGame
*)
{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}
uses Import;

type TBytColumn=array[1..maxLines]of shortint;
     PBytColumn=^TBytColumn;
     TIntColumn=array[1..MaxLines]of longint;
     PIntColumn=^TIntColumn;

const SmallNum=-(1 shl 30); {a very small number}

var lines,Vis {visibility} ,
    Scr0,Scr1,Scr2 {3 kind of score}:integer;

    loc,mv:byte;

    area:array[1..MaxVisibility]of TColumn;
    g:array[1..LimitedV,1..MaxVisibility]of PIntColumn;
    link:array[1..LimitedV,1..MaxVisibility]of PBytColumn; {linking}

    pHead,pTail:integer; {pointers of the loop-array}

procedure init;
var i,j:integer;
    col:TColumn;
begin
  GetSettings(lines,vis,Scr0,Scr1,Scr2);
  for i:=1 to vis do
    begin
      GetInitArea(col);
      area[i]:=col;
    end;

  for i:=1 to vis do for j:=1 to LimitedV do
    begin
      new(g[j,i]);
      new(link[j,i]);
      fillchar(g[j,i]^,sizeof(g[1,1]^),128);
      {this fills with a very small number}
    end;
  mv:=1;pHead:=1;pTail:=vis;
end;

function Search:shortint;
{search the best jump.
 dynamic-programming.}
var i,i1,i2,j,k,h,
    len,l,v,
    mi,mj,mk {mark best}:integer;
    max {best value}:longint;
    flag:boolean;
begin
  max:=-maxlongint;
  for i:=1 to LimitedV do
    fillchar(g[i,pHead]^,sizeof(TIntColumn),128);
  g[mv,pHead]^[loc]:=0;
  len:=pTail-pHead;if len<0 then inc(len,vis);
  for i:=0 to len-1 do
    begin
      i1:=pHead+i;if i1>vis then dec(i1,vis);
      i2:=i1+1;if i2>vis then i2:=1;
      for k:=1 to limitedV do
        fillchar(g[k,i2]^,sizeof(TIntColumn),128);
      for j:=1 to lines do if area[i1,j]<>'b' then
        for k:=1 to limitedV do if g[k,i1]^[j]>smallnum then
          begin
            for l:=-k to k do
              if (j+l>0)and(j+l<=lines)and(area[i2,j+l]<>'b') then
               begin
                 if area[i2,j+l]='g' then v:=k+1 else v:=k;
                 if v>limitedv then v:=limitedv;
                 if g[v,i2]^[j+l]<g[k,i1]^[j] then
                   begin       {inherit}
                     g[v,i2]^[j+l]:=g[k,i1]^[j];
                     if i=0 then link[v,i2]^[j+l]:=l
                            else link[v,i2]^[j+l]:=link[k,i1]^[j];
                   end;
               end;
          end;
      for v:=1 to LimitedV do       {refresh values}
       for l:=1 to lines do if g[v,i2]^[l]>smallnum then
         begin
           case area[i2,l] of
             'b':g[v,i2]^[l]:=smallnum;
             'o':inc(g[v,i2]^[l],scr0+scr1);
             'r':inc(g[v,i2]^[l],scr0-scr2);
             else inc(g[v,i2]^[l],scr0);
           end;
           if g[v,i2]^[l]>=max then      {refresh max-record}
             begin
               flag:=false;     {check if no possible jumps to next column}
               if i2<>pTail then
                 begin
                   h:=i2+1;if h>vis then h:=1;
                   for k:=-v to v do
                    if (l+k>0)and(l+k<lines)and(area[h,l+k]<>'b')
                     then flag:=true;
                 end;
               if flag then continue;
               {a random choice:}
               if (g[v,i2]^[l]=max)and(random(3)<2) then continue;
               max:=g[v,i2]^[l];mi:=i2;mj:=l;mk:=v; {update max-record}
             end;
         end;
    end;
  search:=link[mk,mi]^[mj];
end;

procedure main;
var step:integer;
    col:TColumn;
begin
  pHead:=1;pTail:=vis;
  loc:=(lines-1)div 2 +1;mv:=1;
  repeat
    step:=Search; {get a jump suggestion}
    inc(loc,step); {jump}
    FrogJump(step,col);
    inc(pHead);if pHead>vis then pHead:=1;
    if area[pHead,loc]='g' then inc(mv);
    if mv>limitedV then mv:=limitedV;
    if NoNew then continue; {add a new column}
    inc(pTail);if pTail>vis then pTail:=1;
    area[pTail]:=col;
  until pHead=pTail; {in fact no use this line}
end;

Begin
  init;
  randomize;
  main;
End.
