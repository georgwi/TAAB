%% Freigeben des vorletzten Feldes

% Verschieben der nt-letzten Position auf die n+1t-letzte
for j = 0:n-2
    positions(n-j,:) = positions(n-j-1,:);
end
positions(1,:) = [x y];

plant(positions(n,1),positions(n,2)) = 0;

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

%% Testen auf Konflikte in der Zukunft

testpath

%% Bestimmen der Richtung

mgl(mgl == 0) = [];
if length(mgl) == 0
    disp('Festgefahren - kein möglicher Wegpunkt mehr frei!');
    disp('Eventuell die Länge der Schlange reduzieren.');
    break
end
dir = mgl(randi([1,length(mgl)]));

%% Bewegen des Spielers

if dir == 1
    x = x-1;
end
if dir == 2
    x = x+1;
end
if dir == 3
    y = y-1;
end
if dir == 4
    y = y+1;
end

plant(x,y) = 2;

