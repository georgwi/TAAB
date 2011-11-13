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
        function generateLandscape(L, n, p)
            L.plant = zeros(n);
            L.plant(1,:) = ones(1,n);
            L.plant(n,:) = ones(1,n);
            L.plant(:,1) = ones(1,n);
            L.plant(:,n) = ones(1,n);
        end
    end
    methods (Access = public) 
    	%% Initialize Landscape 
    	% size = n
        function L = landscape(N)
            L.size = N;
            L.generateLandscape(N, 0.95);
            L.feeder = [1/3*N 2/3*N];
            L.nest = [2/3*N 1/3*N];
        end % init
        
        %% Function to set nest and feeder positions (not always required)
        % Nest = nestposition, Feeder = feederposition
        function setNestAndFeeder(Nest, Feeder)
            L.nest = Nest;
            L.feeder = Feeder;
        end
        
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
