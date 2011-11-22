%% Mainfile 
% for common configurations of the simulation (mostly testing
% purposes

% clear everything

clc;
clear all; 
clf; 

runduration = 100; 	% Duration of simulation

addpath('Maps');

%% Option1 saved Map
% all saved Maps can be found in the code-folder/Maps

map1
% two Obstacles - Experiment 1

% map2
% noch erstellen.

mapsize = length(plant);
s = simulation(mapsize);
s.l.load_map(plant);
s.a.position = antstart;
s.l.nest = neststart;
s.l.feeder = feederstart;
s.l.setFeederRadius(50);
%% Option2 random Map
% mapsize = 100;
% s = simulation(mapsize);
% s.l.generateLandscape(30, 20, 0.4);
% s.a.position = [2 2];
% s.l.nest = [2 2];

%s = simulation(100);

%s.l.load_image('test', 'png')

s.a.createGlobalVector(s.l);
s.run(runduration);