%% Ant class
% This class defines the behaviour/movement of an ant in a given landscape
%% Variables
% * position 
%	1x2 int matrix
%	Position of ant in landscape
% * move_radius
%	nx2 int matrix
%	Defines "move radius" (neighbor fields for ant)
%	e.g. [-1 -1; -1 0; 0 -1; 0 1; 1 0; 1 1] ...
% * landmarks (TODO not implemented yet)
% 	nxn int matrix 
%	Defines local landmark-vectors for ant, should have the 
%	size of the landscape
% * velocity
%   Is a 1x2 vector defining the x-y-velocity of our ant

classdef ant < handle
    properties (SetAccess = public)
        position
        move_radius = [1 1; 1 0; 0 1; 1 -1; -1 1; -1 0; 0 -1; -1 -1];
        move_direction
        global_vector
        has_food
        nest
        obstacle_vector
        rotation
        view_radius = 15;
        error_prob = 0;
        step_counter = 0;
        local_vectors
        updated_local_vectors
        last_global_vector = [0 0];
        results_food_finding
        results_nest_finding
    end
    methods (Access = private)
    	% creates the move_radius matrix
        function create_moveradius(A, movewidth)
            k = 1;
            n = round(movewidth/2);
            for i=-n:n
                for j=-n:n
                    if i == 0 && j == 0
                        break
                    end
                    A.move_radius(k,1) = i;
                    A.move_radius(k,2) = j;
                    k = k + 1;
                end
            end
        end
        %% Function to update local vectors on seeable landmarks (only when returning)
        function update_lv(A, landmarks)
        	for i = 1:length(landmarks)
                if norm(landmarks(i,:) - A.position) < A.view_radius && ~A.updated_local_vectors(i)
        			A.local_vectors(i,:) = - landmarks(i,:) + A.last_global_vector;
                    A.last_global_vector = landmarks(i,:);
                    A.updated_local_vectors(i) = true;
                end
        	end
        end
        %% Function to calculate a second direction from given local vectors
        function temp = calc_lv_direction(A, landmarks)
            temp = [0 0];
        	for i=1:length(landmarks)
                if norm(landmarks(i,:) - A.position) < A.view_radius
                    temp = temp + A.local_vectors(i,:);
                end
            end
        end
    end % private methods
    methods (Access = public)
    	%% Initalization of ant
    	% x,y: starting positions
    	% movewidth: size for created generated move_radius matrix
        function A = ant(x,y,movewidth)
            if nargin == 1              
                A.position(1) = round(x/2);
                A.position(2) = round(x/2);
            elseif nargin > 1
                A.position(1) = x;
                A.position(2) = y;
            end
            A.rotation = -1;
            A.move_direction = [0 1];
            A.nest = 0; % True or False
            A.has_food = 0;
            A.obstacle_vector = zeros(100,100,2);
        end
        
        %% createGlobalVector from Landscape
        function createGlobalVector(A, L)
            A.global_vector =  L.nest - A.position;
        end
        %% init local vectors
        % only for coding & plotting convenience
        % no ant predeterminately knows all landmarks on map
        function createLocalVectors(A, landmarks)
            A.local_vectors = zeros(length(landmarks), 2);
            A.updated_local_vectors = zeros(length(landmarks), 1);
        end
        %% findFood
        % Moves ant randomly in landscape to find the feeder
        % Ant should learn landscapes and path integrate the global
        % vector 
        % return true if found food
        % return false if not
        % calculate localvectors into move vector
        function findFood(A, L)
            if A.position(1) == L.feeder(1) && A.position(2) == L.feeder(2)
                A.has_food = 1;
                A.last_global_vector = L.feeder;
                disp('found food');
                A.results_food_finding = [A.results_food_finding, A.step_counter];
                A.step_counter = 0;
                A.update_lv(L.landmarks)
                A.move_direction = -A.move_direction;
                return
            end
            A.step_counter = A.step_counter + 1;
            
            dir = A.calc_lv_direction(L.landmarks);
            
            % If there is no local_vector in sight the ant moves based on
            % its previous direction with a slight probability to trun 45
            % degree
            if dir(1) == 0 && dir(2) == 0
                dir = A.move_direction;
                if rand < 0.3
                    phi = pi/4;
                    n = sign(rand-0.5);
                    err_rotation = [cos(phi), n*sin(phi); -n*sin(phi), cos(phi)];
                    dir = round(dir * err_rotation);
                end
                
            end
            
            if norm(A.position - L.feeder) < A.view_radius
                dir = L.feeder - A.position;
            end
            
            A.move_direction = dir;
            A.move(L, dir);
            A.has_food = 0;
        end
        
        
        %% returnToNest
        % Ant returns to nest after she found food
        % Tries to go the mist direct way with global_vector
        % which points straight to the nest
        
        function returnToNest(A, L)
             % if the ant reached the nest no move is needed.
            if A.global_vector == 0
                A.nest = 1;
                
                disp('reached nest')
                A.results_nest_finding = [A.results_nest_finding, A.step_counter];
                A.step_counter = 0;
                return
            end
            A.step_counter = A.step_counter + 1;
            A.update_lv(L.landmarks);

            dir = A.global_vector;
            A.move(L, dir);
            
        end
        
        %% move(A,L)
        % Moves ant in landmark, according to typical ant behaviour.
        % A: Ant
        % L: Landscape
        function move(A, L, move_vector)
            for i = 1:8
                move_vector(1) = move_vector(1)...
                    + A.obstacle_vector(A.position(1) + A.move_radius(i,1), A.position(2) + A.move_radius(i,2), 1);
                move_vector(2) = move_vector(2)...
                    + A.obstacle_vector(A.position(1) + A.move_radius(i,1), A.position(2) + A.move_radius(i,2), 2);
            end
            while move_vector(1) == 0 && move_vector(2) == 0
                move_vector = A.move_radius(randi([1,8]));
            end
            
            % The direction of the ant is given a certain random-error:
            if rand < A.error_prob
                move_vector(1) = move_vector(1) + (rand-0.5) * move_vector(1);
                move_vector(2) = move_vector(2) + (rand-0.5) * move_vector(2);
            end

            
            % Maindirection and seconddirection are calculated from the
            % direction given by the input vecor. The seconddirection gets a
            % Probability smaller than 0.5 based on the angle between
            % maindirection and global vector.
            maindir = round(...
                move_vector/max(abs(move_vector))...
            );
            secdir = sign(...
                move_vector - maindir * min(abs(move_vector))...
            );
            secprob = min(abs(move_vector)/max(abs(move_vector)));
            
            % the following tests make sure no error is produced because of
            % limit cases.
            if secdir(1) == 0 && secdir(2) == 0
                secdir = maindir;
            end
            if secprob == 0
                secdir = maindir;
            end
            if secprob <= 0.5
                tempdir = maindir;
                maindir = secdir;
                secdir = tempdir;
                secprob = 1-secprob;
            end
            
            
            temp = maindir;
            if rand < secprob
                temp = secdir;
            end
            
            
            % If there is no obstacle near the ant the rotation-direction
            % can change.
            count = 0;
            for i = 1:8
                count = count + L.plant(A.position(2) + A.move_radius(i,2), A.position(1) + A.move_radius(i,1));
            end
            if count == 0
                A.rotation = sign(rand-0.5);
            end
            
            phi = pi/4;
            rot = [cos(phi), A.rotation*sin(phi); -A.rotation*sin(phi), cos(phi)];
            

            % Obstacle-Avoiding: New maindirection until possible move is found!
            % 180deg-Turn-Avoiding: New maindirection if ant tries to turn around
            while L.plant(A.position(2) + temp(2), A.position(1) + temp(1)) ~= 0 ...
                    || (temp(1) == -A.move_direction(1) && temp(2) == -A.move_direction(2) )
                
                % A obstacle_vector is created and helps the ant to avoid the wall
                % and endless iterations.
                if abs(A.obstacle_vector(A.position(1) + temp(1), A.position(2) + temp(2), 1)) < 60
                    A.obstacle_vector(A.position(1) + temp(1), A.position(2) + temp(2), 1) = ...
                        A.obstacle_vector(A.position(1) + temp(1), A.position(2) + temp(2), 1) ...
                        + 10*temp(1);
                end
                if abs(A.obstacle_vector(A.position(1) + temp(1), A.position(2) + temp(2), 2)) < 60
                    A.obstacle_vector(A.position(1) + temp(1), A.position(2) + temp(2), 2) = ...
                        A.obstacle_vector(A.position(1) + temp(1), A.position(2) + temp(2), 2) ...
                        + 10*temp(2);
                end
                % The ant "turns" around 45deg.
                % rot rotates
                
                temp = round(temp * rot);
            end

            A.move_direction = temp;
            A.position = A.position + temp;
            A.global_vector = A.global_vector - temp;
         
        end % move
    end % public methods
    methods (Static)

    end % static methods
end
