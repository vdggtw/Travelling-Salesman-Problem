index1 = 0;
index2 = 0;
count = 0;
count2 = 0;%Some index used in the code.


file = 'D:\TSP_Fomulation\Coordinate\GG\GG_8.txt';  %if reading does not work, please change the address to correct address. The file is in the TSP_Fomulation\Coordinate\GG
CoordinateOfNodes = importdata(file);
NumOfX = CoordinateOfNodes(1);
CoordinateOfNodes(1) = [];
CoordinateOfNodes = reshape(CoordinateOfNodes , 2 , NumOfX);


f = zeros(1,NumOfX * NumOfX);%The distance vector,


intcon = NumOfX * NumOfX * 2;%Number of variables.


beq = zeros((NumOfX * 3) , 1);
Aeq = zeros((NumOfX * 3) , (NumOfX * NumOfX));%The equility constrain include the input and output constrain, and the constrain that let the Xii = 0.


A = zeros((NumOfX - 1) * (NumOfX - 1) , (NumOfX * NumOfX * 2));%No inequility
b = zeros((NumOfX - 1) * (NumOfX - 1) , 1);%No inequility


lb = zeros((NumOfX * NumOfX) , 1);%lowwer bound of the Xij
ub = ones((NumOfX * NumOfX) , 1);%upper bound of the Xij : The constrain of lowwer and upper bound can let the Xij be the binary value.


CoordinateOfOptimalSolution = zeros(2 , NumOfX);%The matrix for the coordinate of optimal solution.


count = NumOfX;
for index1 = 1 : NumOfX%plot the graph and create the distance matrix by using diatance = (X^2 + Y^2)^(1/2)
    for index2 = 1 : NumOfX
        plot([CoordinateOfNodes(1,index1) , CoordinateOfNodes(1,index2)] , [CoordinateOfNodes(2,index1) , CoordinateOfNodes(2,index2)]);
        hold on;
        f(1,(count * (index1 - 1) + index2)) = sqrt((CoordinateOfNodes(1,index1) - CoordinateOfNodes(1,index2))^2 + (CoordinateOfNodes(2,index1) - CoordinateOfNodes(2,index2))^2);
    end
end
f(1 , NumOfX * NumOfX * 2) = 0;


count = 1;
for index1 = 1 : NumOfX%create the output constrain
    for index2 = 1 : NumOfX
        Aeq(index1 , count) = 1;
        count = count + 1;
    end
end
count = 1;
for index1 = 1 : NumOfX%create the input constrain
    for index2 = 1 : NumOfX
        Aeq((index1 + NumOfX) , ((index2 - 1) * NumOfX + count)) = 1;
    end
    count = count + 1;
end


for index1 = 1 : NumOfX%create the constrain that let the Xii = 0
    Aeq(index1 + 2 * NumOfX , ((index1 - 1) * NumOfX + index1)) = 1;
end


for index1 = 1 : (3 * NumOfX)%create the beq vector
    if(index1 <= (2 * NumOfX))
        beq(index1 , 1) = 1;
    end
end
Aeq((NumOfX * 3 + NumOfX - 1) , (NumOfX * NumOfX * 2)) = 0;
beq((NumOfX * 3 + NumOfX - 1) , 1) = 0;
count = NumOfX * 3;
for index1 = 2 : NumOfX
    count = count + 1;
    for index2 = 1 : NumOfX
        if(index2 ~= index1)
            Aeq(count , NumOfX * NumOfX + (index1 - 1) * NumOfX + index2) = 1;
            if(index2 ~= 1)
                Aeq(count , NumOfX * NumOfX + (index2 - 1) * NumOfX + index1) = -1;
            end
        end
    end
    beq(count , 1) = 1;
end


count = 1;
for index1 = 2 : NumOfX
    for index2 = 1 : NumOfX
        if (index1 ~= index2)
            A(count , (index1 - 1) * NumOfX + index2) = -NumOfX + 1;
            A(count , NumOfX * NumOfX + (index1 - 1) * NumOfX + index2) = 1;
            count = count + 1;
        end
    end
end
for index1 = 1 : (NumOfX * NumOfX)
    lb(NumOfX * NumOfX + index1 , 1) = 0;
    ub(NumOfX * NumOfX + index1 , 1) = NumOfX - 1;
end
X = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);
distance = f * X;%calculate the optimal diatance.

