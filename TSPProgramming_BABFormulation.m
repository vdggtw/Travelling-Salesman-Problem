count = 0;
count2 = 0;
index1 = 1;
index2 = 0;
index3 = 0;
index4 = 0;
lb = 0;


file = 'D:\TSP_FomulationCoding\Coordinate\BAB\BAB_150.txt'; %if reading does not work, please change the address to correct address. The file is in the TSP_Fomulation\Coordinate\BAB
CoordinateOfNodes = importdata(file);
NumOfX = CoordinateOfNodes(1);
CoordinateOfNodes(1) = [];
CoordinateOfNodes = reshape(CoordinateOfNodes , 2 , NumOfX);


f = zeros(1,NumOfX * NumOfX);%The distance vector,


count = NumOfX;
for index1 = 1 : NumOfX%plot the graph and create the distance matrix by using diatance = (X^2 + Y^2)^(1/2)
    for index2 = (index1 + 1) : NumOfX
        plot([CoordinateOfNodes(1,index1) , CoordinateOfNodes(1,index2)] , [CoordinateOfNodes(2,index1) , CoordinateOfNodes(2,index2)]);
        hold on;
        f(1,(count * (index1 - 1) + index2)) = sqrt((CoordinateOfNodes(1,index1) - CoordinateOfNodes(1,index2))^2 + (CoordinateOfNodes(2,index1) - CoordinateOfNodes(2,index2))^2);
        f(1,(count * (index2 - 1) + index1)) = sqrt((CoordinateOfNodes(1,index1) - CoordinateOfNodes(1,index2))^2 + (CoordinateOfNodes(2,index1) - CoordinateOfNodes(2,index2))^2);
    end
end

problem = 0;
ErasableProblem = 0;
ObjectiveSubtour = zeros(1 , NumOfX * 2);
ObjectDistance = 0;
FinalX = zeros(NumOfX * NumOfX , 1);
CoordinateOfX = zeros(2 , NumOfX);


problem_distance = zeros(40000 , 2);
SetOfDistance = zeros(40000 , NumOfX * NumOfX);
SetOfSubtour = zeros(40000 , NumOfX * 2);


TemporaryDistance = 0;
TemporaraySubtour = zeros(1 , NumOfX * 2);
TemporarayDistanceVector = zeros(1 , NumOfX * NumOfX);
TemporarayX = zeros(NumOfX * NumOfX , 1);


LastElimination = zeros(NumOfX + 1 , 2);
LastSelect = zeros(10000 , 40000);


judge1 = 0;
judge2 = 0;
judge3 = 0;
True_False = 0;


[TemporaryDistance , TemporarayDistanceVector , TemporaraySubtour , judge1 , TemporarayX] = TSP(f , NumOfX);
problem = problem + 1;
ErasableProblem = problem;
problem_distance(problem , 1) = problem;
problem_distance(problem , 2) = TemporaryDistance;
SetOfDistance(problem,:) = TemporarayDistanceVector;
SetOfSubtour(problem,:) = TemporaraySubtour;
TemporaryDistance = 0;
TemporaraySubtour = zeros(1 , NumOfX * 2);
TemporarayDistanceVector = zeros(1 , NumOfX * NumOfX);
TemporaryLastSelect = zeros(40000 , 2);



count2 = NumOfX + 1;
count = 0;

index1 = 1;
while(judge1 == 0 && True_False == 0)
    ObjectiveSubtour = zeros(1 , NumOfX * 2);
    judge2 = 0;
    index1 = 1;
    count = 0;
    count2 = NumOfX + 1;
    while(judge2 == 0)
        if(SetOfSubtour(ErasableProblem , index1) ~= 0)
            count = count + 1;
            TemporaraySubtour(1 , count) = SetOfSubtour(ErasableProblem , index1);
            index1 = index1 + 1;
        else
            if(count < count2)
                count2 = count;
                ObjectiveSubtour = TemporaraySubtour;
                index1 = index1 + 1;
            end
            count = 0;
            if(SetOfSubtour(ErasableProblem , index1) == 0)
                judge2 = 1;
            end
            TemporaraySubtour = zeros(1 , NumOfX * 2);
        end
    end


    LastElimination = zeros(NumOfX + 1 , 2);


    if(count2 == 2)
        count2 = count2 - 1;
    end


    for index1 = 1 : count2
        problem = problem + 1;
        SetOfDistance(problem,:) = SetOfDistance(ErasableProblem,:);

        TemporaryLastSelect = zeros(40000 , 2);

        for index2 = 1 : (count2 - 1)
            X = LastElimination(index2 , 1);
            Y = LastElimination(index2 , 2);
            for index3 = 1 : NumOfX
                for index4 = 1 : NumOfX
                    if((index3 ~= X && index4 == Y) && (index3 ~= index4))
                        SetOfDistance(problem , (index3 - 1) * NumOfX + index4) = 10^8;
                    end
                    if((index3 == X && index4 ~= Y) && (index3 ~= index4))
                        SetOfDistance(problem , (index3 - 1) * NumOfX + index4) = 10^8;
                    end
                end
            end
            TemporaryLastSelect(index2 , 1) = X;
            TemporaryLastSelect(index2 , 2) = Y;
        end


        LastSelect(:,(problem * 2 - 1)) = LastSelect(:,(ErasableProblem * 2 - 1));
        LastSelect(:,(problem * 2)) = LastSelect(:,(ErasableProblem * 2));


        index2 = 1;
        while(LastSelect(index2 , (problem * 2 -1)) ~= 0)
            index2 = index2 + 1;
        end
        index3 = 1;
        while(TemporaryLastSelect(index3 , 1) ~= 0)
            LastSelect(index2 , (problem * 2 - 1)) = TemporaryLastSelect(index3 , 1);
            LastSelect(index2 , (problem * 2)) = TemporaryLastSelect(index3 , 2);
            index2 = index2 + 1;
            index3 = index3 + 1;
        end


        judge3 = 0;
        index2 = 1;
        if(ObjectiveSubtour(1 , (index1 + 1)) ~= 0)
            X = ObjectiveSubtour(1 , index1);
            Y = ObjectiveSubtour(1 , index1 + 1);
            while(LastSelect(index2 , problem * 2) ~= 0)
                if(X == LastSelect(index2 , problem * 2 - 1) && Y == LastSelect(index2 , problem * 2))
                    judge3 = 1;
                end
                index2 = index2 + 1;
            end
        else
            X = ObjectiveSubtour(1 , index1);
            Y = ObjectiveSubtour(1 , 1);
            while(LastSelect(index2 , problem * 2) ~= 0)
                if(X == LastSelect(index2 , problem * 2 - 1) && Y == LastSelect(index2 , problem * 2))
                    judge3 = 1;
                end
                index2 = index2 + 1;
            end
        end


        SetOfDistance(problem , (X - 1) * NumOfX + Y) = 10^8;
        LastElimination(index1 , 1) = X;
        LastElimination(index1 , 2) = Y;


        if(judge3 == 0)
            [TemporaryDistance , TemporarayDistanceVector , TemporaraySubtour , judge1 , TemporarayX] = TSP(SetOfDistance(problem,:) , NumOfX);
            problem_distance(problem , 1) = problem;
            problem_distance(problem , 2) = TemporaryDistance;
            SetOfDistance(problem,:) = TemporarayDistanceVector;
            SetOfSubtour(problem,:) = TemporaraySubtour;
            TemporaraySubtour = zeros(1 , NumOfX * 2);
            TemporarayDistanceVector = zeros(1 , NumOfX * NumOfX);
            True_False = True_False + judge1;
            if(True_False == 1)
                ObjectDistance = TemporaryDistance;
            end
            TemporaryDistance = 0;
        end
    end
    problem_distance(ErasableProblem , 2) = 10^13;
    index3 = 1;
    index2 = 10^12;
    while(index3 <= problem)
        if(problem_distance(index3 , 2) < index2 && problem_distance(index3 , 2) >= lb)
            index2 = problem_distance(index3 , 2);
            lb = problem_distance(index3 , 2);
            ErasableProblem = problem_distance(index3 , 1);
        end
        index3 = index3 + 1;
    end
    ObjectiveSubtour = zeros(1 , NumOfX * 2);
    FinalX = TemporarayX;
end
count = 1;
for index1 = 1 : NumOfX
    for index2 = 1 : NumOfX
        if(FinalX((index1 - 1) * NumOfX + index2 , 1) == 1)
            CoordinateOfX(1 , count) = CoordinateOfNodes(1 , index1);
            CoordinateOfX(2 , count) = CoordinateOfNodes(2 , index1);
            count = count + 1;
        end
    end
end
count = NumOfX;
for index1 = 1 : NumOfX
    if (index1 ~= NumOfX)
        figure(2);
        plot([CoordinateOfX(1 , index1) , CoordinateOfX(1 , index1 + 1)] , [CoordinateOfX(2 , index1) , CoordinateOfX(2 , index1 + 1)]);
        hold on;
    else
        figure(2);
        plot([CoordinateOfX(1 , index1) , CoordinateOfX(1 , 1)] , [CoordinateOfX(2 , index1) , CoordinateOfX(2 , 1)]);
        hold on;
    end
end






             
                








            


            




            

                
                    
                    
                        















