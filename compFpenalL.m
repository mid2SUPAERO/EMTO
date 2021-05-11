
penal=1:0.1:3;
c=zeros(size(penal));
for penali=penal
    xPhys=top88DesignL(28,28,0.5,penali,1.5,1);
	xPhys=repelem(xPhys,100,100);
    c(penali*10-9)=evaluateTotalDesign(xPhys,penali,'Lshape')
end
y01=93.6;
yPT=90.7;

figure(101)
plot(penal,c,'+')
hold on
scatter(3,y01,'filled','b')
scatter(3,yPT,'filled','g')

xPT=penal(6)+(penal(7)-penal(6))*(yPT-c(6))/(c(7)-c(6));
x2=linspace(3,xPT);
y2=0*x2+yPT;
plot(x2,y2,'--g')
y4=linspace(80,yPT);
x4=0*y2+xPT;
plot(x4,y4,'--g')

hold off

xlabel({'penalization'},'Fontsize',14)
ylabel({'compliance'},'Fontsize',14)
legend({'top88','top88 + 0/1 filter','multiscale with post treatment'},'Fontsize',14)

xPT