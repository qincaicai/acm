{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S-,T+,V-,X+}
{$M 16384,0,655360}
const
	Infns='polygon.in';
	Outfns='polygon.out';
	LimitN=100;{100?/1000?/10000?}
type
	TCoord=record
			x,y:longint;
			concave:boolean;
		   end;
	TLinear=array[0..LimitN+1] of TCoord;
var
	Coord:TLinear;
	n:longint;
	xmin,xmax,ymin,ymax:longint;
	total:extended;
	buffer:array[0..4095] of char;
	nowtime:longint absolute $40:$6c;
	start:longint;

procedure Readin;
  var
	i:longint;
  begin
	assign(input,Infns); reset(input);
	readln(xmin,xmax,ymin,ymax);
	readln(n);
	for i:=1 to n do
	  with Coord[i] do readln(x,y);
	close(input);
  end;

procedure Init;
  var
	i:longint;
  begin
	Coord[0]:=Coord[n]; Coord[n+1]:=Coord[1];
	for i:=1 to n do
	  with Coord[i-1] do
		Coord[i].concave:=(Coord[i+1].x-x)*(Coord[i].y-y)
						 <(Coord[i].x-x)*(Coord[i+1].y-y);
  end;

procedure max(var a:longint; b:longint);
  begin
	if b>a then a:=b;
  end;

procedure min(var a:longint; b:longint);
  begin
	if b<a then a:=b;
  end;

procedure GetAnswer;
  var
	i,j,left,right,x2,y1,y2,t,
	left1,left2,right2,right1:longint;
	f:text;
  procedure RenewBorder;
	begin
		if Coord[j].concave or Coord[j+1].concave
		  then begin
			max(left1,left);	min(right1,right);
			max(left2,left);	min(right2,right);
		  end
		  else begin
			if left>=left2
			  then begin
				left1:=left2; left2:=left;
			  end
			  else max(left1,left);
			if right<right2
			  then begin
				right1:=right2; right2:=right;
			  end
			  else min(right1,right);
		  end;
	end;
  begin {of GetAnswer}
	assign(f,Outfns);
	settextbuf(f,buffer);
	rewrite(f);
	for i:=ymin to ymax do begin
		left1:=xmin; left2:=xmin;
		right1:=xmax; right2:=xmax;
		for j:=1 to n do
		  with Coord[j]	do begin
			x2:=Coord[j+1].x-x;	y2:=Coord[j+1].y-y;
			y1:=i-y;	t:=x2*y1;
			left:=xmin;	right:=xmax;
			case y2 of
			  0: if t>=0 then right:=xmin-1;
			  1..maxint: max(left,trunc(t/y2)+1+x);
			  else min(right,trunc(t/y2)-1+x);
			end;
			RenewBorder;
		  end; {of ForJ}
		for j:=left1 to right2 do writeln(f,j,' ',i);
		if left1<=right2
			then total:=total+right2-left1+1;
		max(left2,right2+1);
		for j:=left2 to right1 do writeln(f,j,' ',i);
		if left2<=right1
			then total:=total+right1-left2+1;
	end;
	close(f);
  end;

begin
	total:=0;
	start:=nowtime;
	Readin;
	Init;
	GetAnswer;
	assign(output,''); rewrite(output);
	writeln('Total=',total:0:0);
	writeln((nowtime-start)/18.2:0:2);
end.
