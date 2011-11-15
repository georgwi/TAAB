%% Mainfile 
% for common configurations of the simulation (mostly testing
% purposes

% clear everything

clc;
clear all; 

runduration = 100; 	% Duration of simulation

%% Option1 saved Map
T = load('plant1');
mapsize = length(T.plant);
s = simulation(mapsize);
s.l.load_map(T.plant);

%% Option2 random Map
% mapsize = 100;
% s = simulation(mapsize);
% s.l.generateLandscape(30, 20, 0.4);

s.a.createGlobalVector(s.l);
s.run(runduration);