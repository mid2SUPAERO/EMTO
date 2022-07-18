
disp('Creating Example #1');
%=========================================================================
% Example 1
% Simple cloud of points.
%=========================================================================

FID = dxf_open('example1_points.dxf');
% FID is a structure containing handle to DXF file and parameters that
% are used by remaining routines. DXFLib is a 'state' library. That means
% that certain values of parameters (e.g. color, layer) are preserved 
% between following callings to various routines unless they are changed. 
% By default, the color is ACI color 255 (white) and the layer
% number is 0. You can modify state parameters by dxf_set routine.

% Set up different color and layer. NOTE that DXF_SET always returns FID 
% structure back to you!!! You must always use the DXF_SET in the 
% following way in order to preserve changes made to the 'state' 
% parameters.

% We set current Color to yellow and current layer to 20. This will be 
% used in future calls to any DXF routin until changed.
FID = dxf_set(FID,'Color',[1 1 0],'Layer',20);

% Produce a cloud of points.
dxf_point(FID,10*rand(1,2000),10*rand(1,2000),10*rand(1,2000));

% Close DXF file.
dxf_close(FID);

disp('Creating Example #2');
%=========================================================================
% Example 2
% Polylines.
%=========================================================================

% We generate now a simple 'snail'. Remember that DXF_POLYLINE draws
% ONE line per column (similar to e.g. MATLAB's line.m function). Here,
% we only use one column vector.

FID = dxf_open('example2_polylines.dxf');
RADIUS = 5:-5/360:0;
X = zeros(size(RADIUS'));
Y = X; Z = X;
k = 0;
for radius = RADIUS
  X(k+1) = radius*cos(k*5*pi/180);
  Y(k+1) = radius*sin(k*5*pi/180);
  k = k + 1;
end

% X,Y,Z are all column vectors of the same size. One line will be drawn
% then by the following function.
dxf_polyline(FID,X,Y,Z);
dxf_close(FID);


disp('Creating Example #3');
%=========================================================================
% Example 3
% Simple polymesh.
%=========================================================================

% Open DXF File.
FID = dxf_open('example3_polymesh.dxf');
FID = dxf_set(FID,'Color',[1 1 0],'Layer',10);

% MATLAB calls to general mesh of trianges from the very-famous MATLAB's
% peaks.m routine. Then we convert it to patch structure using surf2patch.
[x,y,z] = peaks; z = z/5;
fvc = surf2patch(x,y,z,'triangles');

% fvc is a structure containing vertices and faces. We use these matrices
% to create a polymesh.
dxf_polymesh(FID, fvc.vertices, fvc.faces);

dxf_close(FID);

disp('Creating Example #4');
%=========================================================================
% Example 4
% Primitives.
%=========================================================================
FID = dxf_open('example4_primitives.dxf');

% DXF_PRIMITIVE creates 3D primitives at specified points (X,Y,Z). 
% Additionally, we can specify the size of each primitive and its color.
% Here we create for differnt types of primites at random locations.
% Notice that because you specify color directly in the DXF_PRIMITIVE
% routines, the color state variable is ignored.

FID = dxf_set(FID,'Layer',1); % We put each family to different layers.
FID = dxf_primitive(FID,'triangle',rand(1,10)*20-10, ...
  rand(1,10)*20-10,rand(1,10)*20-10,rand(1,10)*3,1:10);
FID = dxf_set(FID,'Layer',2);
FID = dxf_primitive(FID,'box',rand(1,10)*20+20, ...
  rand(1,10)*20+20,rand(1,10)*20-10,rand(1,10)*3,1:10);

% For the last-but-one family we use the common size equal to 5.
FID = dxf_set(FID,'Layer',3);
FID = dxf_primitive(FID,'tetrahedron',rand(1,10)*20-10, ...
  rand(1,10)*20+20,rand(1,10)*20-10,5,1:10);

% However, for the last family we specify the color using DXF_SET routine.
FID = dxf_set(FID,'Layer',4,'Color',[0 1 0]);
FID = dxf_primitive(FID,'sphere',rand(1,10)*20+20, ...
  rand(1,10)*20-10,rand(1,10)*20-10,rand(1,10)*3);
dxf_close(FID);


disp('Creating Example #5');
%=========================================================================
% Example 5
% Displaying simple text
%=========================================================================

% This example creates a simple text. You can specify different properties
% of the text and either pass it directly to DXF_TEXT routine (in this 
% way, these properties will be used for the printed text or you can
% specify text properties using DXF_SET routine (this has permanent effect
% for all future calls to DXF_TEXT routine).

FID = dxf_open('example5_simple_text.dxf');
FID = dxf_set(FID,'Color',[1 1 1]);

% Just a simple flat text.
dxf_text(FID,0,0,0,'The quick brown fox jumps over a lazy dog', ...
  'TextHeight',1);

% Change thickness to 1 (default 0). Notice that text height property
% will be used only for the calls to DXF_TEXT in the loop, but not for
% the last call to DXF_TEXT.
FID = dxf_set(FID,'Color',[1 1 0],'TextThickness',1);
for i=1:10
  dxf_text(FID,2*i,5,0,i,'TextHeight',5);
end  

% Let's change to color only. Here we use structure array to output the
% text. 
FID = dxf_set(FID,'Color',[0 1 1]);
dxf_text(FID,[5 5 5 5],[2 3 4 5],[0 0 0 0],{'Quick','Brown','Fox','Jumps'});
dxf_close(FID);


disp('Creating Example #6');
%=========================================================================
% Example 6
% Text Alignment
%=========================================================================

% This example displays simple text and align it.
FID = dxf_open('example6_text_alignment.dxf');
for y=0:4:12
  for x=0:4:8
    FID = dxf_set(FID,'Color',[1 1 1],'TextAlignment',x/4,'TextVAlignment',y/4);
    dxf_text(FID,x,y,0,'A');
    FID = dxf_set(FID,'Color',2);
    dxf_marker(FID,'+',x,y,0,1);
  end
end
dxf_close(FID);


disp('Creating Example #7');
%=========================================================================
% Example 7
% ACI DXF colors - Playing with DXF_POLYMESH and DXF_TEXT together.
%=========================================================================

% In most calls to DXFLib you can specify either RBG color or so-called 
% ACI color. RGB colors are always automatically converted to the closest
% matching ACI color. This example plots whole ACI color table.

FID = dxf_open('example7_ACIcolors.dxf');
i = 1;
for x=1:16
  for y=(1:16)*2
    FID = dxf_set(FID,'Color',i);
    dxf_polymesh(FID,[x y 0; x+0.9 y 0; x+0.9 y+0.9 0; x y+0.9 0],[1 2 3; 1 3 4]);
    FID = dxf_set(FID,'Color',255);
    dxf_text(FID,x,y+1,0,i,'TextHeight',0.3);
    i = i + 1;
  end
end
dxf_close(FID);

disp('Creating Example #8');
%=========================================================================
% Example 8
% Colormaps and Layers
%=========================================================================

% This example shows that conversion between RGB and ACI colors is 
% sometimes a bit tricky. Not all colormaps available in MATLAB are 
% correcly displayed in DXF ACI colors. Don't be surprised!

FID = dxf_open('example8_colormaps.dxf');
CMAP1 = jet(50);
CMAP2 = hot(50);
CMAP3 = hsv(50);
CMAP4 = copper(50);
k = 1;
for x=-25:24
  FID = dxf_set(FID,'Color',CMAP1(k,:),'Layer',1);
  y = 0;
  dxf_polymesh(FID,[x y 0; x+0.9 y 0; x+0.9 y+0.9 0; x y+0.9 0],[1 2 3; 1 3 4]);
  FID = dxf_set(FID,'Color',CMAP2(k,:),'Layer',2);
  y = 1;
  dxf_polymesh(FID,[x y 0; x+0.9 y 0; x+0.9 y+0.9 0; x y+0.9 0],[1 2 3; 1 3 4]);
  FID = dxf_set(FID,'Color',CMAP3(k,:),'Layer',3);
  y = 2;
  dxf_polymesh(FID,[x y 0; x+0.9 y 0; x+0.9 y+0.9 0; x y+0.9 0],[1 2 3; 1 3 4]);
  FID = dxf_set(FID,'Color',CMAP4(k,:),'Layer',4);
  y = 3;
  dxf_polymesh(FID,[x y 0; x+0.9 y 0; x+0.9 y+0.9 0; x y+0.9 0],[1 2 3; 1 3 4]);
  k = k + 1;
end
dxf_close(FID);

disp('Creating Example #9');
%=========================================================================
% Example 9
% Colored polymesh.
%=========================================================================

% This example is a bit tricky. This is because apparently the DXF format 
% does not support per-vertex color matrix (what is the typical output 
% from MATLAB's surf2patch function). Therefore, we have to prepare our 
% own PER-FACE color matrix using Z coordinates. 

[X,Y,Z] = peaks(100);
fvc = surf2patch(X,Y,Z/5,'triangles'); % re-meshing to triangles.
F = fvc.faces;
V = fvc.vertices; 
% we cannot use C=fvc.colors as it is per-vertex color matrix which is 
% apparently NOT supported by DXF. Therefore, we create per-face matrix 
% of colors.
C = mean([V(F(:,1),3) V(F(:,2),3) V(F(:,3),3)],2);

% simple scaling of calculated C values into range 1-256 (indexes into 
% colormap autumn)
C = (C - min(C(:))) ./ (max(C(:)) - min(C(:)));
C = 1 + round(C*255) ;
CMAP = jet(256);
C = CMAP(C,:); % now we have (N faces x 3) color matrix.
C = dxf_rgb2aci(C); % convert it to ACI coloring scheme.

FID = dxf_open('example9_polymesh_colored.dxf');
dxf_polymesh(FID,V,F,C);
dxf_close(FID);







