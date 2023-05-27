NumOfX = input("Please input the number of nodes that you want to create: ");
X = randperm(NumOfX * 10 , NumOfX * 2);
coma = ",";
coordinate = zeros(NumOfX , 3);
for index1 = 1 : NumOfX
    coordinate(index1 , 1) = index1;
    coordinate(index1 , 2) = X(1 , index1);
    coordinate(index1 , 3) = X(1 , NumOfX + index1);
end
fid = fopen('MTZ_150.xlsx','w');
fprintf(fid, '%s \t ' , num2str(NumOfX));
fprintf(fid,'\r\n');  % 换行
for index1 = 1 : NumOfX
    fprintf(fid, '%s \t ' , num2str(coordinate(index1 , 1)) , ',' , num2str(coordinate(index1 , 2)) , ',' , num2str(coordinate(index1 , 3)));
    fprintf(fid,'\r\n');  % 换行
end
fid = fopen('DFJ_150.xlsx','w');
fprintf(fid, '%s \t ' , num2str(NumOfX));
fprintf(fid,'\r\n');  % 换行
for index1 = 1 : NumOfX
    fprintf(fid, '%s \t ' , num2str(coordinate(index1 , 2)) , ',' , num2str(coordinate(index1 , 3)));
    fprintf(fid,'\r\n');  % 换行
end
fid = fopen('BNB_150.xlsx','w');
fprintf(fid, '%s \t ' , num2str(NumOfX));
fprintf(fid,'\r\n');  % 换行
for index1 = 1 : NumOfX
    fprintf(fid, '%s \t ' , num2str(coordinate(index1 , 2)) , ',' , num2str(coordinate(index1 , 3)));
    fprintf(fid,'\r\n');  % 换行
end
