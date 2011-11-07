%% Initialisieren

plant = zeros(N,N);

%% Plazieren von Randhindernissen

plant(1,:) = ones(1,N);
plant(N,:) = ones(1,N);
plant(:,1) = ones(1,N);
plant(:,N) = ones(1,N);

%% Plazieren von anderen Hindernissen

pos = round([N/4 N/3 N/2 2*N/3 3*N/4]);


plant(pos(2):pos(4),pos(4)) = ones;          % senkrechte mitte
plant(pos(4),pos(2):pos(4)) = ones;          % waagerechte mitte
plant(pos(3),1:pos(2)) = ones;               % waagerechte linker Rand
plant(pos(1),pos(1):pos(3)) = ones;          % waagerechte oben links
plant(pos(4):pos(5),pos(4):pos(5)) = ones;   % Block rechts

imagesc (plant)
colormap([0 1 0; 1 0 0])