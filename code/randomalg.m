n = 30;

Test = zeros(n,n);
Test(1,:) = ones(1,n);
Test(n,:) = ones(1,n);
Test(:,1) = ones(1,n);
Test(:,n) = ones(1,n);

%% Random Obstacles Algorithm
% Parameters:
num = 2;        % Anzahl der Hindernisse
size = 15;      % Grösse der Hindernisse
prob = 0.1;     % Wahrscheinlichkeit für "Verwindungen" und Knicke

% 1. Zufällige Hindernisse Plazieren Anzahl der Hindernisse soll fest sein:
posspeicher = zeros(num,1);

for i = 1:num
    pos = n+1;
    % Finden eines geeigneten Ortes:
    while Test(pos) ...
            || Test(pos-1) || Test(pos+1) || Test(pos-n) || Test(pos+n)
        pos = randi([n+1,n*n-(n+1)]);
    end
    % Plazieren und speichern des Ortes für Schritt 2:
    posspeicher(i) = pos;
    Test(pos) = 1;
end


% 2. Vergrössern dieser Hindernisseauf eine bestimmte Grösse (Hindernisse
% wachsen über Ränder hinaus und auf der Anderen Spielfeldseite wieder
% hinein.
neigh = [-1 1 -n n];

for i = 1:num
    dir = inf;
    for j = 1:size
        % Manchmal wird eine Richtungsänderung zugelassen:
        if rand < prob
            dir = inf;
        end
        % Wählen einer zufälligen Richtung zum Vergrössern:
        while posspeicher(i) + dir < 1 || posspeicher(i) + dir > n*n
            dir = neigh(randi(4));
        end
        Test(posspeicher(i) + dir) = 1;
        posspeicher(i) = posspeicher(i) + dir;       
    end
end





%% End & Visualisation

imagesc(Test)
colormap([1 0 0; 0 1 0])