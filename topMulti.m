function [cO,xdensO,xcosO,xsinO,xcubO]=topMulti(nelx,nely,volfrac,initialDesign,problem)
% USER-DEFINED MODEL PARAMETERS
%nelx : number of cells in horizontal direction
%nely : number of cells in vertical direction
%volfrac : global volume fraction
rmin = 1.5; %filtering radius
fsum=1.0; %force value
xMin = 0; %minimum cell density
xMax = 1; %maximum cell density


global B database sig; 
sig=0.04; %gaussion kernel radius
B = func_B();
load('database32-32-32.mat'); % cell elastic tensor database
database=dbMat;



% USER-DEFINED LOOP PARAMETERS
maxloopaftermin=5; % Maximum number of iterations without a new global minimum
maxloop=100; % Maximum number of iterations
tolx = 0.001; % Terminarion criterion

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
    case 'Canti'
    % USER-DEFINED LOAD DOFs
    loadnid = nelx*(nely+1)+nely/2+1; % Node IDs
    loaddof = 2*loadnid(:) ; % DOFs
    % USER-DEFINED SUPPORT FIXED DOFs
    fixednid_1 = 1:(nely+1); % Node IDs
    fixednid_2 = fixednid_1; % Node IDs
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
freedofs = setdiff(1:ndof,fixeddof);
volfrac=volfrac*mean(activeelts);

nodenrs = reshape(1:(nely+1)*(nelx+1),nely+1,nelx+1);
edofVec = reshape(2*nodenrs(1:end-1,1:end-1)+1,nelx*nely,1);
edofMat = repmat(edofVec,1,8)+repmat([0 1 2*nely+[2 3 0 1] -2 -1],nelx*nely,1);
iK = reshape(kron(edofMat,ones(8,1))',64*nelx*nely,1);
jK = reshape(kron(edofMat,ones(1,8))',64*nelx*nely,1);

% PREPARE FILTER
iH = ones(nelx*nely*(2*(ceil(rmin)-1)+1)^2,1);
jH = ones(size(iH));
sH = zeros(size(iH));
k = 0;
for i1 = 1:nelx
  for j1 = 1:nely
    e1 = (i1-1)*nely+j1;
    for i2 = max(i1-(ceil(rmin)-1),1):min(i1+(ceil(rmin)-1),nelx)
      for j2 = max(j1-(ceil(rmin)-1),1):min(j1+(ceil(rmin)-1),nely)
        e2 = (i2-1)*nely+j2;
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


% INITIALIZE ITERATION
if initialDesign=="top88"
    switch problem
        case 'MBB'
        xdens = top88DesignMBB(nelx,nely,volfrac,2,1.2,2); xcos = repmat(1, [nely, nelx]); xsin = repmat(1, [nely, nelx]); xcub = repmat(0.5, [nely, nelx]);
        case 'Canti'
        xdens = top88DesignCanti(nelx,nely,volfrac,2,1.2,2); xcos = repmat(1, [nely, nelx]); xsin = repmat(1, [nely, nelx]); xcub = repmat(0.5, [nely, nelx]);
        case 'Lshape'
        xdens = top88DesignL(nelx,nely,volfrac/mean(activeelts),2,1.2,2); xcos = repmat(1, [nely, nelx]); xsin = repmat(1, [nely, nelx]); xcub = repmat(0.5, [nely, nelx]);
    end
elseif initialDesign=="volfrac"
    xdens = repmat(volfrac, [nely, nelx]); xcos = repmat(1, [nely, nelx]); xsin = repmat(1, [nely, nelx]); xcub = repmat(0.5, [nely, nelx]);
end
xdensPhys = xdens; xcosPhys = xcos; xsinPhys = xsin; xcubPhys = xcub;
loop = 0; change = 1; loopaftermin=0;

% INITIALIZE MMA OPTIMIZER
m = 1; n = 4*nele;
xmin = [xMin*ones(nele,1); zeros(nele,1); zeros(nele,1); zeros(nele,1)]; % Column vector with the lower bounds for the macro-variables.
xmax = [xMax*ones(nele,1); ones(nele,1); ones(nele,1); ones(nele,1)]; % Column vector with the upper bounds for the macro-variables.
xval = [xdensPhys(:); xcosPhys(:); xsinPhys(:); xcubPhys(:)]; % macro-variables
xold1 = xval(:); xold2 = xold1(:);
low = ones(n,1); upp = ones(n,1);
a0 = 1; a_mma = zeros(m,1); c_mma = 5000*ones(m,1); d_mma = zeros(m,1);

%INITIALIZE GLOBAL OPTIMUM
xdensO=zeros(nely,nelx);
xcosO=zeros(nely,nelx);
xsinO=zeros(nely,nelx);
xcubO=zeros(nely,nelx);
cO=inf;
ceO=zeros(nely,nelx);

% START ITERATION
while change > tolx && loop < maxloop && loopaftermin < maxloopaftermin
    loop = loop+1;
    loopaftermin = loopaftermin+1;
    % FE-ANALYSIS AND SENSITIVITY ANALYSIS
    [K_cell, K_dxdens_cell, K_dxcos_cell, K_dxsin_cell, K_dxcub_cell] = arrayfun(@KE_matrix, xdensPhys(:)', xcosPhys(:)', xsinPhys(:)', xcubPhys(:)', 'un', 0);
    
    KALL = reshape(cell2mat(K_cell), [8*8, nele]);
    sK = reshape(KALL, 8*8*nele, 1);
    K = sparse(iK,jK,sK); K = (K+K')/2;
    U(freedofs,:) = K(freedofs,freedofs)\F(freedofs,:);
    if max(max(abs(U)))>2000
        U=2000*U/max(max(abs(U))); % rescale U if it is too big for MMA to handle properly
    end
    % OBJECTIVE FUNCTION AND SENSITIVITY ANALYSIS
    F_nodes = cell2mat(cellfun(@(x,y)x*y, num2cell(U(edofMat),2)', K_cell,'un', 0)');
    ce = reshape(sum(F_nodes.*U(edofMat), 2), [nely, nelx]);
    c = sum(sum(ce));
    %SAVE GLOBAL OPTIMUM
    if mean(xdensPhys(:)) <= volfrac && c < cO
        xdensO=xdens;
        xcosO=xcos;
        xsinO=xsin;
        xcubO=xcub;
        cO=c;
        ceO=ce;
        loopaftermin = 0;
    end
    F_dxdens_nodes = cell2mat(cellfun(@(x,y)x*y, num2cell(U(edofMat),2)', K_dxdens_cell,'un', 0)');
    ce_dxdens = reshape(sum(F_dxdens_nodes.*U(edofMat), 2), [nely, nelx]);
    dc_xdens = -ce_dxdens;
    F_dxcos_nodes = cell2mat(cellfun(@(x,y)x*y, num2cell(U(edofMat),2)', K_dxcos_cell,'un', 0)');
    ce_dxcos = reshape(sum(F_dxcos_nodes.*U(edofMat), 2), [nely, nelx]);
    dc_xcos = -ce_dxcos;
    F_dxsin_nodes = cell2mat(cellfun(@(x,y)x*y, num2cell(U(edofMat),2)', K_dxsin_cell,'un', 0)');
    ce_dxsin = reshape(sum(F_dxsin_nodes.*U(edofMat), 2), [nely, nelx]);
    dc_xsin = -ce_dxsin;
    F_dxcub_nodes = cell2mat(cellfun(@(x,y)x*y, num2cell(U(edofMat),2)', K_dxcub_cell,'un', 0)');
    ce_dxcub = reshape(sum(F_dxcub_nodes.*U(edofMat), 2), [nely, nelx]);
    dc_xcub = -ce_dxcub;
    dv_x = ones(nely,nelx);
    % FILTERING AND MODIFICATION OF SENSITIVITIES
    dc_xdens(:) = H*(xdens(:).*dc_xdens(:))./Hs./max(1e-4,xdens(:));
    
    % MMA OPTIMIZATION METHOD
    f0val = c; df0dx = [dc_xdens(:).*activeelts; dc_xcos(:).*activeelts; dc_xsin(:).*activeelts; dc_xcub(:).*activeelts];
    fval = sum(xdensPhys(:))/(volfrac*nele) - 1;
    dfdx = [(dv_x(:).*activeelts)'/(volfrac*nele), zeros(1,nele), zeros(1,nele), zeros(1,nele)];
    [xmma,~,~,~,~,~,~,~,~,low,upp] = ...
        mmasub(m,n,loop,xval,xmin,xmax,xold1,xold2, ...
        f0val,df0dx,fval,dfdx,low,upp,a0,a_mma,c_mma,d_mma);
    xold2 = xold1; xold1 = xval; change = max(abs(xmma-xval)); xval = xmma;
    xdensnew = reshape(xval(1:nele), nely, nelx);
    xcosnew = reshape(xval(nele+1:2*nele), nely, nelx);
    xsinnew = reshape(xval(2*nele+1:3*nele), nely, nelx);
    xcubnew = reshape(xval(3*nele+1:4*nele), nely, nelx);
    % FILTERING AND MODIFICATION OF VARIABLES
    xdensnew(:) = xdensnew(:).*activeelts;
    xcosnew(:) = (H*xcosnew(:))./Hs; xcosnew(xcosnew > 1.0) = 1.0;
    xsinnew(:) = (H*xsinnew(:))./Hs; xsinnew(xsinnew > 1.0) = 1.0;
    xcubnew(:) = H*(xcubnew(:)./Hs); xcubnew(xcubnew > 1.0) = 1.0;
    xdens = xdensnew; xcos = xcosnew; xsin = xsinnew; xcub = xcubnew;
    % PRINT RESULTS
    fprintf(' It.:%5i Obj.:%11.4f Vol.:%7.3f ch.:%7.3f \n',loop,c,mean(xdensPhys(:)),change);
    xdensPhys = xdens; xcosPhys = xcos; xsinPhys = xsin; xcubPhys = xcub;
    figure(1)
    colormap(gray); imagesc(1-xdensPhys); caxis([0 1]); axis equal; axis off; drawnow;
    figure(2)
    colormap(gray); imagesc(1-xcosPhys.*reshape(activeelts,nely,nelx)); caxis([0 1]); axis equal; axis off; drawnow;
    figure(3)
    colormap(gray); imagesc(1-xsinPhys.*reshape(activeelts,nely,nelx)); caxis([0 1]); axis equal; axis off; drawnow;
    figure(4)
    colormap(gray); imagesc(1-xcubPhys.*reshape(activeelts,nely,nelx)); caxis([0 1]); axis equal; axis off; drawnow;
end
end

% GEOMETRIC MATRIX B USED IN STIFFNESS MATRIX CALCULATION
function B = func_B()
    syms s t;
    N1 = (1-s)*(1-t)/4; N2 = (1+s)*(1-t)/4;
    N3 = (1+s)*(1+t)/4; N4 = (1-s)*(1+t)/4;
    Ns = [N1, N2, N3, N4];
    Bs = sym(zeros(3,2,4));
    for i = 1:4
        Bs(:,:,i) = [[diff(Ns(i),s) 0];[0 diff(Ns(i),t)];[diff(Ns(i),t) diff(Ns(i),s)]];
    end
    B = [Bs(:,:,1),Bs(:,:,2),Bs(:,:,3),Bs(:,:,4)];
    B = matlabFunction(B);
end
% CALCULATION OF STIFFNESS MATRIX AND ITS FOUR PARTIAL DERIVATIVES
% The stiffness matrix and derivatives depends on the cell microstructure, defined by the
% macro-variables
function [KE, KE_dxdens, KE_dxcos, KE_dxsin, KE_dxcub] = KE_matrix(xdens, xcos, xsin, xcub)
    global B database sig;  
    %% get point's tensor and derivatives
    xdensd=xdens+0.01; %xdens+delta used to get the partial derivative approximation
    negdifdens=1;
    if xdensd>1 %if right partial derivative isn't accessible, get left partial derivative
        xdensd=xdensd-0.02;
        negdifdens=-1;
    end
    xcubd=xcub+0.01; %xcub+delta used to get the partial derivatives
    negdifcub=1;
    if xcubd>1 %if right partial derivative isn't accessible, get left partial derivative
        xcubd=xcubd-0.02;
        negdifcub=-1;
    end
    %derive xor from xcos and xsin. 
    cosalpha=2*xcos-1; sinalpha=2*xsin-1;
    xor=atan(sinalpha/cosalpha)/pi; %Here, xor is in [-1,1], representing an orientation angle in [-pi,pi]
    %put the orientation angle in [0,pi]
    if xor<0
        xor=xor+1;
    end 
    xord=xor+0.01; %xcor+delta used to get the partial derivatives
    negdifor=1;
    if xord>1 %if right partial derivative isn't accessible, get left partial derivative
        xord=xord-0.02;
        negdifor=-1;
    end
    %macrovariables for xi, xi', xi'' and xi'''
    xdensv=[xdens, xdensd, xdens, xdens];
    xorv=[xor, xor, xord, xor];
    xcubv=[xcub, xcub, xcub, xcubd];
    d11=[];
    d12=[];
    d13=[];
    d22=[];
    d23=[];
    d33=[];
    % GET ELASTICITY TENSORS FROM DATABASE METAMODEL FOR Xi, Xi', Xi'' and Xi'''
    for i = 1:4
        % find points in matrix within 3 kernel radii
        xdenslim1=max(1,round((xdensv(i)-3*sig)*(size(database,4)-1)+1));
        xdenslim2=min(size(database,4),round((xdensv(i)+3*sig)*(size(database,4)-1)+1));
        xorlim1=max(1,round((xorv(i)-3*sig)*(size(database,3)-1)+1));
        xorlim2=min(size(database,3),round((xorv(i)+3*sig)*(size(database,3)-1)+1));
        xcublim1=max(1,round((xcubv(i)-3*sig)*(size(database,2)-1)+1));
        xcublim2=min(size(database,2),round((xcubv(i)+3*sig)*(size(database,2)-1)+1));

        Msim=database(:,xcublim1:xcublim2,xorlim1:xorlim2,xdenslim1:xdenslim2);

        %get distance of each point
        distance=sqrt((Msim(1,:,:,:)-xdensv(i)).^2+(Msim(2,:,:,:)-xorv(i)).^2+(Msim(3,:,:,:)-xcubv(i)).^2);
        %Nadaraya-Watson kernel-weighted average
        gaussFactor = (1/((2*pi*sig^2)^(3/2)))*exp(-((distance).^2)./(2*sig^2));
        gaussFactors = repmat(gaussFactor,6,1,1,1);
        totalGauss=sum(sum(sum(gaussFactor)));
        pointGauss=sum(sum(sum(Msim(4:end,:,:,:).*gaussFactors,2), 3), 4)/totalGauss;


        d11 = [d11,pointGauss(1)];
        d12 = [d12,pointGauss(2)];
        d13 = [d13,pointGauss(3)];
        d22 = [d22,pointGauss(4)];
        d23 = [d23,pointGauss(5)];
        d33 = [d33,pointGauss(6)];
    end
    %Approximate partial derivatives
    d11ddens=negdifdens*(d11(2)-d11(1))/0.01;
    d12ddens=negdifdens*(d12(2)-d12(1))/0.01;
    d13ddens=negdifdens*(d13(2)-d13(1))/0.01;
    d22ddens=negdifdens*(d22(2)-d22(1))/0.01;
    d23ddens=negdifdens*(d23(2)-d23(1))/0.01;
    d33ddens=negdifdens*(d33(2)-d33(1))/0.01;
    
    d11dor=negdifor*(d11(3)-d11(1))/0.01;
    d12dor=negdifor*(d12(3)-d12(1))/0.01;
    d13dor=negdifor*(d13(3)-d13(1))/0.01;
    d22dor=negdifor*(d22(3)-d22(1))/0.01;
    d23dor=negdifor*(d23(3)-d23(1))/0.01;
    d33dor=negdifor*(d33(3)-d33(1))/0.01;
    
    d11dcub=negdifcub*(d11(4)-d11(1))/0.01;
    d12dcub=negdifcub*(d12(4)-d12(1))/0.01;
    d13dcub=negdifcub*(d13(4)-d13(1))/0.01;
    d22dcub=negdifcub*(d22(4)-d22(1))/0.01;
    d23dcub=negdifcub*(d23(4)-d23(1))/0.01;
    d33dcub=negdifcub*(d33(4)-d33(1))/0.01;

    D = [d11(1), d12(1), d13(1);
        d12(1), d22(1), d23(1);
        d13(1), d23(1), d33(1)];
    D_dxdens = [d11ddens, d12ddens, d13ddens;
        d12ddens, d22ddens, d23ddens;
        d13ddens, d23ddens, d33ddens];
    D_dxor = [d11dor, d12dor, d13dor;
        d12dor, d22dor, d23dor;
        d13dor, d23dor, d33dor];
    D_dxcub = [d11dcub, d12dcub, d13dcub;
        d12dcub, d22dcub, d23dcub;
        d13dcub, d23dcub, d33dcub];
    
    %DERIVE STIFFNESS MATRIX FROM ELASTICITY TENSOR
    %get gauss points weights and positions
    x = [-sqrt(3)/3, sqrt(3)/3]; % gauss point positions
    w = [1,1]; % gauss point weights
    ke = zeros(8);
    ke_dxdens = zeros(8);
    ke_dxor = zeros(8);
    ke_dxcub = zeros(8);
    [i, j] = meshgrid(1:2, 1:2);
    for m = 1:4
        ke = ke + w(i(m))*w(j(m))*B(x(i(m)), x(j(m)))' * D * B(x(i(m)), x(j(m)));
        ke_dxdens = ke_dxdens + w(i(m))*w(j(m))*B(x(i(m)), x(j(m)))' * D_dxdens * B(x(i(m)), x(j(m)));
        ke_dxor = ke_dxor + w(i(m))*w(j(m))*B(x(i(m)), x(j(m)))' * D_dxor * B(x(i(m)), x(j(m)));
        ke_dxcub = ke_dxcub + w(i(m))*w(j(m))*B(x(i(m)), x(j(m)))' * D_dxcub * B(x(i(m)), x(j(m)));
    end
    ke_dxor=ke_dxor/pi;
    ke_dxcosalpha=ke_dxor*(-sinalpha/(cosalpha^2+sinalpha^2));
    ke_dxcos=2*ke_dxcosalpha;
    ke_dxsinalpha=ke_dxor*(cosalpha/(cosalpha^2+sinalpha^2));
    ke_dxsin=2*ke_dxsinalpha;
    KE = ke; KE_dxdens = ke_dxdens; KE_dxcos = ke_dxcos; KE_dxsin = ke_dxsin; KE_dxcub = ke_dxcub;

end
