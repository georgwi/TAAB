%% Mainfile 
% for common configurations of the simulation (mostly testing
% purposes

% clear everything

clc;
clear all; 

runduration = 100; 	% Duration of simulation

%% Option1 saved Map
load plant1;
mapsize = length(plant1);
s = simulation(mapsize);
s.l.load_map(plant);

%% Option2 random Map
% mapsize = 100;
% s = simulation(mapsize);
% s.l.generateLandscape(30, 20, 0.4);


s.run(runduration);