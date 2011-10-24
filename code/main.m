%% INIT Ant Navigation and Desert Ant Behaviour

mapsize = 10;
map = zeros(mapsize);

landmark1 = [1 1 1; 1 1 1; 1 1 1];
landmark2 = [2 2 2 2; 2 2 2 2; 2 2 2 2];

map(1:3,1:3) = landmark1;

imagesc(map)

run_simulation(map,10,[7;5],[10,10],10)

