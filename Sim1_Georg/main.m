clc
clf
clear all

%% Laden der Variablen

vars

if N < 10
    disp('bitte die Spielfeldgrösse mindestens auf 10 setzten!')
    N = 10
end

%% Generieren des Spielfelds, Initialisieren der Variablen

Plant
grid on;

x=round(N/2);
y=round(N/2);

positions = zeros(n,2);
positions(positions == 0) = [2];

%% Plazieren des Spielers

plant(x,y) = 2;

%% Bewegen des Spielers & Animation

for i = 1:t
    % Bewegen
    move
    
    % Animation
    imagesc (plant)
    colormap ([0 1 0; 1 0 0; 0 0 1]);
    pause (3/speed)
end
