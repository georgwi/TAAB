n = 100;
    plant = zeros(n,n);
	plant(1,:) = ones(1,n);
	plant(n,:) = ones(1,n);
	plant(:,1) = ones(1,n);
	plant(:,n) = ones(1,n);
    
    posx = round([n/5 2*n/5 3*n/5 4*n/5]);
    posy = round([n/6 2*n/6 3*n/6 4*n/6 5*n/6]);
    
    plant(posy(1):posy(5),posx(2)) = ones;
    plant(posy(2):posy(4),posx(3)) = ones;
    
neststart = [posx(1),posy(3)];
feederstart = [posx(4), posy(3)];
antstart = feederstart;

mapsize = length(plant);
s = simulation(mapsize, true, true);
s.l.load_map(plant);
s.l.nest = neststart;
s.l.feeder = feederstart;
s.a.position = s.l.feeder;

