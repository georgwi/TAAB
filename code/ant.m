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
        move_radius
        move_direction
        global_vector
        has_food
        landmarks
        nest
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
        % calculate the velocity in the given landscape
        function calc_move_direction(A, L)
            v = 2;
            A.velocity = [2 + v*randn() 2 + v*randn()];
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
            if nargin > 2 
               % A.create_moveradius(movewidth);
                A.move_radius = [1 1; 1 0; 0 1; 1 -1; -1 1; -1 0; 0 -1; -1 -1];
            else
               % A.create_moveradius(2);              
               A.move_radius = [1 1; 1 0; 0 1; 1 -1; -1 1; -1 0; 0 -1; -1 -1];
            end
            A.move_direction = [0 1];
            A.nest = 0; % True or False
            A.has_food = 0;
        end
        
        %% createGlobalVector from Landscape
        function createGlobalVector(A, L)
            A.global_vector =  L.nest - A.position;
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
                disp('found food');
                return
            end
            dir = A.move_radius(randi(length(A.move_radius)),:);
            while dir * A.move_direction' <= 0
                dir = A.move_radius(randi(length(A.move_radius)),:);
            end
            
            if norm(A.position - L.feeder) < L.feeder_radius
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
                return
            end
            
            A.move(L, A.global_vector);
            
        end
        
        %% move(A,L)
        % Moves ant in landmark, according to typical ant behaviour.
        % A: Ant
        % L: Landscape
        function move(A, L, move_vector)
            % Maindirection and seconddirection are calculated from the
            % direction given by the global veor. The seconddirection gets a
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
            
            n = 1;
            phi = pi/4;
            rot = [cos(phi), n*sin(phi); -n*sin(phi), cos(phi)];

            % Obstacle-Avoiding: New maindirection until possible move is found!
            % 180deg-Turn-Avoiding: New maindirection if ant tries to turn around
            while L.plant(A.position(2) + temp(2), A.position(1) + temp(1)) ~= 0 ...
                    || ( temp(1) == -A.move_direction(1) && temp(2) == -A.move_direction(2) )
                    %|| temp * A.move_direction' <= -1
                
                % The ant "turns" in direction of secdir. New secdir is old
                % maindirection rotated over old secdir. (mirror)
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
