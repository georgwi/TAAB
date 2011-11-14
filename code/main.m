%% Mainfile 
% for common configurations of the simulation (mostly testing
% purposes

% clear everything

clc; clear all; 

mapsize = 100;		% Size of landscapemap
runduration = 100; 	% Duration of simulation

s = simulation(mapsize);
s.l.generateLandscape(0, 18, 0.8);
s.a.createGlobalVector(s.l);
s.run(runduration);