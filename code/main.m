%% Mainfile 
% for common configurations of the simulation (mostly testing
% purposes

% clear everything

clc;
clear all; 

runduration = 100; 	% Duration of simulation

%% Option1 saved Map
cd Maps
% all saved Maps can be found in the code-folder/Maps

map1
% two Obstacles - Experiment 1

% map2
% noch erstellen.


cd ..
mapsize = length(plant);
s = simulation(mapsize);
s.l.load_map(plant);
s.a.position = antstart;
s.l.nest = neststart;

%% Option2 random Map
% mapsize = 100;
% s = simulation(mapsize);
% s.l.generateLandscape(30, 20, 0.4);
% s.a.position = [2 2];
% s.l.nest = [2 2];

s.a.createGlobalVector(s.l);
s.run(runduration);