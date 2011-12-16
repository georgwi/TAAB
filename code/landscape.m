%% Landscape class
% A class for handling the landscape of a simulation


classdef landscape < handle
    properties (SetAccess = public)
        size            % Sitze of quadratic Landcape
        
        plant           % Matrix storing free and taken points
        landmarks       % Position of landmarks
        feeder          % Position of Feeder
        nest            % Position of Nest
    end
    
    methods (Access = public) 
    	%% Initialize landscape 
        function L = landscape(N)
            L.size = N;
        end
        
        %% Generate random landcape
        function generateLandscape(L, n, num, size, prob)
            L.plant = zeros(n,n);
            L.plant(1,:) = ones(1,n);
            L.plant(n,:) = ones(1,n);
            L.plant(:,1) = ones(1,n);
            L.plant(:,n) = ones(1,n);
            
            % Place random obstacles. Number of obstacles is a constant.
            posspeicher = zeros(num,1);

            for i = 1:num
                pos = n+1;
                % find a place:
                while L.plant(pos) || L.plant(pos-1) || L.plant(pos+1) || L.plant(pos-n) || L.plant(pos+n)
                    pos = randi([n+1,n*n-(n+1)]);
                end
        
                % place and save:
                posspeicher(i) = pos;
                L.plant(pos) = 1;
            end

            % Grow obstacle. If obstacle is bigger than maps boundaries, they continue growing on
            % the other side
            neigh = [-1 1 -n n];

            for i = 1:num
                dir = inf;
                for j = 1:size
                    % Grow in different direction with a certain probability:
                    if rand < prob
                        dir = inf;
                    end
                    % Choose direction to grow:
                    while posspeicher(i) + dir < 1 || posspeicher(i) + dir > n*n
                        dir = neigh(randi(4));
                    end
                    L.plant(posspeicher(i) + dir) = 1;
                    posspeicher(i) = posspeicher(i) + dir;       
                end
            end
        end
        
        %% Load a map (invoked from m-files)
        function load_map(L, P)
            L.plant = P;
            L.size = length(P);
        end % load_map
        
        %% Load a image-map
        function load_image(L, image, type) 
            img = imread(image, type);
            L.size = length(img(:,:,1));
            L.plant = ~img(:,:,1);                        % use hex #ffffff
            [y, x] = find(img(:,:,2) == 153);
            L.landmarks = [x, y];
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
end % classdef
