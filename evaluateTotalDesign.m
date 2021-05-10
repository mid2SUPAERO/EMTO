function compliance=evaluateTotalDesign(xPhys,penal,problem)

nelx=size(xPhys,2);
nely=size(xPhys,1);

fsum=1.0;
%% MATERIAL PROPERTIES
E0 = 1;
Emin = 1e-9;
nu = 0.3;
%% PREPARE FINITE ELEMENT ANALYSIS
A11 = [12  3 -6 -3;  3 12  3  0; -6  3 12 -3; -3  0 -3 12];
A12 = [-6 -3  0  3; -3 -6 -3 -6;  0 -3 -6  3;  3 -6  3 -6];
B11 = [-4  3 -2  9;  3 -4 -9  4; -2 -9 -4 -3;  9  4 -3 -4];
B12 = [ 2 -3  4 -9; -3  2  9 -2;  4  9  2  3; -9 -2  3  2];
KE = 1/(1-nu^2)/24*([A11 A12;A12' A11]+nu*[B11 B12;B12' B11]);
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
freedofs = setdiff(1:ndof,fixeddof,'stable');
xPhys(:)=xPhys(:).*activeelts;

sK = reshape(KE(:)*(Emin+xPhys(:)'.^penal*(E0-Emin)),64*nelx*nely,1);
K = sparse(iK,jK,sK); K = (K+K')/2;
U(freedofs) = K(freedofs,freedofs)\F(freedofs);

ce = reshape(sum((U(edofMat)*KE).*U(edofMat),2),nely,nelx);
compliance = sum(sum((Emin+xPhys.^penal*(E0-Emin)).*ce));
end
