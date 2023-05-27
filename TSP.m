function[distance , f ,  OutputSubtour , True_False , X] = TSP(f , NumOfX)
index1 = 0;
index2 = 0;
count = 0;
count2 = 0;
count3 = 0;
count4 = 0;
count5 = 0;
True_False = 0;


intcon = NumOfX * NumOfX;%Number of variables.


beq = zeros((NumOfX * 3) , 1);
Aeq = zeros((NumOfX * 3) , (NumOfX * NumOfX));%The equility constrain include the input and output constrain, and the constrain that let the Xii = 0.


A = [];%No inequility
b = [];%No inequility


lb = zeros((NumOfX * NumOfX) , 1);%lowwer bound of the Xij
ub = ones((NumOfX * NumOfX) , 1);%upper bound of the Xij : The constrain of lowwer and upper bound can let the Xij be the binary value.\


CoordinateOfOptimalSolution = zeros(2 , NumOfX);%The matrix for the coordinate of optimal solution.
SubTours = zeros(1 , NumOfX);%The matrix for the subtours.
OutputSubtour = zeros(1 , 2 * NumOfX);
CoordinateOfX = zeros(2 , NumOfX);


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
X = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);
distance = f * X;%calculate the optimal diatance.



count = 1;
count2 = 0;
for index1 = 1 : NumOfX%Get the index of optimal solution
    for index2 = 1 : NumOfX
        if(X(count , 1) == 1)
            count2 = count2 + 1;
            CoordinateOfOptimalSolution(1 , count2) = index1;
            CoordinateOfOptimalSolution(2 , count2) = index2;
        end
        count = count + 1;
    end
end

count3 = 0;%It is the variable thatCheck the number of nodes that have been include in the subtours.
count4 = 0;%Count the number of subtours.
while(count3 ~= NumOfX)
    for index1 = 1 : NumOfX%Initialize the matrix of subtours every loop.
        SubTours(1 , index1) = 0;
        SubTours(2 , index1) = 0;
    end
    count = 1;

    while(CoordinateOfOptimalSolution(1 , count) == 0)%Find the first nodes of each subtours.
        count = count + 1;
    end

    SubTours(1 , 1) = CoordinateOfOptimalSolution(1 , count);%Initialise the first node of the subtour.
    SubTours(2 , 1) = CoordinateOfOptimalSolution(2 , count);
    CoordinateOfOptimalSolution(1 , count) = 0;
    CoordinateOfOptimalSolution(2 , count) = 0;
    count2 = 1;%The address of the subtours matrix.
    while(SubTours(1 , 1) ~= SubTours(2 , count2))%check if the subtour is closed
        for index1 = 1 : NumOfX
            if(CoordinateOfOptimalSolution(1 , index1) == SubTours(2 , count2))%extract each nodes of the subtour from the Coordinate matrix to the SubTours matrix.
                count2 = count2 + 1;
                SubTours(1 , count2) = CoordinateOfOptimalSolution(1 , index1);
                SubTours(2 , count2) = CoordinateOfOptimalSolution(2 , index1);
                CoordinateOfOptimalSolution(1 , index1) = 0;
                CoordinateOfOptimalSolution(2 , index1) = 0;
            end
        end
    end
    count3 = count3 + count2;
    count5 = count5 + 1;
    for index1 = 1 : count2
        count4 = count4 + 1;
        OutputSubtour(1 , count4) = SubTours(2 , index1);
    end
    count4 = count4 + 1;
end
if(count5 == 1)
    True_False = 1;
end
   
