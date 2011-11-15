%% Landscape class
% A class for handling the landscape of a simulation
%% Properties
% * size: 
%	int, size of quadratic landscape
% * plant(size, size):
%	int-array map of landscape
% * feeder(1,1):
%	int-array position of 

classdef landscape < handle
    properties (SetAccess = public)
        size;
        plant;
        feeder;
        nest;
    end
    methods (Access = private)
    end
    methods (Access = public) 
    	%% Initialize Landscape 
    	% size = n
        function L = landscape(N)
            L.size = N;
            L.feeder = round([1/3*N 2/3*N]);
            L.nest = [30 40]; % Testing
            %L.nest = round([2/3*N 1/3*N]);
        end % init
        
        %% Stump for external generateLandscape function
        function generateLandscape(L, obstaclecount, obstaclesize, obstacleprobability)
            L.plant = generateLandscape(L.size, obstaclecount, obstaclesize, obstacleprobability);
        end

        %% Function to set nest and feeder positions (not always required)
        % Nest = nestposition, Feeder = feederposition
        function setNestAndFeeder(Nest, Feeder)
            L.nest = Nest;
            L.feeder = Feeder;
        end
        
        % Load a map with a specified plant and feeder/nest positions
        function load_map(L, P)
            L.plant = P;	% Set plant
            L.size = length(P);
        end % load_map
    end % methods
    methods (Static)
    end % Static functions
end % classdef
