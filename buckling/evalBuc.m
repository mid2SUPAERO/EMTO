function [blf,mu,eivSort]=evalBuc(xPhys,nEig,problem,Fval,xSize,E0)
%Fval : value of applied load
%nEig : number of desired modes
Emin=10e-6*E0;
nu=0.3;
nelx=size(xPhys,2);
nely=size(xPhys,1);
Lx=xSize;    %size of part
penalK=3;
penalG=3;



Ly = nely/nelx*Lx;                                                         % recover Ly from aspect ratio
nEl = nelx*nely;                                                           % number of elements
elNrs = reshape(1:nEl,nely,nelx);                                          % element numbering
nodeNrs = int32(reshape(1:(1+nely)*(1+nelx),1+nely,1+nelx));               % node numbering (int32)
cMat = reshape(2*nodeNrs(1:end-1,1:end-1)+1,nEl,1)+int32([0,1,2*nely+[2,3,0,1],-2,-1]);% connectivity matrix
nDof = (1+nely)*(1+nelx)*2;  
U = zeros(nDof,1);
c1 = [12;3;-6;-3;-6;-3;0;3;12;3;0;-3;-6;-3;-6;12;-3;0;-3;-6;3;12;3;...
    -6;3;-6;12;3;-6;-3;12;3;0;12;-3;12];
c2 = [-4;3;-2;9;2;-3;4;-9;-4;-9;4;-3;2;9;-2;-4;-3;4;9;2;3;-4;-9;-2;...
    3;2;-4;3;-2;9;-4;-9;4;-4;-3;-4];
Ke = 1/(1-nu^2)/24*(c1+nu.*c2);                                            % lower symmetric part of Ke
[sI,sII] = deal([]);
for j = 1:8      % build assembly indices for the lower symmetric part of K
    sI = cat(2,sI,j:8);
    sII = cat(2,sII, repmat(j,1,8-j+1));
end
[iK,jK] = deal(cMat(:,sI)',cMat(:,sII)');
Iar = sort([iK(:),jK(:)],2,'descend');       
Cmat0 = [1,nu,0;nu,1,0;0,0,(1-nu)/2]/(1-nu^2);                         % non-dimensional elasticity matrix
xiG = sqrt(1/3)*[-1,1]; etaG = xiG; wxi = [1,1]; weta = wxi;           % Gauss nodes and weights
xe = [-1,-1;1,-1;1,1;-1,1].*Lx/nelx/2;                                 % dimensions of the elements
lMat = zeros(3, 4); lMat(1, 1) = 1; lMat(2, 4) = 1; lMat(3, 2:3) = 1;  % placement matrix
dN = @(xi,zi) 0.25*[zi-1,1-zi,1+zi,-1-zi; xi-1,-1-xi,1+xi,1-xi];       % shape funct. logical derivatives
B0 = @(gradN) lMat * kron(gradN,eye(2));                               % strain-displacement matrix
[indM,t2ind] = deal([1,3,5,7,16,18,20,27,29,34],[ 2,3,4,6,7,9 ]);      % auxiliary set of indices (1)
[iG,jG] = deal(iK(indM,:),jK(indM,:));                                 % indexing of unique G coefficients
IkG = sort([iG(:), jG(:)],2,'descend');                                % indexing G entries (lower half)

switch problem
    case 'MBB'
    % USER-DEFINED LOAD DOFs
    loadnid = 1; % Node IDs
    loaddof = 2*loadnid(:) ; % DOFs
    % USER-DEFINED SUPPORT FIXED DOFs
    fixednid_1 = 1:(nely+1); % Node IDs
    fixednid_2 = (nelx+1)*(nely+1); % Node IDs
    fixed = [2*fixednid_1(:)-1;2*fixednid_2(:)]; % DOFs
    % USER-DEFINED ACTIVE ELEMENTS
    activeelts=ones(nelx*nely,1);
    case 'MBBsup'
    % USER-DEFINED LOAD DOFs
    loadnid = 1; % Node IDs
    loaddof = 2*loadnid(:) ; % DOFs
    % USER-DEFINED SUPPORT FIXED DOFs
    fixednid_1 = 1:(nely+1); % Node IDs
    fixednid_2 = (1/1.05*nelx+1)*(nely+1); % Node IDs
    fixed = [2*fixednid_1(:)-1;2*fixednid_2(:)]; % DOFs
    % USER-DEFINED ACTIVE ELEMENTS
    activeelts=ones(nelx*nely,1);
end
%fixed = 1:2*(nely+1);                                                      % restrained DOFs (cantilever)
%lcDof = 2*nodeNrs(nely/2+1+[-8:8],end)-1;                                  % loaded DOFs
modF = Fval; 
F = fsparse(loaddof,1,-modF,[nDof,1]);                                       % define load vector
%[F(lcDof(1)),F(lcDof(end))] = deal(F(lcDof(1))/2,F(lcDof(end))/2);         % consistent load on end nodes

free = setdiff(1:nDof, fixed);  
sK = (Emin+xPhys.^penalK*(E0-Emin));                                     % stiffness interpolation
sK=sK(:);
sK = reshape(Ke(:)*sK',length(Ke)*nEl,1);
K = fsparse(Iar(:,1),Iar(:,2),sK,[nDof,nDof]);                           % assemble stiffness matrix
K = K+K'-diag(diag(K));                                                  % symmetrization of K
dK = decomposition(K(free,free),'chol','lower');                         % decompose K and store factor
U(free) = dK \ F(free);    
sGP = (Cmat0*B0((dN(0,0)*xe)\dN(0,0))*U(cMat)')';                        % stresses at elements centroids
Z = zeros(nEl,10);      % allocate array for compact storage of Ge coeff.
for j = 1:length(xiG)                       % loop over quadrature points
for k = 1:length(etaG)
    % ---------------------------- current integration point and weight
    xi = xiG(j); zi = etaG(k); w = wxi(j)*weta(k)*det(dN(xi,zi)*xe);
    % - reduced represenation of strain-displacement matrix (see paper)
    gradN = (dN(xi,zi)*xe)\dN(xi,zi);                                  % shape funct. physical derivatives
    a = gradN(1,:); b = gradN(2,:); B = zeros(3,10);
    l = [1,1;2,1;3,1;4,1;2,2;3,2;4,2;3,3;4,3;4,4];
    for jj = 1:10
        B(:,jj) = [a(l(jj,1))*a(l(jj,2)); ...
                   b(l(jj,1))*b(l(jj,2)); ...
                   b(l(jj,2))*a(l(jj,1))+b(l(jj,1))*a(l(jj,2))]; 
    end
    % ----------- current contribution to (unique ~= 0) elements of keG
    Z = Z+sGP*B*w;
end
end
sG0 = E0*xPhys.^penalG;                                                  % stress interpolation
sG0=sG0(:);
sG = reshape((sG0.*Z)',10*nEl,1);
G = fsparse(IkG(:,1)+1,IkG(:,2)+1,sG,[nDof,nDof])+...
     fsparse(IkG(:,1),  IkG(:,2),  sG,[nDof,nDof]);                    % assemble global G matrix
G = G+G'-diag(diag(G));                                                  % symmetrization of G
matFun = @(x) dK\(G(free,free)*x);                                       % matrix action function
[eivecs,D] = eigs(matFun,length(free),nEig+4,'sa');                      % compute eigenvalues
[mu,ii] = sort(diag(-D),'descend'); 
eivSort = eivecs(:,ii(1:nEig));                                          % sort eigenvectors accordingly
blf=1/max(mu);
end