const
	Outfns='polygon.out';
	Stdfns='polygon.std';
var
	x,y,tx,ty,stand,count,
	sy,sl,sr,oy,left,right:longint;
	fo,fs:text;
procedure Error;
  begin
	writeln('Error!'); halt;
  end;

begin
	count:=0; stand:=0;
	assign(fo,outfns); reset(fo);
	assign(fs,stdfns); reset(fs);
	readln(fs,tx,ty);
	if not seekeof(fo) then begin
	readln(fo,x,y);
	while true do begin
		oy:=y;	left:=x; right:=left;
		while (not seekeof(fo)) and (y=oy) do begin
			right:=x; readln(fo,x,y);
			if (y<oy) or ((y=oy) and (x<right))then error;
		end;
		if y=oy then right:=x;
		if ty>oy then error;
		repeat
			sy:=ty; sl:=tx; sr:=tx;
			while (not seekeof(fs)) and (ty=sy) do begin
				sr:=tx;	readln(fs,tx,ty);
			end;
			inc(stand,sr-sl+1);
			if ty=sy then sr:=tx;
		until seekeof(fs) or (sy=oy);
		if (left<sl) or (right>sr) or ((ty=sy) and (y>oy))then error;
		inc(count,right-left+1);
		if y=oy then break;
	end;
	end;
	if ty>sy then inc(stand);
	while not seekeof(fs) do begin
		readln(fs,x,y); inc(stand);
	end;
	close(fo);close(fs);
	writeln('Standard Answer:',stand);
	writeln('Your Answer:',count);
	writeln(count/stand*13:0:2);
end.
