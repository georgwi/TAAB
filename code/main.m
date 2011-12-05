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

% two Obstacles - Experiment 1
% map1


%% Option2 random Map
% mapsize = 100;
% s = simulation(mapsize);
% s.l.generateLandscape(30, 55, 0.2);
% s.l.nest = [5 5];
% s.a.position = s.l.nest;
% s.l.feeder = [95 95];


%% Option3 image Map
s = simulation(100);
s.l.load_image('map2', 'png')
s.a.position = s.l.nest;

s.l.landmarks = [s.l.landmarks; s.l.nest];
s.a.createGlobalVector(s.l);
s.a.createLocalVectors(s.l.landmarks);
s.init();
for i = 1:10
    s.run(1);
end


%% Results
disp('Steps needed for finding food')
disp(s.a.results_food_finding)
disp('Steps needed for returning to the nest')
disp(s.a.results_nest_finding)