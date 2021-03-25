function [totalMat]=totalDesign(xdens,xcos,xsin,xcub,nelx,nely,totvolfrac,posttreat,problem)
% totvolfrac : total volume fraction
% nelx : number of cells in horizontal direction
% nely : number of cells in vertical direction
% posttreat : 1 if post treatment (better design); 0 without (faster)
microx=100; % number of elements in horizontal direction per cell
microy=100; % number of elements in vertical direction per cell

load('DBstru1.mat') % microstructure database
load('DBstru2.mat') % microstructure database
load('DBstru3.mat') % microstructure database
load('DBstru4.mat') % microstructure database
load('DBstru5.mat') % microstructure database

totalMat=zeros(nely*microy,nelx*microx);
%RETREIVE THE MICROSTRUCTURE OF EACH CELL IN THE DATABASE
for i = 1:nely
    for j = 1:nelx
        xdensel=xdens(i,j);
        xcosel=2*xcos(i,j)-1;
        xsinel=2*xsin(i,j)-1;
        xcubel=xcub(i,j);
        xorel=atan(xsinel/xcosel)/pi; %xorel=-1 =>angle=-pi;  xorel=1 =>angle=pi
        %put orientation angle in [0,pi]
        if xorel<0
            xorel=xorel+1;
        end %now xorel=0 =>angle=0; xorel=1 =>angle=pi
        
        %use symmetry to half the range of xcub
        if xcubel>0.5 
            if xorel<0.5
                xorel=xorel+0.5;
            elseif xorel>=0.5
                xorel=xorel-0.5;
            end
            xcubel=1-xcubel;
        end
        xcubel=2*xcubel;
        % now xc=0 => only principal direction 1;  xc=1=> mixed p.d.1 and p.d.2
        
        %use symmetry to half the range of xor
        anglepi=xorel;
        rot90=false;
        if anglepi>0.5 %angle>pi/2
            rot90=true;
            anglepi=anglepi-0.5; %put angle in [0,pi/2]
        end
        anglepi2=2*anglepi;
        %now anglepi2=0=>angle=0; anglepi2=1=>angle=pi/2
        
        %use symmetry again to half the range of xor
        sym45=false;
        if anglepi2>0.5 %angle>pi/4
            sym45=true;
            anglepi2=1-anglepi2; %put angle in [0,pi/4]
        end
        anglepi4=2*anglepi2;
        xorel=anglepi4;
        %now xorel=0=>angle=0; xorel=1=>angle=pi/4
        
        %take closest microstructure in the database
        idxdens=round(xdensel*33);
        idxor=round(xorel*31+1);
        idxcub=round(xcubel*31+1);
        idxtot=idxcub+(idxor-1)*32+(idxdens-1)*32*32;
        %the database is seperated into 5 matrices
        %(DBstru1,DBstru2,DBstru3,DBstru4,DBstru5) in order to be
        %downloadable on github
        n1=size(DBstru1,2);
        n2=size(DBstru2,2);
        n3=size(DBstru3,2);
        n4=size(DBstru4,2);
        n5=size(DBstru5,2);
        if idxtot<1
            localCell=zeros(100,100);
        elseif 1<=idxtot&&idxtot<=n1
            localCell=DBstru1(4:end,idxtot);
            localCell=reshape(localCell,100,100);
        elseif n1+1<=idxtot&&idxtot<=n1+n2
            localCell=DBstru2(4:end,idxtot-n1);
            localCell=reshape(localCell,100,100);            
        elseif n1+n2+1<=idxtot&&idxtot<=n1+n2+n3
            localCell=DBstru3(4:end,idxtot-(n1+n2));
            localCell=reshape(localCell,100,100);        
        elseif n1+n2+n3+1<=idxtot&&idxtot<=n1+n2+n3+n4
            localCell=DBstru4(4:end,idxtot-(n1+n2+n3));
            localCell=reshape(localCell,100,100);        
        elseif n1+n2+n3+n4+1<=idxtot&&idxtot<=n1+n2+n3+n4+n5
            localCell=DBstru5(4:end,idxtot-(n1+n2+n3+n4));
            localCell=reshape(localCell,100,100);
        elseif idxtot>32768
            localCell=ones(100,100);
        end
            
        %flip the cells in the right orientation (depending on the symetries used previously    
        if sym45
            localCell=localCell';
        end
        if rot90
            localCell=localCell';
            localCell(:,:)=localCell(:,end:-1:1);
        end
        
        %insert the cell in its place in the total design matrix
        totalMat(microy*(i-1)+1:microy*i,microx*(j-1)+1:microx*j)=localCell;
    end
end
if posttreat==1;
    totalMat=posttreatment(totalMat,nelx*microx,nely*microy,totvolfrac,problem);
end
end

function totalMat01=posttreatment(totalMat,nelxm,nelym,totvolfrac,problem)
rmin=4; %post treatment filter radius
unusedRatio=1.1; %when the stress in an element is lower than the mean stress divided by that factor, it is considered as unused.
unusedRatio2=2; %different factor used in a secound "stress filter"
unusedRatio3=20; %different factor used in a third "stress filter"
%nelxm : total number of elements in horizontal direction
%nelym : total number of elements in vertical direction

switch problem
    case 'MBB'
    % USER-DEFINED ACTIVE ELEMENTS
    activeelts=ones(nelxm*nelym,1);
    case 'Lshape'
    % USER-DEFINED ACTIVE ELEMENTS
    emptyelts=(nelxm/2)*(nelym)+1:(nelxm)*(nelym);
    emptyelts=reshape(emptyelts, nelym,nelxm/2);
    emptyelts=emptyelts(1:nelym/2,:);
    emptyelts=emptyelts(:);
    activeelts=ones(nelxm*nelym,1);
    activeelts(emptyelts)=0;
    totvolfrac=totvolfrac*3/4;
end

%%POST TREATMENT
%REMOVE "UNUSED" ELEMENTS
fprintf('Post-treatment : step 1 \n');
%group cells 4 by 4 to evaluate the stress on a coarser grid
topleftmat= totalMat(1:2:end,1:2:end);
toprightmat= totalMat(1:2:end,2:2:end);
botleftmat= totalMat(2:2:end,1:2:end);
botrightmat= totalMat(2:2:end,2:2:end);
halftotmat=(topleftmat+toprightmat+botleftmat+botrightmat)./4;

[stress]=totalFEM_S(nelxm/2,nelym/2,halftotmat,problem); % evaluate stress
stressTotMat=abs(stress).*halftotmat;
meanSTM=mean(mean(stressTotMat)); %mean stress
totalMat(repelem(stressTotMat<meanSTM/unusedRatio,2,2))=0; %eliminate "unused" elements from the total design matrix

%repeat the same process with a higher "unused" threshold 
topleftmat= totalMat(1:2:end,1:2:end);
toprightmat= totalMat(1:2:end,2:2:end);
botleftmat= totalMat(2:2:end,1:2:end);
botrightmat= totalMat(2:2:end,2:2:end);
halftotmat=(topleftmat+toprightmat+botleftmat+botrightmat)./4;  
[stress]=totalFEM_S(nelxm/2,nelym/2,halftotmat,problem);
stressTotMat2=abs(stress).*halftotmat;
meanSTM2=mean(mean(stressTotMat2));
totalMat(repelem(stressTotMat2<meanSTM2/unusedRatio2,2,2))=0;

%repeat the same process with a higher "unused" threshold 
topleftmat= totalMat(1:2:end,1:2:end);
toprightmat= totalMat(1:2:end,2:2:end);
botleftmat= totalMat(2:2:end,1:2:end);
botrightmat= totalMat(2:2:end,2:2:end);
halftotmat=(topleftmat+toprightmat+botleftmat+botrightmat)./4;  
[stress]=totalFEM_S(nelxm/2,nelym/2,halftotmat,problem);
stressTotMat3=abs(stress).*halftotmat;
meanSTM3=mean(mean(stressTotMat3));
totalMat(repelem(stressTotMat3<meanSTM3/unusedRatio3,2,2))=0;

% DENSITY FILTERING
fprintf('Post-treatment : step 2 \n');
% prepare filter
iH = ones(nelxm*nelym*(2*(ceil(rmin)-1)+1)^2,1);
jH = ones(size(iH));
sH = zeros(size(iH));
k = 0;
for i1 = 1:nelxm
  for j1 = 1:nelym
    e1 = (i1-1)*nelym+j1;
    for i2 = max(i1-(ceil(rmin)-1),1):min(i1+(ceil(rmin)-1),nelxm)
      for j2 = max(j1-(ceil(rmin)-1),1):min(j1+(ceil(rmin)-1),nelym)
        e2 = (i2-1)*nelym+j2;
        k = k+1;
        iH(k) = e1;
        jH(k) = e2;
        sH(k) = max(0,rmin-sqrt((i1-i2)^2+(j1-j2)^2));
      end
    end
  end
end
H = sparse(iH,jH,sH);
Hs = sum(H,2);

totalMatF=(H*totalMat(:))./Hs; %density filtering applied here
totalMatF(:)=totalMatF(:).*activeelts; %inactive elements are set back to 0
totalMatF=reshape(totalMatF,nelym,nelxm);

%filter densities to 0 or 1 while conserving volume fraction
fprintf('Post-treatment : step 3 \n');
totalMat01=totalMatF;
lowlim=0;
highlim=1;
difVF=1;
while difVF>0.0001 && highlim-lowlim > 0.000001
    midlim=(lowlim+highlim)/2;
    totalMat01(totalMatF>=midlim)=1;
    totalMat01(totalMatF<midlim)=0;
    volfrac=mean(mean(totalMat01));
    difVF=abs(volfrac-totvolfrac);
    if volfrac<totvolfrac
        highlim=midlim;
    else
        lowlim=midlim;
    end
end
end


function [stress]=totalFEM_S(nelx,nely,xPhys,problem)
fsum=1.0;
%% MATERIAL PROPERTIES
E0 = 1;
Emin = 1e-9;
nu = 0.3;
penal = 3;
%% PREPARE FINITE ELEMENT ANALYSIS
A11 = [12  3 -6 -3;  3 12  3  0; -6  3 12 -3; -3  0 -3 12];
A12 = [-6 -3  0  3; -3 -6 -3 -6;  0 -3 -6  3;  3 -6  3 -6];
B11 = [-4  3 -2  9;  3 -4 -9  4; -2 -9 -4 -3;  9  4 -3 -4];
B12 = [ 2 -3  4 -9; -3  2  9 -2;  4  9  2  3; -9 -2  3  2];
KE = 1/(1-nu^2)/24*([A11 A12;A12' A11]+nu*[B11 B12;B12' B11]);

D=E0/(1-nu^2)*[1 nu 0;nu 1 0; 0 0 (1-nu)/2];
B=1/2*[-1 0 1 0 1 0 -1 0;0 -1 0 -1 0 1 0 1;-1 -1 -1 1 1 1 1 -1];
DB=D*B;
Cvm=[1 -0.5 0;-0.5 1 0;0 0 3];
S=DB'*Cvm*DB;

nodenrs = reshape(1:(1+nelx)*(1+nely),1+nely,1+nelx);
edofVec = reshape(2*nodenrs(1:end-1,1:end-1)+1,nelx*nely,1);
edofMat = repmat(edofVec,1,8)+repmat([0 1 2*nely+[2 3 0 1] -2 -1],nelx*nely,1);
iK = reshape(kron(edofMat,ones(8,1))',64*nelx*nely,1);
jK = reshape(kron(edofMat,ones(1,8))',64*nelx*nely,1);


switch problem
    case 'MBB'
    % USER-DEFINED LOAD DOFs
    loadnid = 1; % Node IDs
    loaddof = 2*loadnid(:) ; % DOFs
    % USER-DEFINED SUPPORT FIXED DOFs
    fixednid_1 = 1:(nely+1); % Node IDs
    fixednid_2 = (nelx+1)*(nely+1); % Node IDs
    fixeddof = [2*fixednid_1(:)-1;2*fixednid_2(:)]; % DOFs
    % USER-DEFINED ACTIVE ELEMENTS
    activeelts=ones(nelx*nely,1);
    case 'Lshape'
    % USER-DEFINED LOAD DOFs
    loadnid = nelx*(nely+1)+nely/2+1; % Node IDs
    loaddof = 2*loadnid(:) ; % DOFs
    % USER-DEFINED SUPPORT FIXED DOFs
    fixednid_1 = 1:(nely+1):(nelx/2)*(nely+1)+1; % Node IDs
    fixednid_2 = fixednid_1; % Node IDs
    fixeddof = [2*fixednid_1(:)-1;2*fixednid_2(:)]; % DOFs
    % USER-DEFINED ACTIVE ELEMENTS
    emptyelts=(nelx/2)*(nely)+1:(nelx)*(nely);
    emptyelts=reshape(emptyelts, nely,nelx/2);
    emptyelts=emptyelts(1:nely/2,:);
    emptyelts=emptyelts(:);
    activeelts=ones(nelx*nely,1);
    activeelts(emptyelts)=0;
end
% PREPARE FINITE ELEMENT ANALYSIS
nele = nelx*nely;
ndof = 2*(nelx+1)*(nely+1);
F = sparse(loaddof,1,-fsum,ndof,1);
U = zeros(ndof,1);
freedofs = setdiff(1:ndof,fixeddof,'stable');
xPhys(:)=xPhys(:).*activeelts;

sK = reshape(KE(:)*(Emin+xPhys(:)'.^penal*(E0-Emin)),64*nelx*nely,1);
K = sparse(iK,jK,sK); K = (K+K')/2;
U(freedofs) = K(freedofs,freedofs)\F(freedofs);

stress = reshape(sqrt(sum((U(edofMat)*S).*U(edofMat),2)),nely,nelx); %microscopic Von Mises Stress
  
end

