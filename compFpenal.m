
penal=1:0.1:3;
c=zeros(size(penal));
for penali=penal
    xPhys=top88DesignMBB(30,10,0.5,penali,1.5,1);
	xPhys=repelem(xPhys,100,100);
    c(penali*10-9)=evaluateTotalDesign(xPhys,penali,'MBB')
end

yPT=203.8;
yNPT=234.8;
plot(penal,c,'+')
hold on
scatter(3,yNPT,'filled','r')
scatter(3,yPT,'filled','g')

xNPT=penal(9)+(penal(10)-penal(9))*(yNPT-c(9))/(c(10)-c(9));
xPT=penal(6)+(penal(7)-penal(6))*(yPT-c(6))/(c(7)-c(6));
x1=linspace(3,xNPT);
x2=linspace(3,xPT);
y1=0*x1+yNPT;
y2=0*x2+yPT;
plot(x1,y1,'--r')
plot(x2,y2,'--g')
y3=linspace(180,yNPT);
y4=linspace(180,yPT);
x3=0*y1+xNPT;
x4=0*y2+xPT;
plot(x3,y3,'--r')
plot(x4,y4,'--g')

hold off

xlabel({'penalization'},'Fontsize',14)
ylabel({'compliance'},'Fontsize',14)
legend({'top88','multiscale without post treatment','multiscale with post treatment'},'Fontsize',14)
