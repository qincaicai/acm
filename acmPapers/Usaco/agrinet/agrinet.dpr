###PROGRAM
{
ID:Bluedog001
PROG:agrinet
}
var
  f1,f2:text;
  min,n,i,j,k:longint;
  a:array[1..100,1..100]of longint;
  b:array[1..100]of longint;
  s1,s2:set of 1..100;
begin
  assign(f1,'agrinet.in');
  reset(f1);
  readln(f1,n);
  for i:=1 to n do
    begin
      for j:=1 to n do
        begin
          if eoln(f1) then readln(f1);
          read(f1,a[i,j]);
        end;
      readln(f1);
    end;
  close(f1);
  assign(f2,'agrinet.out');
  rewrite(f2);
  s1:=[1];
  s2:=[2..n];
  min:=0;
  for i:=2 to n do
    begin
      fillchar(b,sizeof(b),0);
      for j:=1 to n do
        if j in s2 then
          for k:=1 to n do
            if k in s1 then if (a[j,k]<b[j]) or (b[j]=0) then b[j]:=a[j,k];
      k:=0;
      for j:=1 to n do
        if j in s2 then
          if (k=0) or (b[j]<b[k]) then k:=j;
      min:=min+b[k];
      s1:=s1+[k];
      s2:=s2-[k];
    end;
  writeln(f2,min);
  close(f2);
  // Insert user code here
end.
###END