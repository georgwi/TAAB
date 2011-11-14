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
    properties (SetAccess = private)
        position
        move_radius
        move_direction
        global_vector
        landmarks
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
                A.create_moveradius(movewidth);
            else
                A.create_moveradius(2);
            end
        end
        %% createGlobalVector from Landscape
        function createGlobalVector(A, L) 
            A.global_vector = A.position - L.nest;
        end
        %% move(A,L)
        % Moves ant in landmark, according to typical ant behaviour.
        % A: Ant
        % L: Landscape
        function move(A, L)
            dir = A.global_vector/max(abs(A.global_vector));
            temp = A.position + round(dir);
            % Checks if ant's new position is inside Landscape and no obstacle are in the way
            if( (temp(1) > 0 && temp(2) > 0) && ...
                (temp(1) < L.size && temp(2) < L.size) && ...
                (L.plant(temp(1), temp(2)) ~= 1) )
                    A.position = temp;
                    A.global_vector = A.global_vector - temp;
            end
        end % move
    end % public methods
    methods (Static)

    end % static methods
end
