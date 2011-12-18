%% Mainfile 
% for common configurations of the simulation (mostly testing
% purposes and initiating)

clc;
clear all; 
clf;
close all;
addpath('Maps');


%% Variables

runduration = 4; 	% Duration of simulation
render = true;
path_render = true;



%% Options for different map-loading methods
% only one option should be enabled

% 1. Map from m-file
% ------------------------------------------------
%map1


% 2. Random map from generator
% Some values need to be set by the user:
% ------------------------------------------------
% mapsize = 100;
% s = simulation(mapsize, render, path_render);
% s.l.generateLandscape(mapsize, 30, 55, 0.8);
% s.l.nest = [5 5];
% s.a.position = s.l.nest;
% s.l.feeder = [95 95];


% 3. Map from image.png
% ------------------------------------------------
s = simulation(100, render, path_render);
s.l.load_image('map2', 'png')
s.a.position = s.l.nest;
s.l.landmarks = [s.l.landmarks; s.l.nest];



%% Run the simulation

s.a.createGlobalVector(s.l);
s.a.createLocalVectors(s.l.landmarks);

for i = 1:runduration
    s.run();
end

aviobj = close(s.aviobj);
% enable to create a movie (3/3)


%% Plotting the results on steps

figure(2)
plot(s.a.results_food_finding,'r')
hold on
plot(s.a.results_nest_finding,'g')
legend('food-searching','nest-searching')
xlabel('number of runs')
ylabel('steps needed / time needed')