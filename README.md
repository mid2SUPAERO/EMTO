# EMTO
Efficient Multiscale Topology Optimization

This repository contains all the code needed to reproduce the results presented in submited paper titled "A well connected, locally-oriented and efficient multi-scale topology optimization strategy (EMTO)"

For question/suggestions, contact : edouard.duriez@isae-supaero.fr

In order to run the code, it is necessary to first download the two structural databases on Mendeley : http://dx.doi.org/10.17632/b5hyzxg7fv.1 (database of microstructures for cells with 8 transmission zones), and https://data.mendeley.com/datasets/pvwyj9hnrb/2 (database of microstructures for cells with 4 transmission zones).

The proposed framework uses Method of Moving Asymptotes (MMA) optimization solvers [1]. The associated MMA codes can also be downloaded from http://www.smoptit.se. 


# Replication of results of part 4.1:
## Replication of figures and table
It is advised to start running the coarse grid cases, as the evaluation of the finer grid cases may take a long time to run.

In order to obtain the design and compliance of the L-shape beam without post-processing, call 
```matlab
mainMulti(14,14,0.5,'top88',0,'Lshape')
```
for the coarse grid (fig 12c and line 4 in table 1) and 
```matlab
mainMulti(28,28,0.5,'top88',0,'Lshape')
```
for the finer grid (line 11 in table 1).

In order to obtain the design and compliance of the L-shape beam with post-processing, call 
```matlab
mainMulti(14,14,0.5,'top88',1,'Lshape')
```
for the coarse grid (fig 12d and 14a and line 6 in table 1) and 
```matlab
mainMulti(28,28,0.5,'top88',1,'Lshape')
```
for the finer grid (fig 14b and line 13 in table 1).

When runing these calls, the plots of fig 12b are also obtained, as well as the theoretical compliances (line 2 and 9 in table 1)

In order to obtain the design and compliance of the MBB beam without post-treatment, call 
```matlab
mainMulti(30,10,0.5,'top88',0,'MBB')
```
for the coarse grid (line 18 in table 1) and 
```matlab
mainMulti(60,20,0.5,'top88',0,'MBB')
```
for the finer grid (line 25 in table 1). (mainMulti(60,20,0.5,'volfrac',0,'MBB') leads to a better design)

In order to obtain the design and compliance of the MBB beam with post-treatment, call 
```matlab
mainMulti(30,10,0.5,'top88',1,'MBB')
```
for the coarse grid (fig 15a and line 20 in table 1) and 
```matlab
mainMulti(60,20,0.5,'top88',1,'MBB')
```
for the finer grid (fig 15b and line 27 in table 1).

When runing these calls, the theoretical compliances are also obtained (line 16 and 23 in table 1).


Those designs are compared in table 1 to:

- a top88 case with the same number of elements which densities are filtered to 0 or 1 :
```matlab
mainTop88(14,14,0.5,1,'Lshape','coarse')
mainTop88(28,28,0.5,1,'Lshape','finer')
mainTop88(30,10,0.5,1,'MBB','coarse')
mainTop88(60,20,0.5,1,'MBB','finer')
```
- top88 cases using the same comutational times as each of the 12 EMTO cases :
```matlab
mainTop88(70,70,0.5,1,'Lshape','coarse')
mainTop88(88,88,0.5,1,'Lshape','coarse')
mainTop88(140,140,0.5,1,'Lshape','coarse')
mainTop88(122,122,0.5,1,'Lshape','finer')
mainTop88(134,134,0.5,1,'Lshape','finer')
mainTop88(280,280,0.5,1,'Lshape','finer')
mainTop88(120,40,0.5,1,'MBB','coarse')
mainTop88(150,50,0.5,1,'MBB','coarse')
mainTop88(231,77,0.5,1,'MBB','coarse')
mainTop88(120,40,0.5,1,'MBB','finer')
mainTop88(150,50,0.5,1,'MBB','finer')
mainTop88(231,77,0.5,1,'MBB','finer')
```
respectively.

In order to obtain the results in table 1 using 4 transmition zones (TZ), the same calls can be made, after having implemented the following changes :
change lines 9-13 in totalDesign.m to 
```matlab
load('DB4stru1.mat')
load('DB4stru2.mat')
load('DB4stru3.mat')
load('DB4stru4.mat')
load('DB4stru5.mat')
```
and change line 15 in topMulti to 
```matlab
load('4TZdatabase32-32-32.mat')
```


Fig 13 is obtained by storing the compliance during call
```matlab
mainMulti(14,14,0.5,'top88',0,'Lshape')
```
and then plotting it.


Fig 16 is obtained by running the file compFelem.m

Fig 17 is obtained by running the files compFpenalL.m, compFpenalMBB.m, compFpenalCanti.m (requires a long computational time)
The hard-coded values for the multi-scale and top88 with threshold designs come from table 1, or in the cantilever case, from the calls:
```matlab
mainMulti(40,20,0.5,'top88',1,'Canti')
mainTop88(40,20,0.5,1,'Canti','finer')
```

## Replication of comparison to oriented-grid method ([2])
The comparison to the oriented grid method by Kumar and Suresh [2], is done by testing their code on our examples. Their code can be downloaded here : http://www.ersl.wisc.edu/software/MTO_Code.zip
Between line 46 and 47 of MTO_example.m, we insert 
```matlab
    case 5 %
        probType = 5; % MBB
        clusteringType = 3; % options: 2=density, 3=density-and-strain
        nClusters = 12;  %  enter between 1 and 20
```
We change line 94 into 
```matlab
fileName = 'L_BracketEMTO.dat'
````
Between lines 104 and 105 we insert 
```matlab
    case 5
        fileName = 'MBBbeam_EMTO.dat'; %ED
        volFrac = 0.5;
        zoom = 33;
```
Between lines 489 and 490, we insert
```matlab
    elseif pblm == 5
        F = sparse(2,1,-1000,2*(nely+1)*(nelx+1),1);
        fixeddofs = [1:2:2*(nely+1),2*(nely+1)*nelx+2];
        xPhys((nely)*(nelx)-(nely/2)+(-80:80)) = 1;
```
The tic (inserted befor the first line) and toc (inserted between line 420 and 421) matlab functions can be used to measure the computation time of this method.
To evaluated the MBB design using this method, we change the first line into 
```matlab
MTO_example1(5);
```
then run the code, then retrieve the design (variable "pixelImageData" leading to figure 15f in our article), then evaluate it using our functions : command 
```matlab
evaluateTotalDesign(flipud(1-pixelImageData),3,'MBB')
```
The resulting compliance is 316.9 compared to 203.8 for our method evaluated on the same grid (3000x1000).
To evaluated the Lshaped design, we change the first line into 
```matlab
MTO_example1(2);
```
and replace 40 by 100 in lines 222, 223, 398 (to have the same grid as in our case) then run the code, then retrieve the design (variable "pixelImageData" leading to figure 14f in our article), then evaluate it using our functions : command 
```matlab
evaluateTotalDesign(flipud(1-pixelImageData),3,'Lshaped')
```
The resulting compliance is 108.1 compared to 94.3 for our method evaluated on the same grid (1400x1400).


# Replication of results of part 4.2:
## Results with cells using 8 transmission zones

To obtain figure 18, it is necessary to first change line 6 of topMulti to 
```matlab
rmin = 2;
````
The design can then be obtained through the command 
```matlab
mainMulti(100,40,0.5,'volfrac',0,'Canti')
```
It is reccomended to stop the code before line 23 (to avoid the total design evaluation).

## Results with cells using 4 transmission zones
In order to run the following examples (with cells using only 4 transmission zones), it is necessary to change lines 9-13 in totalDesign.m to 
```matlab
load('DB4stru1.mat')
load('DB4stru2.mat')
load('DB4stru3.mat')
load('DB4stru4.mat')
load('DB4stru5.mat')
```
and to change line 15 in topMulti to 
```matlab
load('4TZdatabase32-32-32.mat')
```

To obtain figure 19a, it is necessary to first change lines 8 and 9 in topMulti so that they read 
```matlab
xMin = 0.49
xMax = 0.51
```
Then the design can be obtained by the command 
```matlab
mainMulti(50,20,0.5,'volfrac',0,'Canti')
```
It is reccomended to stop the code before line 23 (to avoid the total design evaluation).

To obtain figure 19b, it is necessary to first change lines 8 and 9 in topMulti so that they read 
```matlab
xMin = 0
xMax = 0.6
```
Then the design can be obtained by the command 
```matlab
mainMulti(50,20,0.5,'volfrac',0,'Canti')
```
It is reccomended to stop the code before line 23 (to avoid the total design evaluation).

To obtain figure 20a, it is necessary to first change lines 118 and 119 in topMulti so that they read 
```matlab
xmin = [xMin*ones(nele,1); 0.99*ones(nele,1); 0.99*ones(nele,1); 0.49*ones(nele,1)];
xmax = [xMax*ones(nele,1); ones(nele,1); ones(nele,1); 0.51*ones(nele,1)];
```
and change line 6 to
```matlab
rmin=2;
```
Then the design can be obtained by the command 
```matlab
mainMulti(100,40,0.5,'volfrac',0,'Canti')
```
It is reccomended to stop the code before line 23 (to avoid the total design evaluation).

To obtain figure 20c, it is necessary to first change lines 118 and 119 in topMulti so that they read 
```matlab
xmin = [xMin*ones(nele,1); 0.99*ones(nele,1); 0.99*ones(nele,1); zeros(nele,1)];
xmax = [xMax*ones(nele,1); ones(nele,1); ones(nele,1); ones(nele,1)];
```
and change line 6 to
```matlab
rmin=2;
```
Then the design can be obtained by the command 
```matlab
mainMulti(100,40,0.5,'volfrac',0,'Canti')
```
It is reccomended to stop the code before line 23 (to avoid the total design evaluation).

# Codes for creating the database
The codes needed to create the databases are in the subfolder /codeForDatabase . Running code generateDataFromGrid.m will create roughly 3\*32000  text files (3 per optimized cell). It is recomended to run this code in parallel (27 nodes with 24 cores each were used during 24h to generate the database on our supercomputer).
Running code concatenateDataFromGrid.m will then assemble these 3\*32000 files in bigger text files containing all the data needed for the database.
Finally run databaseAsMAt.m to obtain the tensor database in the tensor form that is used in the macroscale optimization (topMulti.m) and struDB.m to optain the micro-structure database that is used after the macroscale optimization to assemble the total design.

# References
[1] Svanberg, Krister. "MMA and GCMMA, versions September 2007." Optimization and Systems Theory 104 (2007).
[2] Kumar T, Suresh K.  A density-and-strain-based K-clustering approach to microstructuraltopology optimization. Structural and Multidisci-plinary Optimization (2020)   
