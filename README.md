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


The codes needed to run the examples in part 4.2 and to create the database are still being cleaned and will be published here soon.

# References
[1] Svanberg, Krister. "MMA and GCMMA, versions September 2007." Optimization and Systems Theory 104 (2007).
