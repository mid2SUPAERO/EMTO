function xPhys=mainMultiAddCross(nelx,nely,volfrac,initialDesign,posttreat,problem,Fval,xSize)
%used to obtain compliance and time of our method

%volfrac:   global volume fraction
%nelx:   number of cells in horizontal direction
%nely:   number of cells in vertical direction
%initialDesign:   initial guess : "volfrac" for uniform density, "top88" for mono-scale optimization
%posttreat:   0: no post-treatment (faster); 1: posttreatment(better design)
%problem:   'MBB', 'Lshape' or 'Canti'

E0=2.7e9;  %ABS
nEig=12;

macroTic=tic;
[cTheor,xdens,xcos,xsin,xcub]=topMulti(nelx,nely,volfrac,initialDesign,problem); %macro-optimization
macroTime=toc(macroTic);
totdesignTic=tic;
[xPhys]=totalDesignAddCross(xdens,xcos,xsin,xcub,nelx,nely,volfrac,posttreat,problem,Fval,xSize,E0,nEig); %get total design
%[xPhys]=totalDesignAddCross(xdens,xcos,xsin,xcub,nelx,nely,volfrac,posttreat,problem,Fval,xSize,E0,nEig); %get total design
totdesignTime=toc(totdesignTic);

%print final design
figure(6)
colormap(gray); imagesc(1-xPhys); caxis([0 1]); axis equal; axis off; drawnow;

%add lateral support for testing
supL=0.05; %support over half-beam size ratio;
nelsup=supL*size(xPhys,2);
xPhysNoSup=xPhys;
support=[zeros(size(xPhys,1)-2*nelsup,nelsup);ones(2*nelsup,nelsup)];
xPhys=[xPhys,support];
problem='MBBsup';

%print final design + support
figure(7)
colormap(gray); imagesc(1-xPhys); caxis([0 1]); axis equal; axis off; drawnow;

%evaluate final design
[blf,mu,eivSort]=evalBuc(xPhys,nEig,problem,Fval,xSize,E0);
blf
compliance=evaluateTotalDesign(xPhys,3,problem)
totalTime=macroTime+totdesignTime






