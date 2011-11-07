%% Mainfile 
% for common configurations of the simulation (mostly testing
% purposes

mapsize = 1000;		% Size of landscapemap
runduration = 100; 	% Duration of simulation

s = simulation(mapsize);
s.run(runduration);
