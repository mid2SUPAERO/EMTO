function mainTop88(nelx,nely,volfrac,posttreat,problem,evalgrid)
%used to obtain compliance and time of top88 on the same grid as the one evaluating our
%method

%volfrac:   global volume fraction
%nelx:   number of elements in horizontal direction
%nely:   number of elements in vertical direction
%posttreat:   0 for no post-treatment, 
%             1 for forcing element densities to 0 or 1 while conserving
%             volume fraction
%problem:   'MBB', 'Lshape' or 'Canti'
%evalgrid :    'coarse' or 'finer' for the choice of the evaluation grid

switch problem
    case 'MBB'
    top88Tic=tic;
    [xPhys]=top88DesignMBB(nelx,nely,volfrac,3,1.5,1); %get top88 design
    top88Time=toc(top88Tic);
    case 'Canti'
    top88Tic=tic;
    [xPhys]=top88DesignCanti(nelx,nely,volfrac,3,1.5,1); %get top88 design
    top88Time=toc(top88Tic);
    case 'Lshape'
    top88Tic=tic;
    [xPhys]=top88DesignL(nelx,nely,volfrac,3,1.5,1); %get top88 design
    top88Time=toc(top88Tic);
end

%post-treat densities to 0 or 1
if posttreat==1
    volfrac=mean(mean(xPhys));
    xPhys01=xPhys;
    lowlim=0;
    highlim=1;
    difVF=1;
    while difVF>0.0001 && highlim-lowlim > 0.000001
        midlim=(lowlim+highlim)/2;
        xPhys01(xPhys>=midlim)=1;
        xPhys01(xPhys<midlim)=0;
        volfrac01=mean(mean(xPhys01));
        difVF=abs(volfrac01-volfrac);
        if volfrac01<volfrac
            highlim=midlim;
        else
            lowlim=midlim;
        end
    end
    xPhys=xPhys01;
end
figure(6)
colormap(gray); imagesc(1-xPhys); caxis([0 1]); axis equal; axis off; drawnow;

%evaluate final design
switch evalgrid
    case 'finer'
    switch problem
        case 'MBB'
        microelements=6000; 
        case 'Canti'
        microelements=4000; 
        case 'Lshape'
        microelements=2800; 
    end
    case 'coarse'
    switch problem
        case 'MBB'
        microelements=3000; 
        case 'Canti'
        microelements=2000; 
        case 'Lshape'
        microelements=1400; 
    end
end
refine=round(microelements/nelx);
xPhys=repelem(xPhys,refine,refine);%project top88 design on the same grid as the one evaluating our method
compliance=evaluateTotalDesign(xPhys,3,problem)
totalTime=top88Time






