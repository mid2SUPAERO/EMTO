%% PERIODIC MATERIAL MICROSTRUCTURE DESIGN
function [tens,obj,micro,equil]=unitCell8tz(nelx,nely,density,penal,rmin,ft,angle,cubicity,initDes,transmiLim)
%density : 0 for void, 1 for full material
%angle : 0 for 0 rad, 1 for pi/4 rads
%cubicity : 0 for only one privileged direction, 1 for cubic material
%initDes : initial design : 1=all 0s; 2= all volfrac; 3= all 1; ...
%transmiLim : threshold to be considered as a transmission point
volfrac=density;
cubicity=sqrt(cubicity);
angle=angle*pi/4;

%% MATERIAL PROPERTIES
E0=1;
Emin=1e-9;
nu=0.3;
%% PREPARE FINITE ELEMENT ANALYSIS
A11 = [12 3 -6 -3; 3 12 3 0; -6 3 12 -3; -3 0 -3 12];
A12 = [-6 -3 0 3; -3 -6 -3 -6; 0 -3 -6 3; 3 -6 3 -6];
B11 = [-4 3 -2 9; 3 -4 -9 4; -2 -9 -4 -3; 9 4 -3 -4];
B12 = [2 -3 4 -9; -3 2 9 -2; 4 9 2 3; -9 -2 3 2];
KE = 1/(1-nu^2)/24*([A11 A12;A12' A11]+nu*[B11 B12;B12' B11]);
nodenrs = reshape(1:(1+nelx)*(1+nely),1+nely,1+nelx);
edofVec = reshape(2*nodenrs(1:end-1,1:end-1)+1, nelx*nely,1);
edofMat = repmat(edofVec,1,8)+repmat([0 1 2*nely+[2 3 0 1] -2 -1],nelx*nely,1);
iK = reshape(kron(edofMat,ones(8,1))',64*nelx*nely,1);
jK = reshape(kron(edofMat,ones(1,8))',64*nelx*nely,1);
%% PREPARE FILTER
iH = ones(nelx*nely*(2*(ceil(rmin)-1)+1)^2,1);
jH = ones(size(iH));
sH = zeros(size(iH));
k =0;
for i1 = 1:nelx
    for j1 = 1:nely
        e1 = (i1-1)*nely+j1;
        for i2 = max(i1-(ceil(rmin)-1),1):min(i1+(ceil(rmin)-1),nelx)
            for j2 = max(j1-(ceil(rmin)-1),1):min(j1+(ceil(rmin)-1),nely)
                e2=(i2-1)*nely+j2;
                k = k+1;
                iH(k)=e1;
                jH(k)=e2;
                sH(k) = max(0,rmin-sqrt((i1-i2)^2+(j1-j2)^2));
            end
        end
    end
end
H=sparse(iH,jH,sH);
Hs = sum(H,2);
%% PERIODIC BOUNDARY CONDITIONS
e0 = eye(3);
ufixed = zeros(8,3);
U = zeros(2*(nely+1)*(nelx+1),3);
alldofs = (1:2*(nely+1)*(nelx+1));
n1 = [nodenrs(end,[1,end]),nodenrs(1,[end,1])];
d1 = reshape([(2*n1-1);2*n1],1,8);
for j = 1:3
    ufixed(3:4,j) = [e0(1,j),e0(3,j)/2;e0(3,j)/2,e0(2,j)]*[nelx;0];
    ufixed(7:8,j) = [e0(1,j),e0(3,j)/2;e0(3,j)/2,e0(2,j)]*[0;nely];
    ufixed(5:6,j) = ufixed(3:4,j)+ufixed(7:8,j);
end
%% INITIALIZE ITERATION
qe= cell(3,3);
Q=zeros(3,3);
dQ = cell(3,3);
x=initDesMore8tz(nelx,nely,volfrac,initDes,(nelx+nely)/101);
xPhys = x;
change = 1;
loop = 0;
inLoop=1;
%%START ITERATION
while (change > 0.01 && loop <400 && inLoop==1) || inLoop==2
    xPhys=(xPhys+fliplr(flipud(xPhys)))/2; %make design central symetric
    loop = loop+1;
    %obtain side pixells used
    %middle of top side
    farthestUsedy0x1=round(nelx/2);
    xTestedy0x1=xPhys(1,farthestUsedy0x1);
    while (xTestedy0x1 > transmiLim && farthestUsedy0x1>1)
        farthestUsedy0x1=farthestUsedy0x1-1;
        xTestedy0x1=xPhys(1,farthestUsedy0x1);
    end
    farthestUsedy0x2=round(nelx/2);
    xTestedy0x2=xPhys(1,farthestUsedy0x2);
    while (xTestedy0x2 > transmiLim && farthestUsedy0x2<nelx)
        farthestUsedy0x2=farthestUsedy0x2+1;
        xTestedy0x2=xPhys(1,farthestUsedy0x2);
    end
    %middle of left side
    farthestUsedx0y1=round(nely/2);
    xTestedx0y1=xPhys(farthestUsedx0y1,1);
    while (xTestedx0y1 > transmiLim && farthestUsedx0y1>1)
        farthestUsedx0y1=farthestUsedx0y1-1;
        xTestedx0y1=xPhys(farthestUsedx0y1,1);
    end
    farthestUsedx0y2=round(nely/2);
    xTestedx0y2=xPhys(farthestUsedx0y2,1);
    while (xTestedx0y2 > transmiLim && farthestUsedx0y2<nely)
        farthestUsedx0y2=farthestUsedx0y2+1;
        xTestedx0y2=xPhys(farthestUsedx0y2,1);
    end
    
    
    %top left corner top side
    farthestUsedy0x0=1;
    xTestedy0x0=xPhys(1,farthestUsedy0x0);
    while (xTestedy0x0 > transmiLim && farthestUsedy0x0<nelx)
        farthestUsedy0x0=farthestUsedy0x0+1;
        xTestedy0x0=xPhys(1,farthestUsedy0x0);
    end    
    %top left corner left side
    farthestUsedx0y0=1;
    xTestedx0y0=xPhys(farthestUsedx0y0,1);
    while (xTestedx0y0 > transmiLim && farthestUsedx0y0<nely)
        farthestUsedx0y0=farthestUsedx0y0+1;
        xTestedx0y0=xPhys(farthestUsedx0y0,1);
    end    
    %top right corner top side
    farthestUsedy0xM=nelx;
    xTestedy0xM=xPhys(1,farthestUsedy0xM);
    while (xTestedy0xM > transmiLim && farthestUsedy0xM>1)
        farthestUsedy0xM=farthestUsedy0xM-1;
        xTestedy0xM=xPhys(1,farthestUsedy0xM);
    end    
    %bottom left corner left side
    farthestUsedx0yM=nely;
    xTestedx0yM=xPhys(farthestUsedx0yM,1);
    while (xTestedx0yM > transmiLim && farthestUsedx0yM>1)
        farthestUsedx0yM=farthestUsedx0yM-1;
        xTestedx0yM=xPhys(farthestUsedx0yM,1);
    end    
    
    %Make all transmission lengths equal
    lengthtop0=farthestUsedy0x0;
    lengthtopM=nelx-farthestUsedy0xM+1;
    lengthtop1=round(nelx/2)-farthestUsedy0x1+1;
    lengthtop2=farthestUsedy0x2-round(nelx/2);
    lengthtop=max(1,min([lengthtop0, lengthtop1, lengthtop2, lengthtopM]));
    farthestUsedy0x0=round(lengthtop);
    farthestUsedy0x1=round(nelx/2)-round(lengthtop)+1;
    farthestUsedy0x2=round(lengthtop)+round(nelx/2);
    farthestUsedy0xM=nelx-round(lengthtop)+1;
    
    
    lengthleft0=farthestUsedx0y0;
    lengthleftM=nely-farthestUsedx0yM+1;
    lengthleft1=round(nely/2)-farthestUsedx0y1+1;
    lengthleft2=farthestUsedx0y2-round(nely/2);
    lengthleft=max(1,min([lengthleft0,lengthleft1,lengthleft2,lengthleftM]));
    farthestUsedx0y0=round(lengthleft);
    farthestUsedx0y1=round(nely/2)-round(lengthleft)+1;
    farthestUsedx0y2=round(lengthleft)+round(nely/2);
    farthestUsedx0yM=nely-round(lengthleft)+1;
    
    %make sure no double count
    if (farthestUsedx0y0 >= farthestUsedx0y1)
        farthestUsedx0y0=round(nely/4);
        farthestUsedx0y1=round(nely/4)+1;
    end
    if (farthestUsedx0y1 >= farthestUsedx0y2)
        farthestUsedx0y1=round(nely/2);
        farthestUsedx0y2=round(nely/2)+1;
    end
    if (farthestUsedx0y2 >= farthestUsedx0yM)
        farthestUsedx0y2=round(3*nely/4);
        farthestUsedx0yM=round(3*nely/4)+1;
    end
    if (farthestUsedy0x0 >= farthestUsedy0x1)
        farthestUsedy0x0=round(nelx/4);
        farthestUsedy0x1=round(nelx/4)+1;
    end
    if (farthestUsedy0x1 >= farthestUsedy0x2)
        farthestUsedy0x1=round(nelx/2);
        farthestUsedy0x2=round(nelx/2)+1;
    end
    if (farthestUsedy0x2 >= farthestUsedy0xM)
        farthestUsedy0x2=round(3*nelx/4);
        farthestUsedy0xM=round(3*nelx/4)+1;
    end
    
    %moved n, d and wfixed here, to adapt to size of used side of cell

    %n3 = [nodenrs(2:farthestUsedx0y0,1)',nodenrs(farthestUsedx0y1+1:farthestUsedx0y2+1,1)',nodenrs(farthestUsedx0y3+1:farthestUsedx0y4+1,1)',nodenrs(farthestUsedx0yM+1:nely,1)',nodenrs(end,2:farthestUsedy0x0),nodenrs(end,farthestUsedy0x1+1:farthestUsedy0x2+1),nodenrs(end,farthestUsedy0x3+1:farthestUsedy0x4+1),nodenrs(end,farthestUsedy0xM+1:nelx)];
    n3 = [nodenrs(2:farthestUsedx0y0,1)',nodenrs(farthestUsedx0y1:farthestUsedx0y2,1)',nodenrs(farthestUsedx0yM:nely-1,1)',nodenrs(end,2:farthestUsedy0x0),nodenrs(end,farthestUsedy0x1:farthestUsedy0x2),nodenrs(end,farthestUsedy0xM:nelx-1)];
    d3 = reshape([(2*n3-1);2*n3],1,2*size(n3,2));
    n4 = [nodenrs(2:farthestUsedx0y0,end)',nodenrs(farthestUsedx0y1:farthestUsedx0y2,end)',nodenrs(farthestUsedx0yM:nely-1,end)',nodenrs(1,2:farthestUsedy0x0),nodenrs(1,farthestUsedy0x1:farthestUsedy0x2),nodenrs(1,farthestUsedy0xM:nelx-1)];
    d4 = reshape([(2*n4-1);2*n4],1,2*size(n4,2));
    d2 = setdiff(alldofs,[d1,d3,d4]);
    %wfixed = [repmat(ufixed(3:4,:),farthestUsedx0y0-1+2+farthestUsedx0y2-farthestUsedx0y1+farthestUsedx0y4-farthestUsedx0y3+nely-farthestUsedx0yM,1); repmat(ufixed(7:8,:),farthestUsedy0x0-1+2+farthestUsedy0x2-farthestUsedy0x1+farthestUsedy0x4-farthestUsedy0x3+nelx-farthestUsedy0xM,1)];
    wfixed = [repmat(ufixed(3:4,:),farthestUsedx0y0-1+1+farthestUsedx0y2-farthestUsedx0y1+nely-farthestUsedx0yM,1); repmat(ufixed(7:8,:),farthestUsedy0x0-1+1+farthestUsedy0x2-farthestUsedy0x1+nelx-farthestUsedy0xM,1)];
    
    %Used to check if transmission zones are used "equally"
    if inLoop==2
        n3ext=[nodenrs(2:round(nely/4),1)',nodenrs(round(3*nely/4):nely-1,1)',nodenrs(end,2:round(nelx/4)),nodenrs(end,round(3*nelx/4):nelx-1)];
        n3int=[nodenrs(round(nely/4):round(3*nely/4),1)',nodenrs(end,round(nelx/4):round(3*nelx/4))];
        d3ext=reshape([(2*n3ext-1);2*n3ext],1,2*size(n3ext,2));
        d3int=reshape([(2*n3int-1);2*n3int],1,2*size(n3int,2));
        n4ext=[nodenrs(2:round(nely/4),end)',nodenrs(round(3*nely/4):nely-1,end)',nodenrs(1,2:round(nelx/4)),nodenrs(1,round(3*nelx/4):nelx-1)];
        n4int=[nodenrs(round(nely/4):round(3*nely/4),end)',nodenrs(1,round(nelx/4):round(3*nelx/4))];
        d4ext=reshape([(2*n4ext-1);2*n4ext],1,2*size(n4ext,2));
        d4int=reshape([(2*n4int-1);2*n4int],1,2*size(n4int,2));
        d2ext = setdiff(alldofs,[d1,d3ext,d4ext]);
        d2int = setdiff(alldofs,[d1,d3int,d4int]);
        wfixedext=[repmat(ufixed(3:4,:),round(nely/4)-1+nely-round(3*nely/4),1); repmat(ufixed(7:8,:),round(nelx/4)-1+nelx-round(3*nelx/4),1)];
        wfixedint=[repmat(ufixed(3:4,:),round(3*nely/4)-round(nely/4)+1,1); repmat(ufixed(7:8,:),round(3*nelx/4)-round(nelx/4)+1,1)];
    end
    
    %% FE-ANALYSIS
    sK = reshape(KE(:)*(Emin+xPhys(:)'.^penal*(E0-Emin)),64*nelx*nely,1);
    K = sparse(iK,jK,sK); K = (K+K')/2;
    Kr = [K(d2,d2), K(d2,d3)+K(d2,d4);K(d3,d2)+K(d4,d2), K(d3,d3)+K(d3,d4)+K(d4,d3)+K(d4,d4)];
    U(d1,:) = ufixed;
    U([d2,d3],:) = Kr\(-[K(d2,d1);K(d3,d1)+K(d4,d1)]*ufixed-[K(d2,d4); K(d3,d4)+K(d4,d4)]*wfixed);
    U(d4,:) = U(d3,:)+wfixed;
    
    if inLoop==2
        Krext = [K(d2ext,d2ext), K(d2ext,d3ext)+K(d2ext,d4ext);K(d3ext,d2ext)+K(d4ext,d2ext), K(d3ext,d3ext)+K(d3ext,d4ext)+K(d4ext,d3ext)+K(d4ext,d4ext)];
        Krint = [K(d2int,d2int), K(d2int,d3int)+K(d2int,d4int);K(d3int,d2int)+K(d4int,d2int), K(d3int,d3int)+K(d3int,d4int)+K(d4int,d3int)+K(d4int,d4int)];
        Uext=U;
        Uint=U;
        Uext([d2ext,d3ext],:) = Krext\(-[K(d2ext,d1);K(d3ext,d1)+K(d4ext,d1)]*ufixed-[K(d2ext,d4ext); K(d3ext,d4ext)+K(d4ext,d4ext)]*wfixedext);
        Uint([d2int,d3int],:) = Krint\(-[K(d2int,d1);K(d3int,d1)+K(d4int,d1)]*ufixed-[K(d2int,d4int); K(d3int,d4int)+K(d4int,d4int)]*wfixedint);
        Uext(d4ext,:) = Uext(d3ext,:)+wfixedext;
        Uint(d4int,:) = Uint(d3int,:)+wfixedint;
        %%OBJECTIVE FUNCTION AND SENSITIVITY ANALYSIS
        for i = 1:3
            for j = 1:3
                U1ext = Uext(:,i); U2ext = Uext(:,j);
                U1int = Uint(:,i); U2int = Uint(:,j);
                qeext{i,j} = reshape(sum((U1ext(edofMat)*KE).*U2ext(edofMat),2),nely,nelx)/(nelx*nely);
                qeint{i,j} = reshape(sum((U1int(edofMat)*KE).*U2int(edofMat),2),nely,nelx)/(nelx*nely);
                Qext(i,j) = sum(sum((Emin+xPhys.^penal*(E0-Emin)).*qeext{i,j}));
                Qint(i,j) = sum(sum((Emin+xPhys.^penal*(E0-Emin)).*qeint{i,j}));
            end
        end
        Q2ext=rotateTensorMatrix(Qext,angle);
        Q2int=rotateTensorMatrix(Qint,angle);
        cext = -(1-0.5*cubicity)*Q2ext(1,1)-0.5*cubicity*Q2ext(2,2);
        cint = -(1-0.5*cubicity)*Q2int(1,1)-0.5*cubicity*Q2int(2,2);
        diffC=cext-cint;
    end
    
    %%OBJECTIVE FUNCTION AND SENSITIVITY ANALYSIS
    for i = 1:3
        for j = 1:3
            U1 = U(:,i); U2 = U(:,j);
            qe{i,j} = reshape(sum((U1(edofMat)*KE).*U2(edofMat),2),nely,nelx)/(nelx*nely);
            Q(i,j) = sum(sum((Emin+xPhys.^penal*(E0-Emin)).*qe{i,j}));
            dQ{i,j} = penal*(E0-Emin)*xPhys.^(penal-1).*qe{i,j};
        end
    end
    Q2=rotateTensorMatrix(Q,angle);
    c = -(1-0.5*cubicity)*Q2(1,1)-0.5*cubicity*Q2(2,2);
    dQ2=rotateTensorCells(dQ,angle);
    dc = -(1-0.5*cubicity)*dQ2{1,1}-0.5*cubicity*dQ2{2,2};
    dv = ones(nely,nelx);
    %% FILTERING/MODIFICATION OF SENSITIVITIES
    if ft==1
        dc(:) = H*(x(:).*dc(:))./Hs./max(1e-3,x(:));
    elseif ft == 2
        dc(:) = H*(dc(:)./Hs);
        dv(:) = H*(dv(:)./Hs);
    end
    %% OPTIMALITY CRITERIA UPDATE OF DESIGN VARIABLES AND PHYSICAL DENSITIES
    l1 = 0; l2 = 1e9; move = 0.2;
    while(l2-l1 > 1e-9)
        lmid = 0.5*(l2+l1);
        xnew = max(0,max(x-move,min(1,min(x+move,x.*sqrt(max(0,-dc./dv/lmid))))));
        if ~isreal(xnew)
            debug=1
        end
        if ft ==1
            xPhys = xnew;
        elseif ft == 2
            xPhys(:) = (H*xnew(:))./Hs;
        end
        if mean(xPhys(:)) > volfrac, l1 = lmid; else l2 = lmid; end
    end
    if ~isreal(xPhys)
        debug=1
    end
    change = max(abs(xnew(:)-x(:)));
    x = xnew;
    
    if inLoop==2
        inLoop=0;
        obj=c;
        tens=Q;
        equil=abs(diffC)/c;
    elseif (change <= 0.01 || loop >=400) && inLoop==1
        inLoop=2;
        micro=xPhys;
    end
    
    %% PRINT RESULTS
    %fprintf(' It.:%5i Obj.:%11.4f Vol.:%7.3f ch.:%7.3f\n',loop,c, mean(xPhys(:)),change);
end
