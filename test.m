P = [ 1 2 3 1 7 7 3 5 3]
S = [ 2 1 2 2 4 2 1 2 4]


[w,F] = unique(P,'first');
[w,L] = unique(P,'last');

for i = 1:length(w)
    if L(i) == F(i) % Finden aller eindeutigen Produkte
        a = S(F(i)); % Identifizieren der zugehörigen Summe
        for j = 1:length(S)
            if a == S(j) % Löschen aller dieser Summen
                P(j) = -1;
                S(j) = -1;
                D(j) = -1;
            end
        end
    end
end

P(P==-1)=[];
S(S==-1)=[];
D(D==-1)=[];
P
S