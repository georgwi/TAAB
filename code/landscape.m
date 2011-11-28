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
        landmarks;
        plant;
        feeder;
        feeder_radius
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
            L.nest = round([2/3*N 1/3*N]);
        end % init
        
        %% set Feeder Radius for better observability;
        function setFeederRadius(L, r)
            L.feeder_radius = r;
        end
        
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
        
        %% Set Landmarks 
        function setLandmarks(Landmarks)
            L.landmarks = Landmarks;
        end
        
        % Load a map with a specified plant and feeder/nest positions
        function load_map(L, P)
            L.plant = P;	% Set plant
            L.size = length(P);
        end % load_map
        
        function load_image(L, image, type) 
            img = imread(image, type);
            img(:,:,1)
            L.size = length(img(:,:,1));
            L.plant = ~img(:,:,1);                        % use hex #ffffff
            [y, x] = find(img(:,:,2) == 153);
            L.landmarks = [x, y]
            [y, x] = find(img(:,:,2) == 238, 1, 'first'); % use hex #1100ee
            L.nest = [x, y];
            [y, x] = find(img(:,:,3) == 238, 1, 'first'); % use hex #11ee00
            L.feeder = [x, y];
            L.plant(1,:) = ones(1,L.size);
            L.plant(L.size,:) = ones(1,L.size);
            L.plant(:,1) = ones(1,L.size);
            L.plant(:,L.size) = ones(1,L.size);
        end
        
    end % methods
    methods (Static)
    end % Static functions
end % classdef
