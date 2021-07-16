%rotate a 3x3 cells representing a 4th order 2*2*2*2 elastic tensor
%derivatives
function B=rotateTensorCells(A,theta)
B = cell(3,3);
s=sin(theta);
c=cos(theta);
Mrot=[[c -s];[s c]];

tensA=cell(2,2,2,2);
tensA(1,1,:,:)={A{1,1},A{1,3};A{1,3},A{1,2}};
tensA(1,2,:,:)={A{3,1},A{3,3};A{3,3},A{3,2}};
tensA(2,1,:,:)={A{3,1},A{3,3};A{3,3},A{3,2}};
tensA(2,2,:,:)={A{2,1},A{2,3};A{2,3},A{2,2}};

tensB=cell(2,2,2,2);
for i=1:2
    for j=1:2
        for k=1:2
            for h=1:2
                tensB{i,j,k,h}=0*tensA{1,1,1,1};
                for m=1:2
                    for n=1:2
                        for p=1:2
                            for q=1:2
                                tensB{i,j,k,h}=tensB{i,j,k,h}+tensA{m,n,p,q}*Mrot(i,m)*Mrot(j,n)*Mrot(k,p)*Mrot(h,q);
                            end
                        end
                    end
                end
            end
        end
    end
end

B{1,1}=tensB{1,1,1,1};
B{1,2}=tensB{1,1,2,2};
B{1,3}=tensB{1,1,1,2};
B{2,1}=tensB{2,2,1,1};
B{2,2}=tensB{2,2,2,2};
B{2,3}=tensB{2,2,1,2};
B{3,1}=tensB{1,2,1,1};
B{3,2}=tensB{1,2,2,2};
B{3,3}=tensB{1,2,1,2};
end


