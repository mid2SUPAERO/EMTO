discr=32;

dbfilename=['databaseGridNoNoisetot.txt'];
dbfileID=fopen(dbfilename);
dbdata = fscanf(dbfileID,'%f %f %f %f %f %f %f %f %f',[9 inf]);

dbMat = reshape(dbdata,9,discr,discr,discr);
angleLength=size(dbMat,3);
angles=((1:angleLength)-1)/(angleLength-1);
cubLength=size(dbMat,2);
cubs=((1:cubLength)-1)/(cubLength-1);


%correct cases dens=0 or 1
lastPoint= [1.09846159394850,0.329428548373026,5.85895174775321e-08,1.09846159394851,5.85895196977880e-08,0.384544699731802];

dbMatFull=zeros(9,discr,discr,discr+2);
dbMatFull(:,:,:,2:end-1)=dbMat;
for i=1:angleLength
    dbMatFull(:,:,i,1) = [zeros(1,cubLength);angles(i)*ones(1,cubLength);cubs(:)';zeros(6,cubLength)];
    dbMatFull(:,:,i,end) = [ones(1,cubLength);angles(i)*ones(1,cubLength);cubs(:)';repmat(lastPoint(:),1,cubLength)];
end

M=dbMatFull;

%put angle in [0,pi/2] instead of [0,pi/4]
M(2,:,:,:)=M(2,:,:,:)/2;
%add symetric of each point
angleLength=size(M,3);
Msym=zeros(size(M,1),size(M,2),size(M,3)-1,size(M,4));
for i=1:size(M,4)
    for j=2:size(M,3)
        for k=1:size(M,2)
            origPoint=M(:,k,angleLength-j+1,i);
            symPoint=[origPoint(1) 1-origPoint(2) origPoint(3) origPoint(7) origPoint(5) origPoint(8) origPoint(4) origPoint(6) origPoint(9)];
            Msym(:,k,j-1,i)=symPoint(:);
        end
    end
end
%M=[M;Msym];
M=cat(3,M,Msym);

%put angle in [0,pi] instead of [0,pi/2]
M(2,:,:,:)=M(2,:,:,:)/2;
%add 90° rotation of each point
Mrot=zeros(size(M,1),size(M,2),size(M,3)-1,size(M,4));
for i=1:size(M,4)
    for j=2:size(M,3)
        for k=1:size(M,2)
            origPoint=M(:,k,j,i);
            rotPoint=[origPoint(1) 0.5+origPoint(2) origPoint(3) origPoint(7) origPoint(5) -origPoint(8) origPoint(4) -origPoint(6) origPoint(9)];
            Mrot(:,k,j-1,i)=rotPoint(:);
        end
    end
end
M=cat(3,M,Mrot);


M(3,:,:,:)=M(3,:,:,:)/2;%put principal direction in 1 - 2 instead of 1 - mixed
%add 90° rotation of each point
cubLength=size(M,2);
Mrot2=zeros(size(M,1),size(M,2)-1,size(M,3),size(M,4));
for i=1:size(M,4)
    for j=1:size(M,3)
        for k=2:size(M,2)
            origPoint=M(:,cubLength-k+1,j,i);
            rot2Point=[origPoint(1) origPoint(2) 1-origPoint(3) origPoint(7) origPoint(5) -origPoint(8) origPoint(4) -origPoint(6) origPoint(9)];
            Mrot2(:,k-1,j,i)=rot2Point(:);
        end
    end
end
M=cat(2,M,Mrot2);

dbMat=M;

save('database32-32-32.mat', 'dbMat');