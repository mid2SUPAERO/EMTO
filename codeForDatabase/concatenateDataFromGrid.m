% parpool('local',24)%%%%%%%%%%%%%%%%%%%%%%%%%%
% jobnum=jojo;
% LHid=fopen('gridNoNoise.txt');
% LHpoints = fscanf(LHid,'%f %f %f',[3 inf]);
% fclose('all')
% initDes=1:42;
% parfor j=1+(jobnum-1)*1214:min(1214*jobnum,32^3)
% for j=14500:14500%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     j
%     locfilename=['point',num2str(j)];
%     locfilename2=['objpoint',num2str(j)];
%     locfilename3=['strupoint',num2str(j)];
%     locfileID=fopen(locfilename,'w');
%     locfileID2=fopen(locfilename2,'w');
%     locfileID3=fopen(locfilename3,'w');
%     obj=0;
%     Qopt=zeros(1,6);
%     Sopt=zeros(1,10000);
%     fprintf(locfileID2,'%14.10f %14.10f %14.10f ',LHpoints(1,j),LHpoints(2,j),LHpoints(3,j));
%     for i=1:size(initDes,2)
%         [Q,obji,microstruct]=unitCell8tz(100,100,LHpoints(1,j),3,2,1,LHpoints(2,j),LHpoints(3,j),initDes(i),LHpoints(1,j));
%         fprintf(locfileID2,'%14.10f ',obji);
%         if obji<obj
%             obj=obji;
%             Qopt=Q;
%             Sopt=microstruct(:)';
%         end
%     end
%     fprintf(locfileID,'%14.10f %14.10f %14.10f %14.10f %14.10f %14.10f %14.10f %14.10f %14.10f',LHpoints(1,j),LHpoints(2,j),LHpoints(3,j),Qopt(1,1),Qopt(1,2),Qopt(1,3),Qopt(2,2),Qopt(2,3),Qopt(3,3));
%     fprintf(locfileID3,'%14.10f %14.10f %14.10f ',LHpoints(1,j),LHpoints(2,j),LHpoints(3,j));
%     fprintf(locfileID3,'%14.10f ',Sopt);
% end

locfilename=['databaseGridNoNoisetot.txt'];
locfilename2=['objGridNoNoisetot.txt'];
fileID=fopen(locfilename,'w');
fileID2=fopen(locfilename2,'w');
for i=1:32^3
    %for i=1:size(LHpoints,2)
    %for i=14500:14500
    pointfilename=['point',num2str(i)];
    pointfileID=fopen(pointfilename);
    pointdata = fscanf(pointfileID,'%f %f %f %f %f %f %f %f %f',[9 inf]);
    pointobjfilename=['objpoint',num2str(i)];
    pointobjfileID=fopen(pointobjfilename);
    pointobjdata = fscanf(pointobjfileID,'%f %f %f %f %f %f %f %f %f',[45 inf]);
    fprintf(fileID,'%14.10f',pointdata')
    fprintf(fileID,'\n')
    fprintf(fileID2,'%14.10f',pointobjdata')
    fprintf(fileID2,'\n')
end
for k=1:5
    locfilename3=['struGridNoNoise',num2str(k),'.txt'];
    fileID3=fopen(locfilename3,'w');
    for i=1+6554*(k-1):min(6554*k,32^3)
    %for i=1:size(LHpoints,2)
    %for i=14500:14500
        pointstrufilename=['strupoint',num2str(i)];
        pointstrufileID=fopen(pointstrufilename);
        pointstrudata = fscanf(pointstrufileID,'%f',[10003 inf]);
        fprintf(fileID,'%14.10f',pointdata')
        fprintf(fileID,'\n')
        fprintf(fileID2,'%14.10f',pointobjdata')
        fprintf(fileID2,'\n')
        fprintf(fileID3,'%14.10f',pointstrudata')
        fprintf(fileID3,'\n')
    end
end


fclose('all');


