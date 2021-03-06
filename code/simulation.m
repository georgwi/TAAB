%% Simulation Class
% Handles everything simulationwise e.g. run the simulation, define simulation wide parameters


classdef simulation < handle
    properties (SetAccess = private)
        l               % landscape
        a               % ant
        
        r               % true or false
        r_path          % true or false
        r_init          % true or false
        r_ant           % rendering
        r_ant_view      % rendering
        
%        aviobj = avifile('antmovie.avi','fps',30);
% enable to create a movie (1/3)
    end
    
    methods (Access = public)    
    	%% Initialization
    	% Initalizes a simulation with landscape size N
        function S = simulation(N,r,r_path)
            S.l = landscape(N);
            S.a = ant();
            S.r = r;
            S.r_path = r_path;
            S.r_init = true;
        end
              
        %% Initiates the rendering
        function init_render(S)
            S.r_init = false;
            
            figure(1)
            imagesc(S.l.plant)
            axis off, axis equal
            colormap ([0 1 0; 1 0 0; 1 0 0])
            hold on
            plot(S.l.nest(1), S.l.nest(2),'o','Color','k')
            plot(S.l.feeder(1), S.l.feeder(2), 'x', 'Color', 'k');
            
            % If landmarks exits they are plotted
            if ~isempty(S.l.landmarks)
                plot(S.l.landmarks(:,1), S.l.landmarks(:,2), 'o', 'Color', 'b');
            end
            
            % Initiates the Animation in "render"
            S.r_ant = plot(S.a.position(1), S.a.position(2),'.','Color','b');
            S.r_ant_view = plot(S.a.position(1) + S.a.detection_radius*cos(2*pi/20*(0:20)), ...
                S.a.position(2) + S.a.detection_radius*sin(2*pi/20*(0:20)), 'Color', 'k');
        end
        
        %% Reset after complete run
        function reset(S)
            S.a.has_food = 0;
            S.a.nest = 0;
            S.a.obstacle_vector = zeros(100, 100, 2);
            
            % If render is true local vectors are plotted
            if S.r
                S.render_local_vectors;
            end
        end
        
        %% The simulation
        % if render is true the ant will be plottet on the landscape
        function run(S)
            % On the first run and if render is true rendering is initiated
            if S.r_init && S.r
                S.init_render();
            end
            
            % Some variables are reset bevore a new run
            S.reset();
            
            % Ant searces for food until a.has_food is true
            while S.a.has_food == 0
                S.a.findFood(S.l);
                
                % If render is true
                if S.r 
                    S.render()
                end
            end
            
            % Ant returns to nest similar until a.nest is true
            while S.a.nest == 0
                S.a.returnToNest(S.l)
                
                % If render is true
                if S.r
                    S.render()
                end
            end

        end
        
        %% Render the simulation
        function render(S)
            figure(1)
            
            % Animation of ant and view-radius
            set(S.r_ant,'XData',S.a.position(1));
            set(S.r_ant,'YData',S.a.position(2));
            set(S.r_ant_view, 'XData', S.a.position(1) + S.a.detection_radius*cos(2*pi/20*(0:20)));
            set(S.r_ant_view, 'YData', S.a.position(2) + S.a.detection_radius*sin(2*pi/20*(0:20)));
            drawnow
            
            % If path plotting is true
            if S.r_path
                plot(S.a.position(1), S.a.position(2),'.','Color','w')
            end
            
%            F = getframe(1);
%            S.aviobj = addframe(S.aviobj,F);
% enable to create a movie (2/3)
        end
        
        %% Render local vectors
        function render_local_vectors(S)
            S.init_render();            
            for i=1:length(S.l.landmarks)
                quiver(S.l.landmarks(i,1), S.l.landmarks(i,2), S.a.local_vectors(i,1), S.a.local_vectors(i,2),'y')
            end
        end
        
    end % methods
end % classdef
