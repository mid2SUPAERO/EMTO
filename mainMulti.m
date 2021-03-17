%used to obtain compliance and time of our method

volfrac=0.5; %global volume fraction
nelx=30; %number of cells in horizontal direction
nely=10; %number of cells in vertical direction
initialDesign="top88"; %initial guess : "volfrac" for uniform density, "top88" for mono-scale optimization
posttreat=1; %0: no post-treatment (faster); 1: posttreatment(better design)

macroTic=tic;
[cTheor,xdens,xcos,xsin,xcub]=topMulti(nelx,nely,volfrac,initialDesign); %macro-optimization
macroTime=toc(macroTic);
totdesignTic=tic;
[xPhys]=totalDesign(xdens,xcos,xsin,xcub,nelx,nely,volfrac,posttreat); %get total design
totdesignTime=toc(totdesignTic);

%print final design
figure(5)
colormap(gray); imagesc(1-xPhys); caxis([0 1]); axis equal; axis off; drawnow;

%evaluate final design     /!\ can be very long
compliance=evaluateTotalDesign(xPhys)
totalTime=macroTime+totdesignTime






