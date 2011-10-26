%% Definieren aller Möglichkeiten

mgl = [1 2 3 4];

%% Verhindern des "in die Wand fahrens"

if ( plant(x-1,y) == 1 )
	mgl(1) = 0;
end
if ( plant(x+1,y) == 1 )
    mgl(2) = 0;
end
if ( plant(x,y-1) == 1 )
	mgl(3) = 0;
end
if ( plant(x,y+1) == 1 )
    mgl(4) = 0;
end

%% Verhindern des "Umdrehens"

if ( plant(x-1,y) == 2 )
    mgl(1) = 0;
end
if ( plant(x+1,y) == 2 )
    mgl(2) = 0;
end
if ( plant(x,y-1) == 2 )
    mgl(3) = 0;
end
if ( plant(x,y+1) == 2 )
    mgl(4) = 0;
end

%% Bestimmen der Richtung

mgl(mgl == 0) = [];
dir = mgl(randi([1,length(mgl)]));

%% Bewegen des Spielers & Freigeben des vorletzten Feldes

tempx3 = tempx2; % vor-letzte Position wird zu vor-vor-letzter
tempy3 = tempy2;
tempx2 = tempx1; % letze Positon wird zu vor-letzter 
tempy2 = tempy1;
tempx1 = x; % aktuelle Position wird zu letzter
tempy1 = y;

if dir == 1
    x = x-1;
    plant(x,y) = 2;
    plant(tempx3,tempy3) = 0;
end
if dir == 2
    x = x+1;
    plant(x,y) = 2;
    plant(tempx3,tempy3) = 0;
end
if dir == 3
    y = y-1;
    plant(x,y) = 2;
    plant(tempx3,tempy3) = 0;
end
if dir == 4
    y = y+1;
    plant(x,y) = 2;
    plant(tempx3,tempy3) = 0;
end
