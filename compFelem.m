nely=[10,13,20,25,40,50,77,100,125,200,250];
nelx=nely*3;
elem=nelx.*nely;
% compl=zeros(1,11);
% 
% for i=1:11
%     xPhys=top88DesignMBB(nelx(i),nely(i),0.5,3,1.5,1);
% 	xPhys=repelem(xPhys,round(3000/nelx(i)),round(3000/nelx(i)));
%     compl(i)=evaluateTotalDesign(xPhys,3,'MBB')
% end

semilogx(elem(1:11),compl(1:11),'+')
hold on
yPT=203.8;
yNPT=234.8;
scatter(300,yNPT,'filled','r')
scatter(300,yPT,'filled','g')
xNPT=elem(2)+(elem(3)-elem(2))*(yNPT-compl(2))/(compl(3)-compl(2));
xPT=elem(6)+(elem(7)-elem(6))*(yPT-compl(6))/(compl(7)-compl(6));
x1=linspace(300,xNPT);
x2=linspace(300,xPT);
y1=0*x1+yNPT;
y2=0*x2+yPT;
plot(x1,y1,'--r')
plot(x2,y2,'--g')
y3=linspace(190,yNPT);
y4=linspace(190,yPT);
x3=0*y1+xNPT;
x4=0*y2+xPT;
plot(x3,y3,'--r')
plot(x4,y4,'--g')

hold off

xlabel({'number of elements'},'Fontsize',14)
ylabel({'compliance'},'Fontsize',14)
legend({'top88','multiscale without post treatment','multiscale with post treatment'},'Fontsize',14)
%legend({'top88','top88 with 0/1 filter','multiscale without post treatment','multiscale with post treatment'},'Fontsize',14)
elemGainPT=xPT/300
elemGainNPT=xNPT/300