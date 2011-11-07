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
    methods
    	%% Initialize Landscape 
    	% size = n
        function L = landscape(n)
            L.size = n;
            L.plant = ones(n);
        end % init
        % Load a map with a specified plant and feeder/nest positions
        function L = load_map(P, F, N)
            L.plant = P;	% Set plant
            L.feeder = F;	% Set feeder
            L.nest = N;		% Set nest
        end % load_map
    end % methods
    methods (Static)
    end % Static functions
end % classdef
