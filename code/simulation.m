%% Simulation Class
% Handles everything simulationwise e.g. run the simulation, define simulation wide parameters
%% Variables
% * l
%	Landscape
%	defines the Landscape of the simulation
% * a TODO decide if should/could be an array or not (simulate more than one ant in a given simulation)
%	Ant
%	defines the ant of the simulation


classdef simulation
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
            for i=1:iterations
                S.a.move(S.l);
                S.render()
            end % for -> iterations
        end % run
        %% Render
        % renders the simulation (plant & ant)
        function render(S)
            S.l.plant(S.a.position(1), S.a.position(2)) = 2;
            imagesc(S.l.plant);
            pause(0.2);
        end % render
    end
end