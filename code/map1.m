%function plant = map1(n)
n = 100;
    plant = zeros(n,n);
	plant(1,:) = ones(1,n);
	plant(n,:) = ones(1,n);
	plant(:,1) = ones(1,n);
	plant(:,n) = ones(1,n);
    
    
    pos = round([n/4 n/3 n/2 2*n/3 3*n/4]);
    plant(pos(1):pos(5),pos(2)) = ones;
    plant(pos(1):pos(5),pos(4)) = ones;


imagesc(plant)
plant1 = plant;
%end