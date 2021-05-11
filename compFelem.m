nely=[10,13,20,25,40,50,77,100,125,200,250];
nelx=nely*3;
elem=nelx.*nely;
%compl=zeros(1,11);
compl01=zeros(1,11);

for i=1:11
    %obtain and evaluate raw top88 design
    xPhysRaw=top88DesignMBB(nelx(i),nely(i),0.5,3,1.5,1);
	xPhys=repelem(xPhysRaw,round(3000/nelx(i)),round(3000/nelx(i)));
    %compl(i)=evaluateTotalDesign(xPhys,3,'MBB')
    %obtain and evaluate top88 design with densities pushed to 0 or 1
    xPhys01=xPhysRaw;
    lowlim=0;
    highlim=1;
    difVF=1;
    while difVF>0.0001 && highlim-lowlim > 0.000001
        midlim=(lowlim+highlim)/2;
        xPhys01(xPhysRaw>=midlim)=1;
        xPhys01(xPhysRaw<midlim)=0;
        volfrac01=mean(mean(xPhys01));
        difVF=abs(volfrac01-0.5);
        if volfrac01<0.5
            highlim=midlim;
        else
            lowlim=midlim;
        end
    end
	xPhys01=repelem(xPhys01,round(3000/nelx(i)),round(3000/nelx(i)));
    compl01(i)=evaluateTotalDesign(xPhys01,3,'MBB')
end
semilogx(elem(1:11),compl01(1:11),'x')
hold on
yPT=203.8;
scatter(300,yPT,'filled','g')
xPT=elem(4)+(elem(5)-elem(4))*(yPT-compl01(4))/(compl01(5)-compl01(4));
x2=linspace(300,xPT);
y2=0*x2+yPT;
plot(x2,y2,'--g')
y4=linspace(195,yPT);
x4=0*y2+xPT;
plot(x4,y4,'--g')

hold off

xlabel({'number of elements'},'Fontsize',14)
ylabel({'compliance'},'Fontsize',14)
legend({'top88 with 0/1 filter','multiscale with post treatment'},'Fontsize',14)
elemGainPT=xPT/300