{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,655360}
Type
  Node=Array[0..99]Of Integer;
  Pointer=^Node;
Var
  Act:Array[1..100,1..2]Of Integer;{Act[i,1]表示选择第i种招数对自身造成的伤害值，,
                                    Act[i,2]表示表示选择第i种招数对巨龙造成的伤害值}
  Item:Array[1..100]Of Integer;{Item[i]表示第i瓶药水所能增加的生命值}
  Blood:Array[0..1000]Of Pointer;{Blood[i Div 100]^[i Mod 100]表示补充i点HP值所需的回合数}
  Min,HP1,HP2,M,N:Integer;
  Total:LongInt;{所有药水总共能增加的HP值}
  Answer:Array[1..3]Of Integer;{分别表示3种结局的答案}
Procedure Init;{读入数据并作相应的初始处理}
Var
  AF1,AF2,DF1,DF2,i,j,k,l:Integer;
Begin
  ReadLn(HP1,AF1,DF1,HP2,AF2,DF2);
  ReadLn(M,N);
  FillChar(Act,SizeOf(Act),0);
  FillChar(Item,SizeOf(Item),0);
(*******读入所有招数的攻防修正值，并立即计算出双方所受的伤害值*******)
  For i:=1 to M Do
    Begin
      ReadLn(j,k);
      Inc(j,AF1);Inc(k,DF1);
      If j<0 Then j:=0;
      If k<0 Then k:=0;
      Act[i,1]:=AF2-k;Act[i,2]:=j-DF2;
      If Act[i,1]<0 Then Act[i,1]:=0;
      If Act[i,2]<0 Then Act[i,2]:=0;
    End;
(*******找出对修玛伤害值最小的招数*******)
  Min:=MaxInt;
  For i:=1 to M Do
    If Act[i,1]<Min Then
      Min:=Act[i,1];
(*******将所有招数按照对巨龙的伤害值从大到小排序*******)
  For i:=1 to M-1 Do
    Begin
      k:=i;
      For j:=i+1 to M Do
        If (Act[j,2]>Act[k,2])Or((Act[j,2]=Act[k,2])And(Act[j,1]>Act[k,1])) Then k:=j;
      If k<>i Then
        Begin
          l:=Act[k,1];Act[k,1]:=Act[i,1];Act[i,1]:=l;
          l:=Act[k,2];Act[k,2]:=Act[i,2];Act[i,2]:=l;
        End;
    End;
(*******从所有招数中去掉不符要求的*******)
  i:=1;j:=2;
  While j<=M Do
    Begin
      If Act[j,2]<=0 Then Break;
      If Act[j,1]>=Act[i,1] Then Inc(j)
        Else If j<>i+1 Then Begin Act[i+1]:=Act[j];Inc(i);Inc(j);End
          Else Begin Inc(i);Inc(j);End;
    End;
  M:=i;
  If Act[1,2]=0 Then M:=0;
(*******读入所有药水增加的HP值*******)
  For i:=1 to N Do
    Begin
      ReadLn(Item[i]);
      If AF2>DF1 Then Dec(Item[i],AF2-DF1);
    End;
(*******将所有药水按照效果从大到小排序*******)
  For i:=1 to N-1 Do
    Begin
      k:=i;
      For j:=i+1 to N Do
        If Item[j]>Item[k] Then k:=j;
      If k<>i Then Begin l:=Item[k];Item[k]:=Item[i];Item[i]:=l;End;
    End;
(*******计算出Blood值并去掉不符要求的药水*******)
  For i:=0 to 1000 Do New(Blood[i]);
  i:=0;j:=1;Blood[0]^[0]:=0;
  While j<=N Do
    Begin
      If Item[j]<=0 Then Begin N:=j-1;Break;End;
      For k:=1 to Item[j] Do
        Blood[(i+k)Div 100]^[(i+k)Mod 100]:=j;
      Inc(i,Item[j]);Inc(j);
    End;
(*******计算出Total值*******)
  Total:=0;
  For i:=1 to N Do
    Inc(Total,Item[i]);
End;
Procedure Main;{递推求解}
Var
  T1,T2:Array[1..1000]Of LongInt;{T1[i]表示当前回合巨龙HP值为i时修玛可能的最大HP值，
                                  T2[i]表示下一回合巨龙HP值为i时修玛可能的最大HP值}
  Mark1,Mark2:Array[1..1000]Of Boolean;{Mark1[i]为真表示当前回合存在巨龙HP值为i的结点，
                                        Mark2[i]为真表示下一回合存在巨龙HP值为i的结点}
  i,j:Integer;
  Turn:Integer;{当前回合数}
  k,l:LongInt;
  Next:Boolean;{是否进行下一回合的递推}
Begin
  FillChar(Mark1,SizeOf(Mark1),False);
  Mark1[HP2]:=True;
  For i:=1 to HP2-1 Do T1[i]:=MaxLongInt;
  T1[HP2]:=HP1+Total;
  Answer[1]:=MaxInt;Answer[2]:=MaxInt;Answer[3]:=0;
  T2:=T1;
  Turn:=0;
  Repeat
    Inc(Turn);
    FillChar(Mark2,SizeOf(Mark2),False);
    Next:=False;
    For i:=1 to HP2 Do
      If Mark1[i] Then
        Begin
          Next:=True;
          For j:=1 to M Do
            Begin
              k:=T1[i]-Act[j,1];{修玛HP值}
              l:=i-Act[j,2];{巨龙HP值}
              If (k>0)And(l<=0) Then{第1种结局，杀死巨龙}
                Begin
                  If k>Total Then k:=Turn
                    Else k:=Turn+Blood[(Total-k+1) Div 100]^[(Total-k+1) Mod 100];
                  If k<Answer[1] Then Answer[1]:=k;
                End
                Else If (k<=0)And(l<=0) Then{第2种结局，同归于尽}
                  Begin
                    If T1[i]>Total Then k:=Turn
                      Else k:=Turn+Blood[(Total-T1[i]+1) Div 100]^[(Total-T1[i]+1) Mod 100];
                    If k<Answer[2] Then Answer[2]:=k;
                  End
                  Else If (k<=0)And(l>0) Then{第3种结局，被巨龙杀死}
                    Begin
                      If Turn+N>Answer[3] Then Answer[3]:=Turn+N;
                    End
                    Else Begin
                      If k<=T2[l] Then{如果可能得到更优解}
                        Begin
                          T2[l]:=k;Mark2[l]:=True;
                        End;{产生下一结点}
                    End;
            End;
        End;
    Mark1:=Mark2;
    T1:=T2;
  Until Not Next;
End;
Procedure Print;{输出答案}
Var
  i:Byte;
  j:Integer;
Begin
  If Answer[1]<MaxInt Then WriteLn('Huma kills the dragon in ',Answer[1],' turn(s)')
    Else If Answer[2]<MaxInt Then WriteLn('Huma dies with the dragon in ',Answer[2],' turn(s)')
      Else Begin
        j:=(HP1+Total-1)Div Min+1;
        If Answer[3]<MaxInt Then WriteLn('Huma is killed by the dragon in ',j,' turn(s)');
      End;
End;
Begin
  Assign(Input,'dragon3.in');
  Reset(Input);
  Assign(Output,'dragon3.out');
  Rewrite(Output);
  Init;
  Main;
  Print;
  Close(Input);
  Close(Output);
End.