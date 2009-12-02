{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,655360}
Uses D1;
Var
  Map:Array[1..100,1..100]Of Byte;{存储矩阵}
  M,N:Byte;
(*******获取从第i1行到第i2行，从第j1行到第j2行矩形范围内的所有矩阵元素*******)
Procedure Get(i1,j1,i2,j2:Byte;Count:Integer);
Var
  i,j,k,l:Integer;
Begin
  If Count=0 Then{如果矩阵中全为0}
    Begin
      For i:=i1 to i2 Do
        For j:=j1 to j2 Do
          Map[i,j]:=0;
    End
    Else If Count=(i2-i1+1)*(j2-j1+1) Then{如果矩阵中全为1}
      Begin
        For i:=i1 to i2 Do
          For j:=j1 to j2 Do
            Map[i,j]:=1;
      End
      Else Begin
        k:=Random(2);{随机决定分割方法}
        If ((k=0)And(i1<i2))Or(j1>=j2) Then{横向分割}
          Begin
            k:=(i1+i2)Div 2;
            l:=Detect(i1,j1,k,j2);
            Get(i1,j1,k,j2,l);
            Get(k+1,j1,i2,j2,Count-l);
          End
          Else Begin{竖向分割}
            k:=(j1+j2)Div 2;
            l:=Detect(i1,j1,i2,k);
            Get(i1,j1,i2,k,l);
            Get(i1,k+1,i2,j2,Count-l);
          End;
      End;
End;
(*******输出答案*******)
Procedure Print;
Var
  i,j:Byte;
Begin
  For i:=1 to M Do
    Begin
      For j:=1 to N Do
        Write(Map[i,j]);
      WriteLn;
    End;
End;
Begin
  Start;
  Assign(Input,'dragon1.in');
  Reset(Input);
  Assign(Output,'dragon1.out');
  Rewrite(Output);
  Randomize;
  ReadLn(M,N);
  Get(1,1,M,N,Detect(1,1,M,N));
  Print;
  Close(Output);
  Close(Input);
  Finish;
End.