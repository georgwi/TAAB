clc
clf
clear all

%% Laden der Variablen

vars

%% Generieren des Spielfelds

Plant

%% Plazieren des Spielers

plant(x,y) = 2;

%% Bewegen des Spielers & Animation

for i = 1:t
    move
    
    imagesc (plant)
    colormap ([0 1 0; 1 0 0; 0 0 1]);
    pause (3/speed)
end
