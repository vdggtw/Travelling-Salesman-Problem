%%
clear
clc
tic

file = 'D:\TSP_FomulationCoding\Coordinate\MTZ\MTZ_20.txt';%if reading does not work, please change the address to correct address. The file is in the TSP_Fomulation\Coordinate\MTZ
data = importdata(file);
n = data(1);
num_var = n*n + n;
data(1) = [];
data = reshape(data, 3, n);
for index1 = 1 : n%plot the graph and create the distance matrix by using diatance = (X^2 + Y^2)^(1/2)
    for index2 = 1 : n
        plot([data(2,index1) , data(2,index2)] , [data(3,index1) , data(3,index2)]);
        hold on;
    end
end
data = data';

for i = 1:n
    for j = i:n
        if i == j
            c(i, i) = 9999999;
        else
            c(i, j) = sqrt((data(i, 2)-data(j, 2))^2 + (data(i, 3)-data(j, 3))^2);
            c(j, i) = c(i, j);
        end
    end
end

Aeq = zeros(2*n, num_var);
beq = ones(2*n, 1);


for i = 1:n
    Aeq(i, (i-1)*n+1:i*n) = 1;
end


for i = 1:n
    Aeq(i+n, i:n:n*n) = 1;
end


A = zeros((n-1)*(n-1) - (n-1), num_var);
b = ones((n-1)*(n-1) - (n-1), 1) .* (n-1);
cnt = 0;
for i = 2:n
    for j = 2:n
        if i~= j
            cnt = cnt + 1;
            A(cnt, n*n+i) = 1;
            A(cnt, n*n+j) = -1;
            A(cnt, (i-1)*n+j) = n;
        end
    end
end


intcon = 1:n*n;
bound_lower = zeros(num_var, 1);
bound_lower(n*n+1:num_var) = -inf;
bound_upper = ones(num_var, 1);
bound_upper(n*n+1:num_var) = inf;


f = zeros(num_var, 1);
f(1:n*n) = reshape(c, n*n, 1);


options = optimoptions('intlinprog','AbsoluteGapTolerance',1e-3,...
    'MaxTime', 1000);

[x, y]=intlinprog(f,intcon, A, b, Aeq, beq, bound_lower, bound_upper);
toc
