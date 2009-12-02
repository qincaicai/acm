{$R-,S-,Q-}

uses Graph,Crt;

const
  Fn            ='output.txt';
  Mapst         :array[1..7] of Integer=(1,1,1,1,2,3,4);
  Maped         :array[1..7] of Integer=(3,4,5,6,6,6,6);
  C             :array[1..7] of Integer=
                (LightBlue,LightGreen,LightRed,
                Yellow,White,Cyan,LightMagenta);

type
  TMap          =array[1..7,1..7] of Integer;

var
  Map           :TMap;
  i,j           :Integer;
  Num           :string;
begin
  Assign(Input,Fn);Reset(Input);
  FillChar(Map,Sizeof(Map),0);
  for i:=1 to 7 do
    for j:=Mapst[i] to Maped[i] do
      Read(Map[i,j]);
  Close(Input);
  i:=Detect;
  InitGraph(i,j, 'E:\BP\BGI');
  ClearDevice;
  for i:=1 to 7 do
    for j:=1 to 7 do
      if Map[i,j]<>0 then begin
        SetColor(C[Map[i,j]]);
        SetFillStyle(1,C[Map[i,j]]);
        PieSlice(100+i*50,100+j*50-i*25,1,360,20);
        SetColor(Black);
        Str(Map[i,j],Num);
        OutTextXY(100+i*50,100+j*50-i*25,Num);
      end;
  Readkey
end.
