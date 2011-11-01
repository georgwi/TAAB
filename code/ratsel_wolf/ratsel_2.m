arr = ones(1001*500, 6);
n = 1;
a = tic();
for i=1:1000
    for j=1:i
        arr(n, 1) = i;
        arr(n, 2) = j;
        arr(n, 3) = i * j;
        arr(n, 4) = i + j;
        arr(n ,5) = i - j;
        n = n + 1;
    end
end
toc(a)

temp = ones(1000*1000, 3);
for i=1:1000
    for j=1:1000
        t = i*j;
        temp(t,1) = temp(t,1)+1;
        temp(t,2) = i;
        temp(t,3) = j;
    end
end
l = 1001*500;
for i=1:1000
    for j=1:1000
        k = i*j;
        if(temp(k, 1) <= 3)
            s = temp(k, 2) + temp(k,3);
            n = 1;
            while n <= l
                if(arr(n, 3) == s)
                    arr(n, :) = [];
                    l = l - 1;
                end
                n = n + 1;
            end
        end
    end
end
