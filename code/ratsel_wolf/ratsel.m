l = ones(1000, 3);
k = ones(1000, 1);
p = ones(1000*1000,1);
temp = ones(1000*1000, 3);
s = ones(2000, 1);
for i=1:1000
    for j=1:1000
        t = i*j;
        temp(t,1) = temp(t,1)+1;
        temp(t,2) = i;
        temp(t,3) = j;
    end
end
for i=1:1000*1000
    if(temp(i,1) <= 3)
        % disp(i);
        % pause(0.01);
        p(i,1) = 0;
    end
end
for i=1:2000
    if(temp(i,1) <= 3)
        s(temp(i,3)+temp(i,2),1) = 0;
    end
end