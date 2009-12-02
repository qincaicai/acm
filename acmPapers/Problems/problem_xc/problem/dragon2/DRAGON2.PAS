{$A+,B-,D+,E+,F-,G-,I+,L+,N+,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 65520,0,655360}
Const
  Zero=1e-6;
  MaxStelae=20;{最大石柱数}
Type
  Point=Record
    x,y:Real;
  End;
  Line=Array[1..2]Of Point;
  Circle=Record
    Center:Point;
    R:Real;
  End;
  Stele=Record
    Center:Point;
    R:Real;
  End;
  Node=Record
    L:Line;
    C1,C2:Integer;
    Dis:Real;
  End;
  Pointer=^Node;
Var
  Pnts:Array[1..MaxStelae*4]Of Point;{存放所有圆心}
  Edge:Array[1..1000]Of Pointer;{存放所有边}
  Ep:Integer;{当前边的数目}
  Ls:Array[1..MaxStelae*2]Of Line;{存放所有对角线}
  Stone:Circle;{圆石信息}
  Target:Point;{目标位置}
  Ste:Array[1..MaxStelae]Of Stele;{石柱信息}
  N:Byte;
  Answer:Real;{最短路径长度}
(*******返回两点间距离*******)
Function GetDis(P1,P2:Point):Real;
Begin
  GetDis:=Sqrt(Sqr(P1.x-P2.x)+Sqr(P1.y-P2.y));
End;
(*******返回较大数*******)
Function Max(a,b:Real):Real;
Begin
  If a>b Then Max:=a Else Max:=b;
End;
(*******返回较小数*******)
Function Min(a,b:Real):Real;
Begin
  If a>b Then Min:=b Else Min:=a;
End;
(*******对两个实数比较大小，若前者大于后者，返回1；前者等于后者，返回0；前者小于后者，返回-1；*******)
Function Comp(a,b:Real):Integer;
Begin
  If Abs(a-b)<Zero Then Comp:=0
    Else If a>b Then Comp:=1
      Else Comp:=-1;
End;
(*******返回叉积值*******)
Function Multi(P0,P1,P2:Point):Real;
Begin
  Multi:=(P1.x-P0.x)*(P2.y-P0.y)-(P2.x-P0.x)*(P1.y-P0.y);
End;
(*******判断两条线段是否相交*******)
Function Intersect(L1,L2:Line):Boolean;
Begin
  If (Max(L1[1].x,L1[2].x)>Min(L2[1].x,L2[2].x))
  And(Max(L2[1].x,L2[2].x)>Min(L1[1].x,L1[2].x))
  And(Max(L1[1].y,L1[2].y)>Min(L2[1].y,L2[2].y))
  And(Max(L2[1].y,L2[2].y)>Min(L1[1].y,L1[2].y))
  And(Comp(Multi(L1[1],L2[1],L1[2])*Multi(L1[1],L1[2],L2[2]),0)=1)
  And(Comp(Multi(L2[1],L1[1],L2[2])*Multi(L2[1],L2[2],L1[2]),0)=1) Then
    Intersect:=True
    Else Intersect:=False;
End;
(*******返回过点P的两条切线在圆上的两个切点*******)
Procedure GetTanPoint(P:Point;C:Circle;Var TP1,TP2:Point);
Var
  s,d:Real;
Begin
  d:=GetDis(P,C.Center);
  If Comp(d,C.R)<=0 Then Begin TP1:=P;TP2:=P;Exit;End;
  s:=Sqrt(d*d-C.R*C.R);
  TP1.x:=((C.Center.x-P.x)*s*s+(C.Center.y-P.y)*C.R*s)/d/d+P.x;
  TP1.y:=((C.Center.y-P.y)*s*s-(C.Center.x-P.x)*C.R*s)/d/d+P.y;
  TP2.x:=((C.Center.x-P.x)*s*s-(C.Center.y-P.y)*C.R*s)/d/d+P.x;
  TP2.y:=((C.Center.y-P.y)*s*s+(C.Center.x-P.x)*C.R*s)/d/d+P.y;
End;
(*******返回两圆的四条公切线*******)
Procedure GetTanLine(C1,C2:Circle;Var L1,L2,L3,L4:Line);
Var
  P1,P2,P3,P4:Point;
  L:Line;
  d:Real;
Begin
  FillChar(L1,SizeOf(L1),0);
  FillChar(L2,SizeOf(L2),0);
  FillChar(L3,SizeOf(L3),0);
  FillChar(L4,SizeOf(L4),0);
  d:=GetDis(C1.Center,C2.Center);
  L[1]:=C1.Center;L[2]:=C2.Center;
  If Comp(d,C1.R)=1 Then{如果存在内公切线}
    Begin
      C2.R:=C2.R*2;
      GetTanPoint(C1.Center,C2,P3,P4);
      C2.R:=C2.R/2;
      P3.x:=(P3.x+C2.Center.x)/2;P3.y:=(P3.y+C2.Center.y)/2;
      P4.x:=(P4.x+C2.Center.x)/2;P4.y:=(P4.y+C2.Center.y)/2;
      C1.R:=C1.R*2;
      GetTanPoint(C2.Center,C1,P1,P2);
      C1.R:=C1.R/2;
      P1.x:=(P1.x+C1.Center.x)/2;P1.y:=(P1.y+C1.Center.y)/2;
      P2.x:=(P2.x+C1.Center.x)/2;P2.y:=(P2.y+C1.Center.y)/2;
      L1[1]:=P1;L1[2]:=P3;
      If Intersect(L,L1) Then
        Begin
          L2[1]:=P2;L2[2]:=P4;
        End
        Else Begin
          L1[2]:=P4;
          L2[1]:=P2;L2[2]:=P3;
        End;
    End;
  If Comp(d,0)=1 Then{如果存在外公切线}
    Begin
      P1.x:=C1.Center.x+C1.R*(C1.Center.y-C2.Center.y)/d;
      P1.y:=C1.Center.y+C1.R*(C2.Center.x-C1.Center.x)/d;
      P2.x:=C1.Center.x-C1.R*(C1.Center.y-C2.Center.y)/d;
      P2.y:=C1.Center.y-C1.R*(C2.Center.x-C1.Center.x)/d;
      P3.x:=C2.Center.x+C2.R*(C2.Center.y-C1.Center.y)/d;
      P3.y:=C2.Center.y+C2.R*(C1.Center.x-C2.Center.x)/d;
      P4.x:=C2.Center.x-C2.R*(C2.Center.y-C1.Center.y)/d;
      P4.y:=C2.Center.y-C2.R*(C1.Center.x-C2.Center.x)/d;
      L3[1]:=P1;L3[2]:=P4;
      If Intersect(L,L3) Then
        Begin
          L3[2]:=P3;
          L4[1]:=P2;L4[2]:=P4;
        End
        Else Begin
          L4[1]:=P2;L4[2]:=P3;
        End;
    End;
End;
(*******返回圆弧长度*******)
Function GetCircleLength(C:Circle;P1,P2:Point):Real;
Var
  CosA:Real;
  a,b:Real;
Begin
  a:=GetDis(C.Center,P1);
  b:=GetDis(C.Center,P2);
  CosA:=(Sqr(a)+Sqr(b)-Sqr(GetDis(P1,P2)))/a/b/2;
  If Comp(CosA,0)=0 Then GetCircleLength:=Pi/2*C.R
    Else GetCircleLength:=ArcTan(Sqrt(1-Sqr(CosA))/CosA)*C.R;
End;
(*******返回点到直线的距离*******)
Function GetDisToLine(P:Point;L:Line):Real;
Var
  a,b,c:Real;
Begin
  a:=GetDis(L[1],P);
  b:=GetDis(L[2],P);
  c:=GetDis(L[1],L[2]);
  If (Comp(a*a+c*c,b*b)=1)And(Comp(b*b+c*c,a*a)=1) Then
    Begin
      a:=L[2].y-L[1].y;
      b:=L[1].x-L[2].x;
      If Comp(a*a+b*b,0)=1 Then
        GetDisToLine:=Abs(a*(P.x-L[1].x)+b*(P.y-L[1].y))/Sqrt(a*a+b*b)
        Else GetDisToLine:=MaxLongInt;
    End
    Else GetDisToLine:=MaxLongInt;
End;
(*******判断点P是否合法*******)
Function ValidPoint(P:Point):Boolean;
Var
  i:Byte;
  T:Point;
Begin
  ValidPoint:=True;
  For i:=1 to N Do
    If ((Comp(Abs(P.x-Ste[i].Center.x),Ste[i].R+Stone.R)=-1)And(Comp(Abs(P.y-Ste[i].Center.y),Ste[i].R)=-1))
     Or((Comp(Abs(P.y-Ste[i].Center.y),Ste[i].R+Stone.R)=-1)And(Comp(Abs(P.x-Ste[i].Center.x),Ste[i].R)=-1)) Then
       Begin ValidPoint:=False;Exit;End;
  For i:=1 to N*4 Do
    If Comp(GetDis(P,Pnts[i]),Stone.R)=-1 Then
       Begin ValidPoint:=False;Exit;End
End;
(*******判断线段L是否合法*******)
Function ValidLine(L:Line):Boolean;
Var
  i:Byte;
Begin
  If ((Comp(L[1].x,L[2].x)=0)And(Comp(L[1].y,L[2].y)=0))
   Or(Not ValidPoint(L[1]))Or(Not ValidPoint(L[2])) Then ValidLine:=False
    Else Begin
      For i:=1 to N*2 Do
        If Intersect(Ls[i],L) Then Begin ValidLine:=False;Exit;End;
      For i:=1 to N*4 Do
        If Comp(GetDisToLine(Pnts[i],L),Stone.R)<=0 Then
          Begin ValidLine:=False;Exit;End;
      ValidLine:=True;
    End;
End;
(*******读入数据*******)
Procedure Init;
Var
  i:Byte;
Begin
  ReadLn(Stone.Center.x,Stone.Center.y,Stone.R,Target.x,Target.y);
  ReadLn(N);
{读入石柱信息并转化为中心-半径格式}
  For i:=1 to N Do
    Begin
      ReadLn(Ste[i].Center.x,Ste[i].Center.y,Ste[i].R);
      Ste[i].R:=Ste[i].R/2;
      Ste[i].Center.x:=Ste[i].Center.x+Ste[i].R;
      Ste[i].Center.y:=Ste[i].Center.y+Ste[i].R;
    End;
{计算所有圆心位置}
  For i:=1 to N Do
    Begin
      Pnts[i*4-3].x:=Ste[i].Center.x-Ste[i].R;
      Pnts[i*4-3].y:=Ste[i].Center.y-Ste[i].R;
      Pnts[i*4-2].x:=Ste[i].Center.x-Ste[i].R;
      Pnts[i*4-2].y:=Ste[i].Center.y+Ste[i].R;
      Pnts[i*4-1].x:=Ste[i].Center.x+Ste[i].R;
      Pnts[i*4-1].y:=Ste[i].Center.y-Ste[i].R;
      Pnts[i*4].x:=Ste[i].Center.x+Ste[i].R;
      Pnts[i*4].y:=Ste[i].Center.y+Ste[i].R;
      Ls[i*2-1,1]:=Pnts[i*4-3];Ls[i*2-1,2]:=Pnts[i*4];
      Ls[i*2,1]:=Pnts[i*4-2];Ls[i*2,2]:=Pnts[i*4-1];
    End;
End;
(*******主程序*******)
Procedure Main;
Var
  i,j,k:Integer;
  C,C1,C2:Circle;
  L,L1,L2,L3,L4:Line;
  P1,P2:Point;
  Min:Array[0..1000] Of Real;
  Mark:Array[0..1000] Of Boolean;
  d,s:Real;
Begin
  FillChar(Mark,SizeOf(Mark),0);
  For i:=1 to 1000 Do New(Edge[i]);
  For i:=1 to 1000 Do
    Min[i]:=1e10;
  Ep:=0;
  L[1].x:=0;L[1].y:=0;L[2].x:=1;L[2].y:=1;
  L[1]:=Stone.Center;
  L[2]:=Target;
  If ValidLine(L) Then
    Begin
      Inc(Ep);
      Edge[Ep]^.L:=L;
      Edge[Ep]^.C1:=0;Edge[Ep]^.C2:=N*4+1;
      Edge[Ep]^.Dis:=GetDis(L[1],L[2]);
      Min[Ep]:=Edge[Ep]^.Dis;
    End;
{计算出所有合法的从目标位置到各圆的切线}
  C.R:=Stone.R;C1.R:=Stone.R;C2.R:=Stone.R;
  For i:=1 to N*4 Do
    Begin
      For j:=i+1 to N*4 Do
        Begin
          C1.Center:=Pnts[i];C2.Center:=Pnts[j];
          GetTanLine(C1,C2,L1,L2,L3,L4);
          If ValidLine(L1) Then
              Begin
                Inc(Ep);
                With Edge[Ep]^ Do
                  Begin L:=L1;C1:=i;C2:=j;Dis:=GetDis(L[1],L[2]);End;
              End;
          If ValidLine(L2) Then
              Begin
                Inc(Ep);
                With Edge[Ep]^ Do
                  Begin L:=L2;C1:=i;C2:=j;Dis:=GetDis(L[1],L[2]);End;
              End;
          If ValidLine(L3) Then
              Begin
                Inc(Ep);
                With Edge[Ep]^ Do
                  Begin L:=L3;C1:=i;C2:=j;Dis:=GetDis(L[1],L[2]);End;
              End;
          If ValidLine(L4) Then
              Begin
                Inc(Ep);
                With Edge[Ep]^ Do
                  Begin L:=L4;C1:=i;C2:=j;Dis:=GetDis(L[1],L[2]);End;
              End;
        End;
      L[1]:=Stone.Center;
      If Comp(GetDis(Pnts[i],L[1]),Stone.R)=0 Then
        Begin
          L[2]:=L[1];
          Inc(Ep);
          Edge[Ep]^.L:=L;
          With Edge[Ep]^ Do
            Begin C1:=0;C2:=i;Dis:=0;End;
          Min[Ep]:=0;
        End
        Else Begin
          C.Center:=Pnts[i];
          GetTanPoint(L[1],C,P1,P2);
          L[2]:=P1;
          If ValidLine(L) Then
            Begin
              d:=GetDis(L[1],L[2]);
              Inc(Ep);
              Edge[Ep]^.L:=L;
              With Edge[Ep]^ Do
                Begin C1:=0;C2:=i;Dis:=d;End;
              Min[Ep]:=d;
            End;
          L[2]:=P2;
          If ValidLine(L) Then
            Begin
              d:=GetDis(L[1],L[2]);
              Inc(Ep);
              Edge[Ep]^.L:=L;
              With Edge[Ep]^ Do
                Begin C1:=0;C2:=i;Dis:=d;End;
              Min[Ep]:=d;
            End;
        End;
      L[2]:=Target;
      If Comp(GetDis(Target,Pnts[i]),Stone.R)=0 Then
        Begin
          Inc(Ep);
          L[1]:=L[2];
          Edge[Ep]^.L:=L;Edge[Ep]^.C1:=i;Edge[Ep]^.C2:=N*4+1;Edge[Ep]^.Dis:=0;
        End
        Else Begin
          C.Center:=Pnts[i];
          GetTanPoint(Target,C,P1,P2);
          L[1]:=P1;
          If ValidLine(L) Then
            Begin
              Inc(Ep);
              Edge[Ep]^.L:=L;Edge[Ep]^.C1:=i;Edge[Ep]^.C2:=N*4+1;Edge[Ep]^.Dis:=GetDis(L[1],L[2]);
            End;
          L[1]:=P2;
          If ValidLine(L) Then
            Begin
              Inc(Ep);
              Edge[Ep]^.L:=L;Edge[Ep]^.C1:=i;Edge[Ep]^.C2:=N*4+1;Edge[Ep]^.Dis:=GetDis(L[1],L[2]);
            End;
        End;
    End;
  {用Dijkstra算法求解}
  FillChar(Mark,SizeOf(Mark),False);
  For i:=1 to Ep Do
    Begin
      d:=1e10;
      For j:=1 to Ep Do
        If (Not Mark[j])And(Min[j]<d) Then
          Begin d:=Min[j];k:=j;End;
      If (Edge[k]^.C1=N*4+1)Or(Edge[k]^.C2=N*4+1) Then
        Begin
          Answer:=Min[k];
          Break;
        End;
      Mark[k]:=True;
      For j:=1 to Ep Do
        If Not Mark[j] Then
          If (Edge[j]^.C1=Edge[k]^.C1)And(Edge[j]^.C1>0) Then
            Begin
              C.Center:=Pnts[Edge[k]^.C1];C.R:=Stone.R;
              s:=Min[k]+GetCircleLength(C,Edge[k]^.L[1],Edge[j]^.L[1])+Edge[j]^.Dis;
              If s<Min[j] Then Min[j]:=s;
            End
            Else If (Edge[j]^.C1=Edge[k]^.C2)And(Edge[j]^.C1>0) Then
              Begin
                C.Center:=Pnts[Edge[k]^.C2];C.R:=Stone.R;
                s:=Min[k]+GetCircleLength(C,Edge[k]^.L[2],Edge[j]^.L[1])+Edge[j]^.Dis;
                If s<Min[j] Then Min[j]:=s;
              End
              Else If (Edge[j]^.C2=Edge[k]^.C1)And(Edge[j]^.C2>0) Then
                Begin
                  C.Center:=Pnts[Edge[k]^.C1];C.R:=Stone.R;
                  s:=Min[k]+GetCircleLength(C,Edge[k]^.L[1],Edge[j]^.L[2])+Edge[j]^.Dis;
                  If s<Min[j] Then Min[j]:=s;
                End
                Else If (Edge[j]^.C2=Edge[k]^.C2)And(Edge[j]^.C2>0) Then
                  Begin
                    C.Center:=Pnts[Edge[k]^.C2];C.R:=Stone.R;
                    s:=Min[k]+GetCircleLength(C,Edge[k]^.L[2],Edge[j]^.L[2])+Edge[j]^.Dis;
                    If s<Min[j] Then Min[j]:=s;
                  End;
    End;
End;
(******输出答案*******)
Procedure Print;
Begin
  WriteLn(Answer:0:2);
End;
Begin
  Assign(Input,'dragon2.in');
  Reset(Input);
  Assign(Output,'dragon2.out');
  Rewrite(Output);
  Init;
  Main;
  Print;
  Close(Input);
  Close(Output);
End.