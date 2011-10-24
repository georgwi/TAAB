% Simulation Desert Ant Behaviour

function run_simulation(map,size, nest, feed,time)
    % declare variables
    
    plot = map;
    g_vec = [0;0] % global vector of ant
    ant_pos = nest;
    ant_vec = [randi(3)-2; randi(3)-2];
    
    for t=0:time
        ant_pos = ant_pos + ant_vec
        plot(ant_pos(1), ant_pos(2)) = 5;
        imagesc(plot)
        pause(0.01);
    end
end