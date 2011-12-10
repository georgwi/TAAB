%% Mainfile 
% for common configurations of the simulation (mostly testing
% purposes

% clear everything

clc;
clear all; 
clf;
close all;

runduration = 9; 	% Duration of simulation
render = true;
path_render = 1;

addpath('Maps');

%% Option1 saved Map
% all saved Maps can be found in the code-folder/Maps

% two Obstacles - Experiment 1
%map1


%% Option2 random Map
 mapsize = 100;
 s = simulation(mapsize);
 s.l.generateLandscape(30, 88, 0.8);
 s.l.nest = [5 5];
 s.a.position = s.l.feeder;
 s.l.feeder = [95 95];


%% Option3 image Map
% s = simulation(100);
% s.l.load_image('map2', 'png')
% s.a.position = s.l.nest;
% s.l.landmarks = [s.l.landmarks; s.l.nest];

s.a.createGlobalVector(s.l);
s.a.createLocalVectors(s.l.landmarks);
s.init(render);
for i = 1:runduration
    s.run(render,path_render);
    i
end


%% Results

figure(2)
plot(s.a.results_food_finding,'r')
hold on
plot(s.a.results_nest_finding,'g')
legend('food-searching','nest-searching')
xlabel('number of runs')
ylabel('steps needed / time needed')