%% Ant class
% This class defines the behaviour/movement of an ant in a given landscape


classdef ant < handle
    properties (SetAccess = public)
        % Variables that may be set for testing:
        detection_radius = 20;          % View radius of the ant
        error_prob = 0.3;               % Error probability
        turn_prob = 0.3;                % Random turns
        
        % general variables
        position                        % Position of Ant
        global_vector                   % Global vector
        has_food                        % true or false
        nest                            % true or false
        
        % move-related Veriables
        move_direction                  % last move direction
        obstacle_vector                 % Matrix stores found obstacles
        rotation                        % Defines clockwise or counterclockwise turns
        move_radius                     % Moore neighbourhood (1st) of the ant
        local_vectors                   % stores local vectors
        updated_local_vectors           % boolean array
        last_local_vector               % stores the last landmark seen
        
        % result-storing
        step_counter                    % for counting the steps to nest or feeder
        results_food_finding            % results in steps
        results_nest_finding            % results in steps
    end
    
    methods (Access = private)
        %% Function to update local vectors (only when returning)
        function update_lv(A, landmarks)
        	for i = 1:length(landmarks)
                if norm(landmarks(i,:) - A.position) < A.detection_radius && ...
                        ~A.updated_local_vectors(i) && ...
                        ~isequal(A.last_local_vector, landmarks(end,:))
                    
                    % "growth-factor" is calculated
                    gfac = 0.5 * exp(-norm(A.local_vectors(i,:))/10);
                    
                    
                    % Local vector is adjusted
        			A.local_vectors(i,:) = round(A.local_vectors(i,:) + ...
                        gfac * (- landmarks(i,:) + A.last_local_vector));
                    
                    % Storing information about update
                    A.last_local_vector = landmarks(i,:);
                    A.updated_local_vectors(i) = true;
                end
        	end
        end
        
        %% Function to calculate a second direction from given local vectors
        function temp = calc_lv_direction(A, landmarks)
            temp = [0 0];
        	for i=1:length(landmarks)
                if norm(landmarks(i,:) - A.position) < A.detection_radius && ...
                        ~isequal(A.local_vectors(i,:), [0 0]) && ...
                        A.updated_local_vectors(i) == 0
                    
                    if isequal(A.local_vectors(i,:) + landmarks(i,:) - A.position, [0 0])
                        A.updated_local_vectors(i) = true;
                    end
                    
                    % all local vectors in the detection radius are summed up
                    temp = temp + A.local_vectors(i,:) + landmarks(i,:) - A.position;
                    
                    if isequal(temp, [0 0])
                        A.updated_local_vectors(i) = true;
                    end
                   
                end
            end
        end
    end % private methods
    
    methods (Access = public)
    	%% Initalization of ant
        function A = ant()
            A.rotation = -1;
            A.move_direction = [0 1];
            A.obstacle_vector = zeros(100,100,2);
            A.move_radius = [1 1; 1 0; 0 1; 1 -1; -1 1; -1 0; 0 -1; -1 -1];
            A.step_counter = 0;
            A.nest = 0;
            A.has_food = 0;
        end
        
        %% Create the GlobalVector from Landscape
        function createGlobalVector(A, L)
            A.global_vector =  L.nest - A.position;
        end
        
        %% Initiate the local vectors
        function createLocalVectors(A, landmarks)
            A.local_vectors = zeros(length(landmarks), 2);
            A.updated_local_vectors = zeros(length(landmarks), 1);
        end
        
        %% FindFood
        % Moves ant randomly in landscape to find the feeder
        % calculates movevector from localvectors
        function findFood(A, L)
            
            % if the feeder is found:
            if isequal(A.position, L.feeder)
                A.has_food = true;
                A.last_local_vector = L.feeder;
                
                % results are stored and the stepcounter is reset
                A.results_food_finding = [A.results_food_finding, A.step_counter];
                A.step_counter = 0;
                
                % some variables are reset or adjusted
                A.update_lv(L.landmarks)
                A.move_direction = -A.move_direction;
                A.updated_local_vectors(A.updated_local_vectors ~= 0) = 0;
                return
            end
            
            % The Step-Counter is incremented
            A.step_counter = A.step_counter + 1;
            
            % All local vectors in detection radius are considered
            dir = A.calc_lv_direction(L.landmarks);
            
            % If there is no local_vector in sight the ant moves based on
            % its previous direction with a probability to trun 45
            % degree
            if isequal(dir, [0 0])
                dir = A.move_direction;
                if rand < A.turn_prob
                    phi = pi/4;
                    n = sign(rand-0.5);
                    err_rotation = [cos(phi), n*sin(phi); -n*sin(phi), cos(phi)];
                    dir = round(dir * err_rotation);
                end
            end
            
            % If the ant can "see" the feeder all previous calcualations are
            % overwriten and the move direction points directly towards
            % the feeder.
            if norm(A.position - L.feeder) < A.detection_radius
                dir = L.feeder - A.position;
            end
            
            % move is invoked
            A.move(L, dir);
        end
        
        
        %% ReturnToNest
        % Ant returns to nest after it found food
        % The global vector is used
        function returnToNest(A, L)
            
             % if the nest is reached:
            if A.global_vector == 0
                A.nest = true;
                A.has_food = false;
                
                % results are stored and the stepcounter is reset
                A.results_nest_finding = [A.results_nest_finding, A.step_counter];
                A.step_counter = 0;
                
                % some variables are reset or adjusted
                A.updated_local_vectors(A.updated_local_vectors ~= 0) = 0;
                return
            end
            
            % The Step-Counter is incremented
            A.step_counter = A.step_counter + 1;
            
            % Local vectors are updated during the way home.
            A.update_lv(L.landmarks);
            
            % move is invoked
            A.move(L, A.global_vector);
        end
        
        %% move(A,L)
        % Moves ant in landmark, according to typical ant behaviour.
        % A: Ant
        % L: Landscape
        function move(A, L, move_vector)
            
            % All known obstacles are considered
            for i = 1:8
                move_vector(1) = move_vector(1)...
                    + A.obstacle_vector(A.position(1) + A.move_radius(i,1), A.position(2) + A.move_radius(i,2), 1);
                move_vector(2) = move_vector(2)...
                    + A.obstacle_vector(A.position(1) + A.move_radius(i,1), A.position(2) + A.move_radius(i,2), 2);
            end
            
            % if the given move_vector is zero a random move is chosen
            if isequal(move_vector, [0 0])
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
            rot = [cos(phi), A.rotation * sin(phi); -A.rotation * sin(phi), cos(phi)];
            
            % Obstacle-Avoiding: New maindirection until possible move is found!
            % 180deg-Turn-Avoiding: New maindirection if ant tries to turn around
            while L.plant(A.position(2) + temp(2), A.position(1) + temp(1)) ~= 0 ...
                    || isequal(temp, -A.move_direction)
                
                % A obstacle_vector is created and helps the ant to avoid the wall
                % and endless iterations.
                if abs(A.obstacle_vector(A.position(1) + temp(1), A.position(2) + temp(2), 1)) < 40
                    A.obstacle_vector(A.position(1) + temp(1), A.position(2) + temp(2), 1) = ...
                        A.obstacle_vector(A.position(1) + temp(1), A.position(2) + temp(2), 1) ...
                        + 8*temp(1);
                end
                if abs(A.obstacle_vector(A.position(1) + temp(1), A.position(2) + temp(2), 2)) < 40
                    A.obstacle_vector(A.position(1) + temp(1), A.position(2) + temp(2), 2) = ...
                        A.obstacle_vector(A.position(1) + temp(1), A.position(2) + temp(2), 2) ...
                        + 8*temp(2);
                end
                
                % The ant "turns" around 45deg.
                % rot is rotation matrix defined above
                temp = round(temp * rot);
            end
            
            % move direction is stored, position and global vector are
            % adjusted.
            A.move_direction = temp;
            A.position = A.position + temp;
            A.global_vector = A.global_vector - temp;
        end % move
        
    end % public methods
end
