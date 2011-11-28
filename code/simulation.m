%% Simulation Class
% Handles everything simulationwise e.g. run the simulation, define simulation wide parameters
%% Variables
% * l
%	Landscape
%	defines the Landscape of the simulation
% * a TODO decide if should/could be an array or not (simulate more than one ant in a given simulation)
%	Ant
%	defines the ant of the simulation


classdef simulation < handle
    properties (SetAccess = private)
        l;
        a;
        r_ant
        r_ant_view
    end
    methods (Access = public)
    	%% Initialization
    	% Initalizes a simulation with landscape size N
    	% Ant is at the moment placed in the center of the map
        function S = simulation(N)
            if(nargin == 0)
                S.l = landscape(1);
                S.a = ant(1);
            else
                S.l = landscape(N);
                S.a = ant(N);
            end
        end
        %% Run
        % Runs simulation for specified amount of iterations
        function run(S, iterations)
            S.init_render();        
            %figure(1)
            %title('Durchlauf 1, No Food');

            while(S.a.has_food == 0)
                S.a.findFood(S.l);
               % S.render()
            end
            i = 1;
            while i <= iterations && S.a.nest ~= 1
                S.a.returnToNest(S.l)
                S.render()
            end % while ant is not at nest.
        end % run
        function init_render(S)
            figure(1)
            imagesc(S.l.plant)
            axis off, axis equal
            colormap ([0 1 0; 1 0 0; 1 0 0])
            hold on
            plot(S.l.nest(1), S.l.nest(2),'o','Color','k')
            plot(S.l.feeder(1), S.l.feeder(2), 'x', 'Color', 'k');
            
            plot(S.l.landmarks(:,1), S.l.landmarks(:,2), 'o', 'Color', 'b');
            for i=1:length(S.l.landmarks)
                line([S.l.landmarks(i,1), S.l.landmarks(i,1) + S.a.local_vectors(i,1)], [S.l.landmarks(i,2) S.l.landmarks(i,2) + S.a.local_vectors(i,1)]);
            end
            S.r_ant = plot(S.a.position(1), S.a.position(2),'.','Color','b');
            S.r_ant_view = plot(S.a.position(1) + S.a.view_radius*cos(2*pi/8*(0:8)), ...
                S.a.position(2) + S.a.view_radius*sin(2*pi/8*(0:8)), 'Color', 'k');
            hold on
        end
        %% Render
        % renders the simulation (plant & ant)
        function render(S)
            figure(1)


            %plot(S.a.position(1)-S.a.move_direction(1), S.a.position(2)-S.a.move_direction(2),...
            %    '.','Color','w')
            for i=1:length(S.l.landmarks)
                line([S.l.landmarks(i,1), S.l.landmarks(i,1) + S.a.local_vectors(i,1)], [S.l.landmarks(i,2) S.l.landmarks(i,2) + S.a.local_vectors(i,1)]);
            end
            set(S.r_ant,'XData',S.a.position(1));
            set(S.r_ant,'YData',S.a.position(2));
            set(S.r_ant_view, 'XData', S.a.position(1) + S.a.view_radius*cos(2*pi/20*(0:20)));
            set(S.r_ant_view, 'YData', S.a.position(2) + S.a.view_radius*sin(2*pi/20*(0:20)));
            
            drawnow
            % Global Vector plotten?
            % pause(0.01)
        end % render
    end
end
