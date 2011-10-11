%% 1. Die Grundlagen

% Nehmen wir an, wir müssten folgendes Anfangswertprobelm plotten:
% d^2x/dt^2 == sin(x^2) * exp(-dx/dt)

% Die symbolische Lösung der DLG scheint relativ schwirig zu sein, darum
% hier ein nummerischer Ansatz zur Visualisierung: Zunächst schreiben wir
% diese DGL zweiter Ordnung als System von DLGs erster Ordnung. Wir
% erhalten:

% y1 = x
% y2 = dy1/dt = dx/dt

% Daraus folgt sofort:
% dy1/dt = y2
% dy2/dt = sin(y1^2) * exp(-y2)

% Nun müssen wir nur noch festlegen, wie weit wir die Funktion betrachten
% wollen, und wie gross unsere Zeitschritte dt sein sollen:
dt = 0.01;
iter = 600;

%% 2. Die Anfangswerte

% Da wir die Lösung der obigen DGL plotten möchten erstellen wir einen
% Vektor, der die Funktionswerte enthält.

y1 = zeros(1,iter);
y2 = zeros(1,iter);

% Nun können wir die Startwerte für x(0) = y1(0) und dx/dt (0) = y2(0)
% setzten:

y1(1) = 10;
y2(1) = 0;

%% 3. Die Iterationen

for t = 2:iter
    % Hier wird die "Steigung" im nächsten Intervall berechnet
    dy1 = y2(t-1);
    dy2 = sin(y1(t-1)^2) * exp(-y2(t-1));
    
    % Nun wird ein Linearer Verlauf in dt angenommen und der nächste Wert
    % berechnet
    y1(t) = y1(t-1) + dt*dy1;
    y2(t) = y2(t-1) + dt*dy2;
    
    % Dieser Vorgang wir wiederholt, bis die gewünschten Iterationen
    % durchlaufen sind.
end

%% 4. Der Plot

% Nun einfach noch die Funktion x = y1 plotten und fertig ist das Schaubild
% der Lösung. Aber Achtung: Das Verfahren approximiert die Funktion nur. Je
% kleiner dt gewählt wird, desto genauer ist das Ergebniss, umso mehr
% Iterationen sind aber auch nötig.

plot(y1);