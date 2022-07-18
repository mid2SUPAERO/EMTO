xlength=0.15; %length in meters
thickness=0.01; %thickness in meters
%thickness=0.01; %thickness in meters

%load('xPhys')

xPhys=[[1 0 1];[1 1 0];[0 1 1]];
nelx=size(xPhys,2);
nely=size(xPhys,1);

xPhysExt=[zeros(1,nelx+2);[zeros(nely,1) xPhys zeros(nely,1)];zeros(1,nelx+2)];

figure(1)
colormap(gray); imagesc(1-xPhysExt); caxis([0 1]); axis equal; axis off; drawnow;


polygones=cell(0);
polygonesSmooth=cell(0);


% if xPhysExt(2,2)~=1
%     error('top left element must be black')
% end


for i=1:nelx+1
    for j=1:nely+1
        startPol=0;
        felm=xPhysExt(j:j+1,i:i+1); %for elements surrounding point(i,j);
        if (min(min(felm))~=1)&&(max(max(felm))~=0)
            startPol=1;
            for k=1:size(polygones,1)
                polygone=cell2mat(polygones(k));
                for m=1:size(polygone,1)
                    if min(polygone(m,:)==[j i])
                        startPol=0;
                    end
                end
            end
        end
        if startPol==1
            
            curPoint1=[j i];
            felm=xPhysExt(curPoint1(1):curPoint1(1)+1,curPoint1(2):curPoint1(2)+1);
            if xPhysExt(curPoint1(1)+1,curPoint1(2)+1)==1
                curPoint2=[j i+1];%%%%%%%%%
            else
                curPoint2=curPoint1;
                curPoint1=[j i+1];
            end
            startPoint=curPoint1;
            polygone=[curPoint1;curPoint2];
            polygoneSmooth=(curPoint1+curPoint2)/2;

            while max(curPoint2~=startPoint)
                felm=xPhysExt(curPoint2(1):curPoint2(1)+1,curPoint2(2):curPoint2(2)+1);
                %rotate so that point 1 is on left of point 2
                rotFlag=0;
                if curPoint1(1)~=curPoint2(1)
                    if curPoint1(1)>curPoint2(1)
                        felm=[[felm(2,1) felm(1,1)];[felm(2,2) felm(1,2)]];
                        rotFlag=1;
                    else
                        felm=[[felm(1,2) felm(2,2)];[felm(1,1) felm(2,1)]];
                        rotFlag=2;
                    end
                else
                    if curPoint1(2)>curPoint2(2)
                        felm=[[felm(2,2) felm(2,1)];[felm(1,2) felm(1,1)]];%%%%%%%
                        rotFlag=3;
                    end
                end
                %black element is always at the bottom left (we turn around the
                %polygone, keeping on our right)
                if (felm(2,1)==0)||(felm(1,1)==1)
                    error('bottom-left should be black and top-left should be white');
                end
                turn=0;
                if felm(2,2)==0
                    turn=1; %turn right
                else
                    if felm(1,2)==0
                        turn=2; %in front
                    else
                        turn=3; %turn left
                    end
                end
                %nextPointMatLine : lines=turn; columns=rot+1
                nextPointMatLine=[[1 0 0 -1];[0 -1 1 0];[-1 0 0 1]];
                nextPointMatCol=[[0 1 -1 0];[1 0 0 -1];[0 -1 1 0]];

                curPoint1=curPoint2;
                curPoint2=[curPoint1(1)+nextPointMatLine(turn,rotFlag+1) curPoint1(2)+nextPointMatCol(turn,rotFlag+1)];
                polygone=[polygone;curPoint2];
                polygoneSmooth=[polygoneSmooth;(curPoint1+curPoint2)/2];
                
                %if two last vectors colinear, delete point before last
                if size(polygoneSmooth,1)>2
                    vec1=polygoneSmooth(end-1,:)-polygoneSmooth(end-2,:);
                    vec2=polygoneSmooth(end,:)-polygoneSmooth(end-1,:);
                    if vec2(1)*vec1(2)==vec2(2)*vec1(1)
                        polygoneSmooth=[polygoneSmooth(1:end-2,:);polygoneSmooth(end,:)];
                    end
                end
                    
            end
            polygoneSmooth=[polygoneSmooth;polygoneSmooth(1,:)];
            polygones=[polygones;{polygone}];
            polygonesSmooth=[polygonesSmooth;{polygoneSmooth}];
        end
    end
end

deletePols=[];
for k=1:size(polygones,1)
    polygone=cell2mat(polygones(k));
    if size(polygone,1)==5
        deletePols=[deletePols k];
    end
end
polygonesSmooth(deletePols,:)=[];


%FID = dxf_open('testPolygonsLighter.dxf');
%FID = dxf_open('top88PolygonsLighter.dxf');
%FID = dxf_open('smoothPolygonsLighter.dxf');
%FID = dxf_open('multiPolygonsLighter.dxf');
FID = dxf_open('designPolygon.dxf');
FID = dxf_set(FID,'Color',[0 1 1]);
for i=1:length(polygonesSmooth)
    a=polygonesSmooth{i};
    X=a(:,1);
    Y=a(:,2);
    Z=zeros(length(X),1);
    dxf_polyline(FID,X,Y,Z);
end
dxf_close(FID);
    
            

