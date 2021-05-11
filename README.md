# EMTO
Efficient Multiscale Topology Optimization

This repository will contain all the code needed to reproduce the results presented in submited paper titled "A well connected, locally-oriented and efficient multi-scaletopology optimization strategy (EMTO)"

In order to run the code, it is necessary to first download the structural database on Mendeley : http://dx.doi.org/10.17632/b5hyzxg7fv.1 (database of microstructures for cells with 8 transmission zones).

The proposed framework uses Method of Moving Asymptotes (MMA) optimization solvers [1]. The associated MMA codes can also be downloaded from http://www.smoptit.se. 


# Replication of results of part 4.1:
It is advised to start running the coarse grid cases, as the evaluation of the finer grid cases may take a long time to run.

In order to obtain the design and compliance of the L-shape beam without post-treatment (fig 13c and line 2 in table 1), call mainMulti(14,14,0.5,'top88',0,'Lshape') for the coarse grid and mainMulti(28,28,0.5,'top88',0,'Lshape') for the finer grid.

In order to obtain the design and compliance of the L-shape beam with post-treatment (fig 13d and 14a and line 3 in table 1), call mainMulti(14,14,0.5,'top88',1,'Lshape') for the coarse grid and mainMulti(28,28,0.5,'top88',1,'Lshape') for the finer grid.

When runing these calls, the plots of fig 13b are also obtained, as well as the theoretical compliance (line 1 in table 1)

In order to obtain the design and compliance of the MBB beam without post-treatment (line 5 in table 1), call mainMulti(30,10,0.5,'top88',0,'MBB') for the coarse grid and mainMulti(60,20,0.5,'top88',0,'MBB') for the finer grid.

In order to obtain the design and compliance of the MBB beam with post-treatment (fig 15a and line 6 in table 1), call mainMulti(30,10,0.5,'top88',1,'MBB') for the coarse grid and mainMulti(60,20,0.5,'top88',1,'MBB') for the finer grid.

When runing these calls, the theoretical compliance are also obtained (line 4 in table 1).


Those designs are compared in table 1 to:

a top88 case with the same number of elements which densities are filtered to 0 or 1 ( mainTop88(14,14,0.5,1,'Lshape','coarse'), mainTop88(28,28,0.5,1,'Lshape','finer'), mainTop88(30,10,0.5,1,'MBB','coarse') and mainTop88(60,20,0.5,1,'MBB','finer') )

top88 cases using the same comutational times as each of the 12 EMTO cases ( mainTop88(70,70,0.5,1,'Lshape','coarse'), mainTop88(88,88,0.5,1,'Lshape','coarse'), mainTop88(140,140,0.5,1,'Lshape','coarse'),mainTop88(122,122,0.5,1,'Lshape','finer'), mainTop88(134,134,0.5,1,'Lshape','finer'), mainTop88(280,280,0.5,1,'Lshape','finer') and mainTop88(120,40,0.5,1,'MBB','coarse'), mainTop88(150,50,0.5,1,'MBB','coarse'), mainTop88(231,77,0.5,1,'MBB','coarse'),mainTop88(120,40,0.5,1,'MBB','finer'), mainTop88(150,50,0.5,1,'MBB','finer'), mainTop88(231,77,0.5,1,'MBB','finer') respectively).

Fig 16 is obtained by running the file compFelem.m

Fig 17 is obtained by running the files compFpenalL.m, compFpenalMBB.m, compFpenalCanti.m (requires a long computational time)


# Replication of results of part 4.2:

Figure 18 can be obtained through the command mainMulti(100,40,0.5,'volfrac',0,'Canti') and stopping before line 23 (to avoid the total design evaluation). Line 6 of topMulti must be changed to "rmin = 2;" first.

In order to run the following examples (with cells using only 4 transmission zones), it is necessary to first download the structural database on Mendeley : https://data.mendeley.com/datasets/pvwyj9hnrb/1 (database of microstructures for cells with 4 transmission zones). For these examples, it is also necessary to change lines 9-13 in totalDesign.m to "load('DB4stru1.mat')"  "load('DB4stru2.mat')"  ...   "load('DB4stru5.mat')"  and to change line 15 in topMulti to "load('4TZdatabase32-32-32.mat')"

To obtain figure 19a, it is necessary to first change lines 8 and 9 in topMulti so that they read "xMin = 0.49" and "xMax = 0.51". Then the design can be obtained by the command mainMulti(50,20,0.5,'volfrac',0,'Canti') and stopping before line 23 (to avoid the total design evaluation).

To obtain figure 19b, it is necessary to first change lines 8 and 9 in topMulti so that they read "xMin = 0" and "xMax = 0.6". Then the design can be obtained by the command mainMulti(50,20,0.5,'volfrac',0,'Canti') and stopping before line 23 (to avoid the total design evaluation).

To obtain figure 20a, it is necessary to first change lines 118 and 119 in topMulti so that they read "xmin = [xMin*ones(nele,1); 0.99*ones(nele,1); 0.99*ones(nele,1); 0.49*ones(nele,1)];" and "xmax = [xMax*ones(nele,1); ones(nele,1); ones(nele,1); 0.51*ones(nele,1)];". Then the design can be obtained by the command mainMulti(100,40,0.5,'volfrac',0,'Canti') and stopping before line 23 (to avoid the total design evaluation). Line 6 of topMulti must be changed to "rmin = 2;" first.

To obtain figure 20c, it is necessary to first change lines 118 and 119 in topMulti so that they read "xmin = [xMin*ones(nele,1); 0.99*ones(nele,1); 0.99*ones(nele,1); zeros(nele,1)];" and "xmax = [xMax*ones(nele,1); ones(nele,1); ones(nele,1); ones(nele,1)];". Then the design can be obtained by the command mainMulti(100,40,0.5,'volfrac',0,'Canti') and stopping before line 23 (to avoid the total design evaluation). Line 6 of topMulti must be changed to "rmin = 2;" first.


The codes needed to create the databases are still been cleaned and commented and will be publisher here soon.

# References
[1] Svanberg, Krister. "MMA and GCMMA, versions September 2007." Optimization and Systems Theory 104 (2007).
