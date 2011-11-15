%% Simulation Class
% Handles everything simulationwise e.g. run the simulation, define simulation wide parameters
%% Variables
% * l
%	Landscape
%	defines the Landscape of the simulation
% * a TODO decide if should/could be an array or not (simulate more than one ant in a given simulation)
%	Ant
%	defines the ant of the simulation


classdef simulation < handle
    properties (SetAccess = private)
        l;
        a;
    end
    methods (Access = public)
    	%% Initialization
    	% Initalizes a simulation with landscape size N
    	% Ant is at the moment placed in the center of the map
        function S = simulation(N)
            S.l = landscape(N);
            S.a = ant(N);
        end
        %% Run
        % Runs simulation for specified amount of iterations
        function run(S, iterations)
            figure(1)
            imagesc(S.l.plant)
            axis square
            colormap ([0 1 0; 1 0 0; 1 0 0])
            hold on
            i = 1;
            while i <= iterations && S.a.nest ~= 1
                S.a.move(S.l)
                S.render()
            end % while ant is not at nest.
        end % run
        %% Render
        % renders the simulation (plant & ant)
        function render(S)
            figure(1)
            plot(S.a.position(1), S.a.position(2),...
                '.','Color','b')
            plot(S.l.nest(1), S.l.nest(2),...
                'o','Color','k')
            plot(S.a.position(1)-S.a.move_direction(1), S.a.position(2)-S.a.move_direction(2),...
                '.','Color','w')
            
            pause(0.1)
        end % render
    end
end
