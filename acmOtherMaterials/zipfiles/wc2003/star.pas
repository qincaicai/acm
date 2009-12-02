  {$I-,Q-,R-,S-}
program star;
const
  inpf='star.in';
  outf='star.out';
  times=100;
  maxn=100; maxm=100;
var
  td,last,d:array[1..maxn,1..maxm] of longint;
  used,g:array[1..maxn,1..maxn] of longint;
  len,best:array[1..maxn,1..maxn] of extended;
  lst,a,b,list:array[1..maxn] of longint;
  v:array[1..100] of boolean;
  rc,class:array[1..100,0..100] of longint;
  ss,cs,rs,star,worktime,n,m:longint;
  res:extended;
  f:text;

procedure init;
var
  contain:array[1..maxn,1..maxn] of boolean;
  i,j,k,l:longint;
begin
  assign(f,inpf);
  reset(f);
  readln(f,n,m);
  fillchar(d,sizeof(d),0);
  fillchar(g,sizeof(g),0);
  for i:=1 to n do
    begin
      for j:=1 to m do
        read(f,d[i,j]);
      readln(f);
    end;
  for i:=1 to n do
    readln(f,a[i],b[i]);
  readln(f,k);
  while k>0 do
    begin
      readln(f,i,j);
      g[i,j]:=1; g[j,i]:=1;
      k:=k-1;
    end;
  close(f);
  fillchar(contain,sizeof(contain),true);
  for i:=1 to n do
    for j:=1 to n do
      for k:=1 to m do
        if (d[i,k]=0) and (d[j,k]=1) then
          begin
            contain[i,j]:=false; break;
          end;
  for i:=1 to n do
    for j:=1 to n do
      if g[i,j]=1 then
        begin
          k:=0;
          for l:=1 to n do
            if (g[l,j]=1) and contain[l,i] then
              k:=k+a[l];
          len[i,j]:=b[j]/k;
        end;
end;

procedure make(no:longint);
var
  i,j:longint;
begin
  j:=0;
  for i:=1 to n do
    if v[i] then
      if (j=0) or (best[i,no]<best[j,no]) then
        j:=i;
  while d[j,no]=0 do
    begin
      used[last[j,no],j]:=1;
      j:=last[j,no];
      v[j]:=true;
    end;
end;

procedure sort;
var
  i,j,k:longint;
  d:array[1..100] of longint;
begin
  fillchar(d,sizeof(d),0);
  for i:=1 to n do
    for j:=1 to n do
      if used[i,j]=1 then inc(d[j]);
  fillchar(lst,sizeof(lst),0);
  for j:=1 to n do
    begin
      k:=0;
      for i:=1 to n do
        if v[i] and (d[i]=0) then
          begin
            k:=i; break;
          end;
      if k=0 then break;
      d[k]:=-1;
      lst[j]:=k;
      for i:=1 to n do
        if used[k,i]=1 then dec(d[i]);
    end;
end;

procedure adjust;
var
  avail,need:array[1..100] of boolean;
  i,j,k,l,sa:longint;
  nowres:extended;
begin
  cs:=0; nowres:=0;
  td:=d;
  for i:=1 to n do
    begin
      if lst[i]=star then break;
      for j:=1 to n do
        if used[lst[i],j]=1 then
          begin
            sa:=0;
            for k:=1 to m do
              begin
                need[k]:=(td[lst[i],k]=1) and (td[star,k]=0) and (td[j,k]=0);
                if need[k] then
                  for l:=i+1 to n do
                    if lst[l]=0 then break
                    else if td[lst[l],k]=1 then
                      begin
                        need[k]:=false; break;
                      end;
                if need[k] then sa:=1;
              end;
            if sa=0 then continue;
            fillchar(avail,sizeof(avail),0);
            sa:=0;
            for k:=1 to n do
              if g[k,j]=1 then
                begin
                  avail[k]:=true;
                  for l:=1 to m do
                    if need[l] and (td[k,l]=0) then
                      begin
                        avail[k]:=false; break;
                      end;
                  if avail[k] then sa:=sa+a[k];
                end;
            nowres:=nowres+b[j]/sa;
            sa:=0;
            for k:=1 to n do
              if avail[k] then sa:=sa+1;
            cs:=cs+1;
            class[cs,0]:=sa; sa:=0;
            fillchar(need,sizeof(need),true);
            for k:=1 to n do
              if avail[k] then
                begin
                  sa:=sa+1; class[cs,sa]:=k;
                  for l:=1 to m do
                    if td[k,l]=0 then need[l]:=false;
                end;
            class[cs,sa+1]:=j;
            for k:=1 to m do
              if need[k] then td[j,k]:=1;
          end;
    end;
  if nowres<res then
    begin
      rc:=class; rs:=cs; ss:=star;
      res:=nowres;
    end;
end;

procedure print;
var
  i,j:longint;
begin
  assign(f,outf);
  rewrite(f);
  writeln(f,rs);
  for i:=1 to rs do
    begin
      for j:=0 to rc[i,0]+1 do
        write(f,rc[i,j],' ');
      writeln(f);
    end;
  writeln(f,ss);
  writeln(f,res:0:6);
  close(f);
end;

var
  now,i,j,k,l:longint;
  bestres:extended;
begin
  init;
  bestres:=maxlongint;
  randomize;
  for worktime:=1 to times do
    begin
      res:=maxlongint; ss:=0;
      for i:=1 to n do
        for j:=1 to m do
          if d[i,j]=1 then best[i,j]:=0
          else best[i,j]:=1e400;
      fillchar(last,sizeof(last),0);
      for now:=1 to m do
        begin
          fillchar(v,sizeof(v),0);
          repeat
            k:=0;
            for i:=1 to n do
              if not v[i] and (best[i,now]<maxlongint) then
                if (k=0) or (best[i,now]<best[k,now]) then
                  k:=i;
            if k<>0 then
              begin
                v[k]:=true;
                for i:=1 to n do
                  if (g[i,k]=1) and (best[k,now]+len[k,i]<best[i,now]) then
                    begin
                      best[i,now]:=best[k,now]+len[k,i];
                      last[i,now]:=k;
                    end;
              end;
          until k=0;
        end;
      for star:=1 to n do
        begin
          for i:=1 to m do list[i]:=i;
          for i:=1 to m do
            begin
              repeat
                j:=random(m)+1; k:=random(m)+1;
              until j<>k;
              l:=list[j]; list[j]:=list[k]; list[k]:=l;
            end;
          fillchar(v,sizeof(v),0);
          v[star]:=true;
          fillchar(used,sizeof(used),0);
          for i:=1 to m do
            if d[star,list[i]]=0 then make(list[i]);
          sort;
          adjust;
        end;
      if res<bestres then
        begin
          bestres:=res; print;
        end;
    end;
  writeln(bestres:0:6);
end.
