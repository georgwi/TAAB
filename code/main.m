%% Mainfile 
% for common configurations of the simulation (mostly testing
% purposes

% clear everything

clc; clear all; 

mapsize = 100;		% Size of landscapemap
runduration = 100; 	% Duration of simulation

s = simulation(mapsize);
s.l.generateLandscape(50, 8, 0.7);
s.run(runduration);
