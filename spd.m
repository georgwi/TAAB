P = zeros(1,500500);
S = zeros(1,500500);
D = zeros(1,500500);

n = 1;
for i = 1:1000
    for j = 1:i
        P(n) = i*j;
        S(n) = i+j;
        D(n) = i-j;
        n = n+1;
    end
end

%% 1. Peter ich kenne die Antwort nicht
% uninteressant

%% 2. Simon das wusste ich schon

[w,F] = unique(P,'first');
[w,L] = unique(P,'last');

for i = 1:length(w)
    if L(i) == F(i) % Finden aller eindeutigen Produkte
        a = S(i); % Identifizieren der zugehörigen Summe
        for j = 1:length(S)
            if a == S(j) % Löschen dieser Summen
                P(j) = -1;
                S(j) = -1;
                D(j) = -1;                
            end
        end
        clc
        disp(100*i/length(w));
        disp('Prozent');
    end
end

P(P==-1)=[];
S(S==-1)=[];
D(D==-1)=[];

%% Peter kennt die Antwort

[w,F] = unique(P,'first');
[w,L] = unique(P,'last');

for i = 1:length(w)
    if L(i) ~= F(i) % Finden alle nicht eindeutigen Produkte
        a = P(i); % Identifizieren des zugehörigen Produkts
        for j = 1:length(S)
            if a == S(j) % Löschen dieser Produkte
                P(j) = -1;
                S(j) = -1;
                D(j) = -1;                
            end
        end
        clc
        disp(100*i/length(w));
        disp('Prozent');
    end
end

P(P==-1)=[];
S(S==-1)=[];
D(D==-1)=[];

%% Simon kennt die Antwort

[w,F] = unique(S,'first');
[w,L] = unique(S,'last');

for i = 1:length(w)
    if L(i) ~= F(i) % Finden aller nicht eindeutigen Summen
        a = S(i); % Identifizieren der zugehörigen Summe
        for j = 1:length(S)
            if a == S(j) % Löschen dieser Summen
                P(j) = -1;
                S(j) = -1;
                D(j) = -1;                
            end
        end
        clc
        disp(100*i/length(w));
        disp('Prozent');
    end
end

P(P==-1)=[];
S(S==-1)=[];
D(D==-1)=[];