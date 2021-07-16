function x=initDesMore8tz(nelx,nely,volfrac,initDes,thickInit)
if initDes==1
    x=repmat(1,nely,nelx);
elseif initDes==2
    x = repmat(volfrac,nely,nelx);
elseif initDes==3
    x = repmat(0.5,nely,nelx);
elseif initDes==4
    x=repmat(0,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %downwards diagonals
            if ((mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) && (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) > -thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) > 1 -(thickInit)*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) <-1 +(thickInit)*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals
            if ((mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) -1 < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) && (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) -1 >- thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2)-2 > -thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))
                x(ely,elx)=1;
            end
            %vertical and horizontal lines
            if mod(elx-1,round(nelx/2))<thickInit/sqrt(2) || mod(elx-0.01,round(nelx/2))>nelx/2-thickInit/sqrt(2) || mod(ely-1,round(nely/2))<thickInit/sqrt(2) || mod(ely-0.01,round(nely/2))>nely/2-thickInit/sqrt(2)
                x(ely,elx)=1;
            end
        end
    end
elseif initDes==5
    x=repmat(volfrac,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %downwards diagonals
            if ((mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) && (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) > -thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) > 1 -(thickInit)*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) <-1 +(thickInit)*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals
            if ((mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) -1 < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) && (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) -1 >- thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2)-2 > -thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))
                x(ely,elx)=1;
            end
            %vertical and horizontal lines
            if mod(elx-1,round(nelx/2))<thickInit/sqrt(2) || mod(elx-0.01,round(nelx/2))>nelx/2-thickInit/sqrt(2) || mod(ely-1,round(nely/2))<thickInit/sqrt(2) || mod(ely-0.01,round(nely/2))>nely/2-thickInit/sqrt(2)
                x(ely,elx)=1;
            end
        end
    end
elseif initDes==6
    x=repmat(0.5,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %downwards diagonals
            if ((mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) && (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) > -thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) > 1 -(thickInit)*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) <-1 +(thickInit)*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals
            if ((mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) -1 < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) && (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) -1 >- thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2)-2 > -thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))
                x(ely,elx)=1;
            end
            %vertical and horizontal lines
            if mod(elx-1,round(nelx/2))<thickInit/sqrt(2) || mod(elx-0.01,round(nelx/2))>nelx/2-thickInit/sqrt(2) || mod(ely-1,round(nely/2))<thickInit/sqrt(2) || mod(ely-0.01,round(nely/2))>nely/2-thickInit/sqrt(2)
                x(ely,elx)=1;
            end
        end
    end
elseif initDes==7
    x=repmat(0,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %downwards diagonals
            if ((mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) && (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) > -thickInit*0.5*(1/(nelx/2)+1/(nely/2)))) || (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) > 1 -(thickInit)*0.5*(1/(nelx/2)+1/(nely/2))) || (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) <-1 +(thickInit)*0.5*(1/(nelx/2)+1/(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals
            if ((mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) -1 < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) && (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) -1 >- thickInit*0.5*(1/(nelx/2)+1/(nely/2)))) || (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) || (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2)-2 > -thickInit*0.5*(1/(nelx/2)+1/(nely/2)))
                x(ely,elx)=1;
            end
            %vertical and horizontal lines
            if mod(elx,(nelx/2))<thickInit/2 || mod(elx-1,(nelx/2))<thickInit/2 || mod(elx,(nelx/2))>nelx/2-thickInit/2 || mod(ely,(nely/2))<thickInit/2 || mod(ely-1,(nely/2))<thickInit/2 || mod(ely,(nely/2))>nely/2-thickInit/2
                x(ely,elx)=1;
            end
            %downwards diagonals of coeficient 1/3
            if ((elx/nelx-mod(ely,nely/2)/(nely/2) < thickInit*0.5*(1/nelx+1/(nely/2))) && (elx/nelx-mod(ely,nely/2)/(nely/2) > -thickInit*0.5*(1/(nelx)+1/(nely/2)))) || (elx/nelx-mod(ely,nely/2)/(nely/2) > 1 -(thickInit)*0.5*(1/(nelx)+1/(nely/2))) || (elx/nelx-mod(ely,nely/2)/(nely/2) <-1 +(thickInit)*0.5*(1/nelx+1/(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals of coeficient 1/3
            if ((elx/nelx+mod(ely,nely/2)/(nely/2) -1 < thickInit*0.5*(1/nelx+1/(nely/2))) && (elx/nelx+mod(ely,nely/2)/(nely/2)-1 > -thickInit*0.5*(1/(nelx)+1/(nely/2)))) || (elx/nelx+mod(ely,nely/2)/(nely/2) < (thickInit)*0.5*(1/(nelx)+1/(nely/2))) || (elx/nelx+mod(ely,nely/2)/(nely/2) -2 > -(thickInit)*0.5*(1/nelx+1/(nely/2)))
                x(ely,elx)=1;
            end
            %downwards diagonals of coeficient 3            
            if ((ely/nely-mod(elx,nelx/2)/(nelx/2) < thickInit*0.5*(1/nely+1/(nelx/2))) && (ely/nely-mod(elx,nelx/2)/(nelx/2) > -thickInit*0.5*(1/(nely)+1/(nelx/2)))) || (ely/nely-mod(elx,nelx/2)/(nelx/2) > 1 -(thickInit)*0.5*(1/(nely)+1/(nelx/2))) || (ely/nely-mod(elx,nelx/2)/(nelx/2) <-1 +(thickInit)*0.5*(1/nely+1/(nelx/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals of coeficient 3
            if ((ely/nely+mod(elx,nelx/2)/(nelx/2) -1 < thickInit*0.5*(1/nely+1/(nelx/2))) && (ely/nely+mod(elx,nelx/2)/(nelx/2)-1 > -thickInit*0.5*(1/(nely)+1/(nelx/2)))) || (ely/nely+mod(elx,nelx/2)/(nelx/2) < (thickInit)*0.5*(1/(nely)+1/(nelx/2))) || (ely/nely+mod(elx,nelx/2)/(nelx/2) -2 > -(thickInit)*0.5*(1/nely+1/(nelx/2)))
                x(ely,elx)=1;
            end
        end
    end
elseif initDes==8
    x=repmat(volfrac,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %downwards diagonals
            if ((mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) && (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) > -thickInit*0.5*(1/(nelx/2)+1/(nely/2)))) || (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) > 1 -(thickInit)*0.5*(1/(nelx/2)+1/(nely/2))) || (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) <-1 +(thickInit)*0.5*(1/(nelx/2)+1/(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals
            if ((mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) -1 < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) && (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) -1 >- thickInit*0.5*(1/(nelx/2)+1/(nely/2)))) || (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) || (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2)-2 > -thickInit*0.5*(1/(nelx/2)+1/(nely/2)))
                x(ely,elx)=1;
            end
            %vertical and horizontal lines
            if mod(elx,(nelx/2))<thickInit/2 || mod(elx-1,(nelx/2))<thickInit/2 || mod(elx,(nelx/2))>nelx/2-thickInit/2 || mod(ely,(nely/2))<thickInit/2 || mod(ely-1,(nely/2))<thickInit/2 || mod(ely,(nely/2))>nely/2-thickInit/2
                x(ely,elx)=1;
            end
            %downwards diagonals of coeficient 1/3
            if ((elx/nelx-mod(ely,nely/2)/(nely/2) < thickInit*0.5*(1/nelx+1/(nely/2))) && (elx/nelx-mod(ely,nely/2)/(nely/2) > -thickInit*0.5*(1/(nelx)+1/(nely/2)))) || (elx/nelx-mod(ely,nely/2)/(nely/2) > 1 -(thickInit)*0.5*(1/(nelx)+1/(nely/2))) || (elx/nelx-mod(ely,nely/2)/(nely/2) <-1 +(thickInit)*0.5*(1/nelx+1/(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals of coeficient 1/3
            if ((elx/nelx+mod(ely,nely/2)/(nely/2) -1 < thickInit*0.5*(1/nelx+1/(nely/2))) && (elx/nelx+mod(ely,nely/2)/(nely/2)-1 > -thickInit*0.5*(1/(nelx)+1/(nely/2)))) || (elx/nelx+mod(ely,nely/2)/(nely/2) < (thickInit)*0.5*(1/(nelx)+1/(nely/2))) || (elx/nelx+mod(ely,nely/2)/(nely/2) -2 > -(thickInit)*0.5*(1/nelx+1/(nely/2)))
                x(ely,elx)=1;
            end
            %downwards diagonals of coeficient 3            
            if ((ely/nely-mod(elx,nelx/2)/(nelx/2) < thickInit*0.5*(1/nely+1/(nelx/2))) && (ely/nely-mod(elx,nelx/2)/(nelx/2) > -thickInit*0.5*(1/(nely)+1/(nelx/2)))) || (ely/nely-mod(elx,nelx/2)/(nelx/2) > 1 -(thickInit)*0.5*(1/(nely)+1/(nelx/2))) || (ely/nely-mod(elx,nelx/2)/(nelx/2) <-1 +(thickInit)*0.5*(1/nely+1/(nelx/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals of coeficient 3
            if ((ely/nely+mod(elx,nelx/2)/(nelx/2) -1 < thickInit*0.5*(1/nely+1/(nelx/2))) && (ely/nely+mod(elx,nelx/2)/(nelx/2)-1 > -thickInit*0.5*(1/(nely)+1/(nelx/2)))) || (ely/nely+mod(elx,nelx/2)/(nelx/2) < (thickInit)*0.5*(1/(nely)+1/(nelx/2))) || (ely/nely+mod(elx,nelx/2)/(nelx/2) -2 > -(thickInit)*0.5*(1/nely+1/(nelx/2)))
                x(ely,elx)=1;
            end
        end
    end
elseif initDes==9
    x=repmat(0.5,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %downwards diagonals
            if ((mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) && (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) > -thickInit*0.5*(1/(nelx/2)+1/(nely/2)))) || (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) > 1 -(thickInit)*0.5*(1/(nelx/2)+1/(nely/2))) || (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) <-1 +(thickInit)*0.5*(1/(nelx/2)+1/(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals
            if ((mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) -1 < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) && (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) -1 >- thickInit*0.5*(1/(nelx/2)+1/(nely/2)))) || (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) || (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2)-2 > -thickInit*0.5*(1/(nelx/2)+1/(nely/2)))
                x(ely,elx)=1;
            end
            %vertical and horizontal lines
            if mod(elx,(nelx/2))<thickInit/2 || mod(elx-1,(nelx/2))<thickInit/2 || mod(elx,(nelx/2))>nelx/2-thickInit/2 || mod(ely,(nely/2))<thickInit/2 || mod(ely-1,(nely/2))<thickInit/2 || mod(ely,(nely/2))>nely/2-thickInit/2
                x(ely,elx)=1;
            end
            %downwards diagonals of coeficient 1/3
            if ((elx/nelx-mod(ely,nely/2)/(nely/2) < thickInit*0.5*(1/nelx+1/(nely/2))) && (elx/nelx-mod(ely,nely/2)/(nely/2) > -thickInit*0.5*(1/(nelx)+1/(nely/2)))) || (elx/nelx-mod(ely,nely/2)/(nely/2) > 1 -(thickInit)*0.5*(1/(nelx)+1/(nely/2))) || (elx/nelx-mod(ely,nely/2)/(nely/2) <-1 +(thickInit)*0.5*(1/nelx+1/(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals of coeficient 1/3
            if ((elx/nelx+mod(ely,nely/2)/(nely/2) -1 < thickInit*0.5*(1/nelx+1/(nely/2))) && (elx/nelx+mod(ely,nely/2)/(nely/2)-1 > -thickInit*0.5*(1/(nelx)+1/(nely/2)))) || (elx/nelx+mod(ely,nely/2)/(nely/2) < (thickInit)*0.5*(1/(nelx)+1/(nely/2))) || (elx/nelx+mod(ely,nely/2)/(nely/2) -2 > -(thickInit)*0.5*(1/nelx+1/(nely/2)))
                x(ely,elx)=1;
            end
            %downwards diagonals of coeficient 3            
            if ((ely/nely-mod(elx,nelx/2)/(nelx/2) < thickInit*0.5*(1/nely+1/(nelx/2))) && (ely/nely-mod(elx,nelx/2)/(nelx/2) > -thickInit*0.5*(1/(nely)+1/(nelx/2)))) || (ely/nely-mod(elx,nelx/2)/(nelx/2) > 1 -(thickInit)*0.5*(1/(nely)+1/(nelx/2))) || (ely/nely-mod(elx,nelx/2)/(nelx/2) <-1 +(thickInit)*0.5*(1/nely+1/(nelx/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals of coeficient 3
            if ((ely/nely+mod(elx,nelx/2)/(nelx/2) -1 < thickInit*0.5*(1/nely+1/(nelx/2))) && (ely/nely+mod(elx,nelx/2)/(nelx/2)-1 > -thickInit*0.5*(1/(nely)+1/(nelx/2)))) || (ely/nely+mod(elx,nelx/2)/(nelx/2) < (thickInit)*0.5*(1/(nely)+1/(nelx/2))) || (ely/nely+mod(elx,nelx/2)/(nelx/2) -2 > -(thickInit)*0.5*(1/nely+1/(nelx/2)))
                x(ely,elx)=1;
            end
        end
    end
elseif initDes==10
    x=repmat(0,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %downwards diagonals
            if ((mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) && (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) > -thickInit*0.5*(1/(nelx/2)+1/(nely/2)))) || (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) > 1 -(thickInit)*0.5*(1/(nelx/2)+1/(nely/2))) || (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) <-1 +(thickInit)*0.5*(1/(nelx/2)+1/(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals
            if ((mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) -1 < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) && (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) -1 >- thickInit*0.5*(1/(nelx/2)+1/(nely/2)))) || (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) || (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2)-2 > -thickInit*0.5*(1/(nelx/2)+1/(nely/2)))
                x(ely,elx)=1;
            end
            %vertical and horizontal lines
            if (elx-nelx/2<thickInit/2 && elx-nelx/2>-thickInit/2) || (ely-nely/2<thickInit/2 && ely-nely/2>-thickInit/2)
                x(ely,elx)=1;
            end
            %downwards diagonals of coeficient 1/3
            if ((elx/nelx-mod(ely,nely/2)/(nely/2) < thickInit*0.5*(1/nelx+1/(nely/2))) && (elx/nelx-mod(ely,nely/2)/(nely/2) > -thickInit*0.5*(1/(nelx)+1/(nely/2)))) || (elx/nelx-mod(ely,nely/2)/(nely/2) > 1 -(thickInit)*0.5*(1/(nelx)+1/(nely/2))) || (elx/nelx-mod(ely,nely/2)/(nely/2) <-1 +(thickInit)*0.5*(1/nelx+1/(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals of coeficient 1/3
            if ((elx/nelx+mod(ely,nely/2)/(nely/2) -1 < thickInit*0.5*(1/nelx+1/(nely/2))) && (elx/nelx+mod(ely,nely/2)/(nely/2)-1 > -thickInit*0.5*(1/(nelx)+1/(nely/2)))) || (elx/nelx+mod(ely,nely/2)/(nely/2) < (thickInit)*0.5*(1/(nelx)+1/(nely/2))) || (elx/nelx+mod(ely,nely/2)/(nely/2) -2 > -(thickInit)*0.5*(1/nelx+1/(nely/2)))
                x(ely,elx)=1;
            end
            %downwards diagonals of coeficient 3            
            if ((ely/nely-mod(elx,nelx/2)/(nelx/2) < thickInit*0.5*(1/nely+1/(nelx/2))) && (ely/nely-mod(elx,nelx/2)/(nelx/2) > -thickInit*0.5*(1/(nely)+1/(nelx/2)))) || (ely/nely-mod(elx,nelx/2)/(nelx/2) > 1 -(thickInit)*0.5*(1/(nely)+1/(nelx/2))) || (ely/nely-mod(elx,nelx/2)/(nelx/2) <-1 +(thickInit)*0.5*(1/nely+1/(nelx/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals of coeficient 3
            if ((ely/nely+mod(elx,nelx/2)/(nelx/2) -1 < thickInit*0.5*(1/nely+1/(nelx/2))) && (ely/nely+mod(elx,nelx/2)/(nelx/2)-1 > -thickInit*0.5*(1/(nely)+1/(nelx/2)))) || (ely/nely+mod(elx,nelx/2)/(nelx/2) < (thickInit)*0.5*(1/(nely)+1/(nelx/2))) || (ely/nely+mod(elx,nelx/2)/(nelx/2) -2 > -(thickInit)*0.5*(1/nely+1/(nelx/2)))
                x(ely,elx)=1;
            end
        end
    end
elseif initDes==11
    x=repmat(volfrac,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %downwards diagonals
            if ((mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) && (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) > -thickInit*0.5*(1/(nelx/2)+1/(nely/2)))) || (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) > 1 -(thickInit)*0.5*(1/(nelx/2)+1/(nely/2))) || (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) <-1 +(thickInit)*0.5*(1/(nelx/2)+1/(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals
            if ((mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) -1 < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) && (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) -1 >- thickInit*0.5*(1/(nelx/2)+1/(nely/2)))) || (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) || (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2)-2 > -thickInit*0.5*(1/(nelx/2)+1/(nely/2)))
                x(ely,elx)=1;
            end
            %vertical and horizontal lines
            if (elx-nelx/2<thickInit/2 && elx-nelx/2>-thickInit/2) || (ely-nely/2<thickInit/2 && ely-nely/2>-thickInit/2)
                x(ely,elx)=1;
            end
            %downwards diagonals of coeficient 1/3
            if ((elx/nelx-mod(ely,nely/2)/(nely/2) < thickInit*0.5*(1/nelx+1/(nely/2))) && (elx/nelx-mod(ely,nely/2)/(nely/2) > -thickInit*0.5*(1/(nelx)+1/(nely/2)))) || (elx/nelx-mod(ely,nely/2)/(nely/2) > 1 -(thickInit)*0.5*(1/(nelx)+1/(nely/2))) || (elx/nelx-mod(ely,nely/2)/(nely/2) <-1 +(thickInit)*0.5*(1/nelx+1/(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals of coeficient 1/3
            if ((elx/nelx+mod(ely,nely/2)/(nely/2) -1 < thickInit*0.5*(1/nelx+1/(nely/2))) && (elx/nelx+mod(ely,nely/2)/(nely/2)-1 > -thickInit*0.5*(1/(nelx)+1/(nely/2)))) || (elx/nelx+mod(ely,nely/2)/(nely/2) < (thickInit)*0.5*(1/(nelx)+1/(nely/2))) || (elx/nelx+mod(ely,nely/2)/(nely/2) -2 > -(thickInit)*0.5*(1/nelx+1/(nely/2)))
                x(ely,elx)=1;
            end
            %downwards diagonals of coeficient 3            
            if ((ely/nely-mod(elx,nelx/2)/(nelx/2) < thickInit*0.5*(1/nely+1/(nelx/2))) && (ely/nely-mod(elx,nelx/2)/(nelx/2) > -thickInit*0.5*(1/(nely)+1/(nelx/2)))) || (ely/nely-mod(elx,nelx/2)/(nelx/2) > 1 -(thickInit)*0.5*(1/(nely)+1/(nelx/2))) || (ely/nely-mod(elx,nelx/2)/(nelx/2) <-1 +(thickInit)*0.5*(1/nely+1/(nelx/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals of coeficient 3
            if ((ely/nely+mod(elx,nelx/2)/(nelx/2) -1 < thickInit*0.5*(1/nely+1/(nelx/2))) && (ely/nely+mod(elx,nelx/2)/(nelx/2)-1 > -thickInit*0.5*(1/(nely)+1/(nelx/2)))) || (ely/nely+mod(elx,nelx/2)/(nelx/2) < (thickInit)*0.5*(1/(nely)+1/(nelx/2))) || (ely/nely+mod(elx,nelx/2)/(nelx/2) -2 > -(thickInit)*0.5*(1/nely+1/(nelx/2)))
                x(ely,elx)=1;
            end
        end
    end
elseif initDes==12
    x=repmat(0.5,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %downwards diagonals
            if ((mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) && (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) > -thickInit*0.5*(1/(nelx/2)+1/(nely/2)))) || (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) > 1 -(thickInit)*0.5*(1/(nelx/2)+1/(nely/2))) || (mod(elx,(nelx/2))/(nelx/2)-mod(ely,(nely/2))/(nely/2) <-1 +(thickInit)*0.5*(1/(nelx/2)+1/(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals
            if ((mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) -1 < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) && (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) -1 >- thickInit*0.5*(1/(nelx/2)+1/(nely/2)))) || (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2) < thickInit*0.5*(1/(nelx/2)+1/(nely/2))) || (mod(elx,(nelx/2))/(nelx/2)+mod(ely,(nely/2))/(nely/2)-2 > -thickInit*0.5*(1/(nelx/2)+1/(nely/2)))
                x(ely,elx)=1;
            end
            %vertical and horizontal lines
            if (elx-nelx/2<thickInit/2 && elx-nelx/2>-thickInit/2) || (ely-nely/2<thickInit/2 && ely-nely/2>-thickInit/2)
                x(ely,elx)=1;
            end
            %downwards diagonals of coeficient 1/3
            if ((elx/nelx-mod(ely,nely/2)/(nely/2) < thickInit*0.5*(1/nelx+1/(nely/2))) && (elx/nelx-mod(ely,nely/2)/(nely/2) > -thickInit*0.5*(1/(nelx)+1/(nely/2)))) || (elx/nelx-mod(ely,nely/2)/(nely/2) > 1 -(thickInit)*0.5*(1/(nelx)+1/(nely/2))) || (elx/nelx-mod(ely,nely/2)/(nely/2) <-1 +(thickInit)*0.5*(1/nelx+1/(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals of coeficient 1/3
            if ((elx/nelx+mod(ely,nely/2)/(nely/2) -1 < thickInit*0.5*(1/nelx+1/(nely/2))) && (elx/nelx+mod(ely,nely/2)/(nely/2)-1 > -thickInit*0.5*(1/(nelx)+1/(nely/2)))) || (elx/nelx+mod(ely,nely/2)/(nely/2) < (thickInit)*0.5*(1/(nelx)+1/(nely/2))) || (elx/nelx+mod(ely,nely/2)/(nely/2) -2 > -(thickInit)*0.5*(1/nelx+1/(nely/2)))
                x(ely,elx)=1;
            end
            %downwards diagonals of coeficient 3            
            if ((ely/nely-mod(elx,nelx/2)/(nelx/2) < thickInit*0.5*(1/nely+1/(nelx/2))) && (ely/nely-mod(elx,nelx/2)/(nelx/2) > -thickInit*0.5*(1/(nely)+1/(nelx/2)))) || (ely/nely-mod(elx,nelx/2)/(nelx/2) > 1 -(thickInit)*0.5*(1/(nely)+1/(nelx/2))) || (ely/nely-mod(elx,nelx/2)/(nelx/2) <-1 +(thickInit)*0.5*(1/nely+1/(nelx/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals of coeficient 3
            if ((ely/nely+mod(elx,nelx/2)/(nelx/2) -1 < thickInit*0.5*(1/nely+1/(nelx/2))) && (ely/nely+mod(elx,nelx/2)/(nelx/2)-1 > -thickInit*0.5*(1/(nely)+1/(nelx/2)))) || (ely/nely+mod(elx,nelx/2)/(nelx/2) < (thickInit)*0.5*(1/(nely)+1/(nelx/2))) || (ely/nely+mod(elx,nelx/2)/(nelx/2) -2 > -(thickInit)*0.5*(1/nely+1/(nelx/2)))
                x(ely,elx)=1;
            end
        end
    end 
elseif initDes==13
    x=repmat(0,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %vertical and horizontal lines
            if mod(elx-1,round(nelx/2))<thickInit/sqrt(2) || mod(elx-0.01,round(nelx/2))>nelx/2-thickInit/sqrt(2) || mod(ely-1,round(nely/2))<thickInit/sqrt(2) || mod(ely-0.01,round(nely/2))>nely/2-thickInit/sqrt(2)
                x(ely,elx)=1;
            end
        end
    end
elseif initDes==14
    x=repmat(volfrac,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %vertical and horizontal lines
            if mod(elx-1,round(nelx/2))<thickInit/sqrt(2) || mod(elx-0.01,round(nelx/2))>nelx/2-thickInit/sqrt(2) || mod(ely-1,round(nely/2))<thickInit/sqrt(2) || mod(ely-0.01,round(nely/2))>nely/2-thickInit/sqrt(2)
                x(ely,elx)=1;
            end
        end
    end
elseif initDes==15
    x=repmat(0.5,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %vertical and horizontal lines
            if mod(elx-1,round(nelx/2))<thickInit/sqrt(2) || mod(elx-0.01,round(nelx/2))>nelx/2-thickInit/sqrt(2) || mod(ely-1,round(nely/2))<thickInit/sqrt(2) || mod(ely-0.01,round(nely/2))>nely/2-thickInit/sqrt(2)
                x(ely,elx)=1;
            end
        end
    end
elseif initDes==16
    x=repmat(0,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %downwards diagonals
            if ((mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) && (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) > -thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) > 1 -(thickInit)*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) <-1 +(thickInit)*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals
            if ((mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) -1 < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) && (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) -1 >- thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2)-2 > -thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))
                x(ely,elx)=1;
            end
        end
    end   
elseif initDes==17
    x=repmat(volfrac,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %downwards diagonals
            if ((mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) && (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) > -thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) > 1 -(thickInit)*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) <-1 +(thickInit)*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals
            if ((mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) -1 < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) && (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) -1 >- thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2)-2 > -thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))
                x(ely,elx)=1;
            end
        end
    end   
elseif initDes==18
    x=repmat(0.5,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %downwards diagonals
            if ((mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) && (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) > -thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) > 1 -(thickInit)*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)-mod(ely,ceil(nely/2))/ceil(nely/2) <-1 +(thickInit)*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))
                x(ely,elx)=1;
            end
            %upwards diagonals
            if ((mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) -1 < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) && (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) -1 >- thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2) < thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2))) || (mod(elx,ceil(nelx/2))/ceil(nelx/2)+mod(ely,ceil(nely/2))/ceil(nely/2)-2 > -thickInit*0.5*(1/ceil(nelx/2)+1/ceil(nely/2)))
                x(ely,elx)=1;
            end
        end
    end   
elseif initDes==19
    x=repmat(0,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %vertical and horizontal lines
            if elx-1<thickInit || elx>nelx-thickInit || ely-1<thickInit || ely>nely-thickInit
                x(ely,elx)=1;
            end
            %downwards diagonal
            if elx-ely < thickInit/sqrt(2) && elx-ely > - thickInit/sqrt(2)
                x(ely,elx)=1;
            end
            %upwards diagonals
            if (elx-1)/(nelx-1)+(ely-1)/(nely-1) < 1+ 2/(nelx+nely)*thickInit/sqrt(2) && (elx-1)/(nelx-1)+(ely-1)/(nely-1) > 1- 2/(nelx+nely)*thickInit/sqrt(2)
                x(ely,elx)=1;
            end
        end
    end
elseif initDes==20
    x=repmat(volfrac,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %vertical and horizontal lines
            if elx-1<thickInit || elx>nelx-thickInit || ely-1<thickInit || ely>nely-thickInit
                x(ely,elx)=1;
            end
            %downwards diagonal
            if elx-ely < thickInit/sqrt(2) && elx-ely > - thickInit/sqrt(2)
                x(ely,elx)=1;
            end
            %upwards diagonals
            if (elx-1)/(nelx-1)+(ely-1)/(nely-1) < 1+ 2/(nelx+nely)*thickInit/sqrt(2) && (elx-1)/(nelx-1)+(ely-1)/(nely-1) > 1- 2/(nelx+nely)*thickInit/sqrt(2)
                x(ely,elx)=1;
            end
        end
    end
elseif initDes==21
    x=repmat(0.5,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %vertical and horizontal lines
            if elx-1<thickInit || elx>nelx-thickInit || ely-1<thickInit || ely>nely-thickInit
                x(ely,elx)=1;
            end
            %downwards diagonal
            if elx-ely < thickInit/sqrt(2) && elx-ely > - thickInit/sqrt(2)
                x(ely,elx)=1;
            end
            %upwards diagonals
            if (elx-1)/(nelx-1)+(ely-1)/(nely-1) < 1+ 2/(nelx+nely)*thickInit/sqrt(2) && (elx-1)/(nelx-1)+(ely-1)/(nely-1) > 1- 2/(nelx+nely)*thickInit/sqrt(2)
                x(ely,elx)=1;
            end
        end
    end
elseif initDes==22
    x=repmat(1,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %make 1 big hole
            if (elx-nelx/2-1/2)^2+(ely-nely/2-1/2)^2 < (nelx/3)^2
                x(ely,elx)=0;
            end
        end
    end
elseif initDes==23
    x=repmat(1,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %make 1 big hole
            if (elx-nelx/2-1/2)^2+(ely-nely/2-1/2)^2 < (nelx/3)^2
                x(ely,elx)=volfrac;
            end
        end
    end
elseif initDes==24
    x=repmat(1,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %make 1 big hole
            if (elx-nelx/2-1/2)^2+(ely-nely/2-1/2)^2 < (nelx/3)^2
                x(ely,elx)=0.5;
            end
        end
    end
elseif initDes==25
    x=repmat(1,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %make 1 small hole
            if (elx-nelx/2-1/2)^2+(ely-nely/2-1/2)^2 < (nelx/6)^2
                x(ely,elx)=0;
            end
        end
    end
elseif initDes==26
    x=repmat(1,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %make 1 small hole
            if (elx-nelx/2-1/2)^2+(ely-nely/2-1/2)^2 < (nelx/6)^2
                x(ely,elx)=volfrac;
            end
        end
    end
elseif initDes==27
    x=repmat(1,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %make 1 small hole
            if (elx-nelx/2-1/2)^2+(ely-nely/2-1/2)^2 < (nelx/6)^2
                x(ely,elx)=0.5;
            end
        end
    end
elseif initDes==28
    x=repmat(1,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %make 4 small holes
            xcenters=[(nelx+1)/4 (nelx+1)/4 3*(nelx+1)/4 3*(nelx+1)/4];
            ycenters=[(nely+1)/4 3*(nely+1)/4 (nely+1)/4 3*(nely+1)/4];
            radius=[1/6 1/6 1/6 1/6];
            for i=1:size(radius,2)
                if ((elx-xcenters(i))/nelx)^2+((ely-ycenters(i))/nely)^2 < (radius(i))^2
                    x(ely,elx)=0;
                end
            end
        end
    end
elseif initDes==29
    x=repmat(1,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %make 4 small holes
            xcenters=[(nelx+1)/4 (nelx+1)/4 3*(nelx+1)/4 3*(nelx+1)/4];
            ycenters=[(nely+1)/4 3*(nely+1)/4 (nely+1)/4 3*(nely+1)/4];
            radius=[1/6 1/6 1/6 1/6];
            for i=1:size(radius,2)
                if ((elx-xcenters(i))/nelx)^2+((ely-ycenters(i))/nely)^2 < (radius(i))^2
                    x(ely,elx)=volfrac;
                end
            end
        end
    end
elseif initDes==30
    x=repmat(1,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %make 4 small holes
            xcenters=[(nelx+1)/4 (nelx+1)/4 3*(nelx+1)/4 3*(nelx+1)/4];
            ycenters=[(nely+1)/4 3*(nely+1)/4 (nely+1)/4 3*(nely+1)/4];
            radius=[1/6 1/6 1/6 1/6];
            for i=1:size(radius,2)
                if ((elx-xcenters(i))/nelx)^2+((ely-ycenters(i))/nely)^2 < (radius(i))^2
                    x(ely,elx)=0.5;
                end
            end
        end
    end
elseif initDes==31
    x=repmat(1,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %make 9 small holes
            xcenters=[(nelx+1)/6 (nelx+1)/6 (nelx+1)/6 3*(nelx+1)/6 3*(nelx+1)/6 3*(nelx+1)/6 5*(nelx+1)/6 5*(nelx+1)/6 5*(nelx+1)/6];
            ycenters=[(nely+1)/6 3*(nely+1)/6 5*(nely+1)/6 (nely+1)/6 3*(nely+1)/6 5*(nely+1)/6 (nely+1)/6 3*(nely+1)/6 5*(nely+1)/6];
            radius=[1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9];
            for i=1:size(radius,2)
                if ((elx-xcenters(i))/nelx)^2+((ely-ycenters(i))/nely)^2 < (radius(i))^2
                    x(ely,elx)=0;
                end
            end
        end
    end
elseif initDes==32
    x=repmat(1,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %make 9 small holes
            xcenters=[(nelx+1)/6 (nelx+1)/6 (nelx+1)/6 3*(nelx+1)/6 3*(nelx+1)/6 3*(nelx+1)/6 5*(nelx+1)/6 5*(nelx+1)/6 5*(nelx+1)/6];
            ycenters=[(nely+1)/6 3*(nely+1)/6 5*(nely+1)/6 (nely+1)/6 3*(nely+1)/6 5*(nely+1)/6 (nely+1)/6 3*(nely+1)/6 5*(nely+1)/6];
            radius=[1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9];
            for i=1:size(radius,2)
                if ((elx-xcenters(i))/nelx)^2+((ely-ycenters(i))/nely)^2 < (radius(i))^2
                    x(ely,elx)=volfrac;
                end
            end
        end
    end
elseif initDes==33
    x=repmat(1,nely,nelx);
    for elx=1:nelx
        for ely=1:nely
            %make 9 small holes
            xcenters=[(nelx+1)/6 (nelx+1)/6 (nelx+1)/6 3*(nelx+1)/6 3*(nelx+1)/6 3*(nelx+1)/6 5*(nelx+1)/6 5*(nelx+1)/6 5*(nelx+1)/6];
            ycenters=[(nely+1)/6 3*(nely+1)/6 5*(nely+1)/6 (nely+1)/6 3*(nely+1)/6 5*(nely+1)/6 (nely+1)/6 3*(nely+1)/6 5*(nely+1)/6];
            radius=[1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9];
            for i=1:size(radius,2)
                if ((elx-xcenters(i))/nelx)^2+((ely-ycenters(i))/nely)^2 < (radius(i))^2
                    x(ely,elx)=0.5;
                end
            end
        end
    end
elseif initDes==34
    x=repmat(1,nely,nelx);
    center=0;
    for elx=1:nelx
        for ely=1:nely
            distCenter=sqrt(((elx-(nelx+1)/2)/nelx)^2+((ely-(nely+1)/2)/nely)^2);
            x(ely,elx)=center+(1-center)*distCenter*2;
        end
    end
elseif initDes==35
    x=repmat(1,nely,nelx);
    center=volfrac;
    for elx=1:nelx
        for ely=1:nely
            distCenter=sqrt(((elx-(nelx+1)/2)/nelx)^2+((ely-(nely+1)/2)/nely)^2);
            x(ely,elx)=center+(1-center)*distCenter*2;
        end
    end
elseif initDes==36
    x=repmat(1,nely,nelx);
    center=0.5;
    for elx=1:nelx
        for ely=1:nely
            distCenter=sqrt(((elx-(nelx+1)/2)/nelx)^2+((ely-(nely+1)/2)/nely)^2);
            x(ely,elx)=center+(1-center)*distCenter*2;
        end
    end
elseif initDes==37
    x=repmat(1,nely,nelx);
    center=0;
    for elx=1:nelx
        for ely=1:nely
            distCenter=abs((elx-(nelx+1)/2)/nelx);
            x(ely,elx)=center+(1-center)*distCenter*2;
        end
    end
elseif initDes==38
    x=repmat(1,nely,nelx);
    center=volfrac;
    for elx=1:nelx
        for ely=1:nely
            distCenter=abs((elx-(nelx+1)/2)/nelx);
            x(ely,elx)=center+(1-center)*distCenter*2;
        end
    end
elseif initDes==39
    x=repmat(1,nely,nelx);
    center=0.5;
    for elx=1:nelx
        for ely=1:nely
            distCenter=abs((elx-(nelx+1)/2)/nelx);
            x(ely,elx)=center+(1-center)*distCenter*2;
        end
    end
elseif initDes==40
    x=repmat(1,nely,nelx);
    center=0;
    for elx=1:nelx
        for ely=1:nely
            distCenter=abs((ely-(nely+1)/2)/nely);
            x(ely,elx)=center+(1-center)*distCenter*2;
        end
    end
elseif initDes==41
    x=repmat(1,nely,nelx);
    center=volfrac;
    for elx=1:nelx
        for ely=1:nely
            distCenter=abs((ely-(nely+1)/2)/nely);
            x(ely,elx)=center+(1-center)*distCenter*2;
        end
    end
elseif initDes==42
    x=repmat(1,nely,nelx);
    center=0.5;
    for elx=1:nelx
        for ely=1:nely
            distCenter=abs((ely-(nely+1)/2)/nely);
            x(ely,elx)=center+(1-center)*distCenter*2;
        end
    end
else
    error('initDes should be in 1..42')
end
figure(1)
colormap(gray); imagesc(1-x); caxis([0 1]); axis equal; axis off; drawnow;