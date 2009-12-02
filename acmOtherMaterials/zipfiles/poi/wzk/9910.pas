program tro; {POI99_10}
var
  son:array[1..10000,0..2] of longint;
  min,max:array[1..10000,0..1] of longint;
  done:array[1..10000,0..1] of boolean;
  s,result,n:longint;
  ch:char;
  f:text;

procedure readson(no:longint);
begin
  read(f,ch);
  son[no,0]:=ord(ch)-48;
  if son[no,0]>0 then
    begin
      s:=s+1; son[no,1]:=s;
      readson(s);
    end;
  if son[no,0]>0 then
    begin
      s:=s+1; son[no,2]:=s;
      readson(s);
    end;
  if son[no,0]=0 then
    begin
      min[no,0]:=0; max[no,0]:=0;
      min[no,1]:=0; max[no,1]:=0;
      done[no,0]:=true; done[no,1]:=true;
    end
  else
    begin
      min[no,0]:=-1; max[no,0]:=-1;
      min[no,1]:=-1; max[no,1]:=-1;
      done[no,0]:=false; done[no,1]:=false;
    end;
end;

procedure search(no,flag:longint);
var
  i,j:integer;
begin
  if done[no,flag] then exit;
  i:=son[no,1]; j:=son[no,2];
  search(i,0);
  search(i,1);
  if son[no,0]=1 then
    begin
    end
  else
    begin
    end;
end;

begin
  assign(f,'tro.in');
  reset(f);
  n:=1;
  readson(1);
  close(f);
  search(1,0);
  search(1,1);
  if max[1,0]>max[1,1]+1 then result:=max[1,0]
  else result:=max[1,1]+1;
  writeln(result);
  if min[1,0]<min[1,1]+1 then result:=min[1,0]
  else result:=min[1,1]+1;
  writeln(result);
end.
