index1 = 0;
index2 = 0;
index3 = 0;
count = 0;
count2 = 0;
count3 = 0;
count4 = 0;
count5 = 0;
RowOfA = 0;%Some index used in the code.


file = 'D:\TSP_FomulationCoding\Coordinate\DFJ\DFJ_4.txt';  %if reading does not work, please change the address to correct address. The file is in the TSP_Fomulation\Coordinate\DFJ
CoordinateOfNodes = importdata(file);
NumOfX = CoordinateOfNodes(1);
CoordinateOfNodes(1) = [];
CoordinateOfNodes = reshape(CoordinateOfNodes , 2 , NumOfX);


f = zeros(1,NumOfX * NumOfX);%The distance vector,


intcon = NumOfX * NumOfX;%Number of variables.


beq = zeros((NumOfX * 3) , 1);
Aeq = zeros((NumOfX * 3) , (NumOfX * NumOfX));%The equility constrain include the input and output constrain, and the constrain that let the Xii = 0.


A = [];%No inequility
b = [];%No inequility


lb = zeros((NumOfX * NumOfX) , 1);%lowwer bound of the Xij
ub = ones((NumOfX * NumOfX) , 1);%upper bound of the Xij : The constrain of lowwer and upper bound can let the Xij be the binary value.


CoordinateOfOptimalSolution = zeros(2 , NumOfX);%The matrix for the coordinate of optimal solution.


SubTours = zeros(2 , NumOfX);%The matrix for the subtours.


SubToursConstrain = zeros(NumOfX , NumOfX);%This is the matrix for the temporary subtours constrain.


count = NumOfX;
for index1 = 1 : NumOfX%plot the graph and create the distance matrix by using diatance = (X^2 + Y^2)^(1/2)
    for index2 = 1 : NumOfX
        plot([CoordinateOfNodes(1,index1) , CoordinateOfNodes(1,index2)] , [CoordinateOfNodes(2,index1) , CoordinateOfNodes(2,index2)]);
        hold on;
        f(1,(count * (index1 - 1) + index2)) = sqrt((CoordinateOfNodes(1,index1) - CoordinateOfNodes(1,index2))^2 + (CoordinateOfNodes(2,index1) - CoordinateOfNodes(2,index2))^2);
    end
end


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
while(count4 ~= 1)
    X = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);
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
        for index1 = 1 : NumOfX%Recover the matrix of subtours every loop.
            SubTours(1 , index1) = 0;
            SubTours(2 , index1) = 0;
        end
        count = 1;

        while(CoordinateOfOptimalSolution(1 , count) == 0 )%Find the first nodes of each subtours.
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
        SubToursConstrain = zeros(NumOfX , NumOfX);
        for index1 = 1 : NumOfX
            for index2 = 1 : NumOfX
                count5 = 0;
                count = 0;
                for index3 = 1 : count2
                    if(index1 == SubTours(1 , index3))%check if the i of X is equal to one of the elements in the subtour.
                        count = 1;
                    end
                    if(index2 ~= SubTours(1 , index3))%check if the j of X is not equal to one of the element in the subtour.
                        count5 = count5 + 1;
                    end
                end
                if(count == 1 && count5 == count2)%if both two condition are ture, the Xij = 1 in the subtour constrain.
                    SubToursConstrain(index1 , index2) = -1;
                end
            end
        end
        count4 = count4 + 1;
        RowOfA = RowOfA + 1;
        count = 1;
        TemporaryA = A;
        Temporaryb = b;
        A = zeros(RowOfA , NumOfX * NumOfX);
        b = zeros(RowOfA , 1);
        for index1 = 1 : (RowOfA - 1)
            for index2 = 1 : (NumOfX *NumOfX)
                A(index1 , index2) = TemporaryA(index1 , index2);
            end
        end
        for index1 = 1 : (RowOfA - 1)
            b(index1 , 1) = Temporaryb(index1 , 1);
        end
        for index1 = 1 : NumOfX%Change the SubtoursConstrain to A.
            for index2 = 1 : NumOfX
                A(RowOfA , count) = SubToursConstrain(index1 , index2);
                count = count + 1;
            end
        end
        b(RowOfA , 1) = -1;
        count3 = count3 + count2;
    end
end
distance = f * X;%calculate the optimal diatance.











        








          
         
        







    
    

    




   



        








