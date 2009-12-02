Unit D1;

Interface
Procedure Start;
Function Detect(i1,j1,i2,j2:Byte):Integer;
Procedure Finish;

Implementation
Var
  Map:Array[1..100,1..100]Of Byte;
  M,N:Byte;
  DetectTime:LongInt;
  Fin,Fout:Text;
Procedure Start;
Var
  i,j:Byte;
  Ch:Char;
Begin
  Assign(Fin,'dragon1.in');
  Reset(Fin);
  ReadLn(Fin,M,N);
  Close(Fin);
  Assign(Fin,'dragon1.map');
  Reset(Fin);
  For i:=1 to M Do
    Begin
      For j:=1 to N Do
        Begin
          Read(Fin,Ch);
          If Ch='0' Then Map[i,j]:=0
            Else Map[i,j]:=1;
        End;
      ReadLn(Fin);
    End;
  Close(Fin);
  DetectTime:=0;
End;
Function Detect(i1,j1,i2,j2:Byte):Integer;
Var
  i,j:Byte;
  k:Integer;
Begin
  If i1<1 Then i1:=1;
  If i2>M Then i2:=M;
  If j1<1 Then j1:=1;
  if j2>N Then j2:=N;
  k:=0;
  For i:=i1 to i2 Do
    For j:=j1 to j2 Do
      If Map[i,j]>0 Then Inc(k);
  Detect:=k;
  Inc(DetectTime);
End;
Procedure Finish;
Begin
  Assign(Fout,'dragon1.res');
  Rewrite(Fout);
  WriteLn(Fout,DetectTime);
  Close(Fout);
End;
Begin
End.