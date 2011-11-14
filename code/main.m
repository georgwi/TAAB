%% Mainfile 
% for common configurations of the simulation (mostly testing
% purposes

% clear everything

clc;
clear all; 

mapsize = 100;		% Size of landscapemap
runduration = 100; 	% Duration of simulation
antcount = 1;       % Number of Ants

s = simulation(mapsize,antcount);
%s.l.generateLandscape(30, 20, 0.4);
load plant1;
s.l.load_map(plant, 1, 2);
s.run(runduration);