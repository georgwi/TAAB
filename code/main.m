%% Mainfile 
% for common configurations of the simulation (mostly testing
% purposes

% clear everything

clc;
clear all; 
clf;
close all;

runduration = 100; 	% Duration of simulation

addpath('Maps');

%% Option1 saved Map
% all saved Maps can be found in the code-folder/Maps

%% two Obstacles - Experiment 1
% map1


%% map2
% noch erstellen.

%% Option2 random Map
% mapsize = 100;
% s = simulation(mapsize);
% s.l.generateLandscape(50, 50, 0.8);
% s.a.position = [5 5];
% s.l.nest = [5 5];
% s.l.feeder_radius = 50;

s = simulation(100);

s.l.load_image('test', 'png')
s.a.position = s.l.nest;

s.a.createGlobalVector(s.l);
s.a.createLocalVectors(s.l.landmarks);
s.run(runduration);
