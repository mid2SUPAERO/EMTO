function FID = dxf_primitive(FID, primitivetype, X, Y, Z, varargin)
%DXF_PRIMITIVE Draw 3D primitives.
%   DXF_PRIMITIVE(FID, primitivetype, X, Y, Z) draws primitives at 
%   coordinates specified by three vectors X, Y and Z. The primitive
%   may be of following type:
%     'box','+','triangle','sphere','tetrahedron'
%
%   DXF_PRIMITIVE(..., SIZE) where SIZE is the matrix of the same 
%   size as X, Y or Z vectors allow to manipulate the size of each
%   primitive (by default all primitives are of size 1)
%   
%   DXF_PRIMITIVE(..., SIZE, COLOR) where COLOR is m-by-1 ACI color vector
%   or m-by-3 RBG color matrix allows to draw every primitive with different
%   color.
%   
%   REMARKS
%     Size of each primitive is approximately 1 meter in all directions.
%   
%   See also DXF_MARKER

%   Copyright 2010-2011 Grzegorz Kwiatek
%   $Revision: 1.1.1 $  $Date: 2011.10.28 $

X=X(:);
Y=Y(:);
Z=Z(:);

COLORS = [];
SIZES = [];

if nargin == 6
  SIZES = varargin{1};
end

if nargin == 7
  SIZES = varargin{1};
  COLORS = varargin{2};
end

if isempty(SIZES)
  SIZES = ones(size(X));
elseif isscalar(SIZES)
  SIZES = SIZES * ones(size(X));
elseif size(SIZES,2) == 3 && size(SIZES,1) == 1
  SIZES = repmat(SIZES,size(X,1),1);
end

if isscalar(COLORS)
  COLORS = COLORS*ones(size(X));
elseif size(COLORS,1) == 1 && size(COLORS,2) == 3
  COLORS = repmat(COLORS,size(X,1),1);
elseif size(COLORS,1) == 1 && size(COLORS,2) ~= 3
  COLORS = COLORS(:);
end
  
try
  
  switch lower(primitivetype)
    case 'box'
      VERTICES = [1 1 1; 1 -1 1; -1 -1 1; -1 1 1; 1 1 -1; 1 -1 -1; -1 -1 -1; -1 1 -1]/2;
      FACES = [1 2 3 4; 5 6 7 8; 1 5 6 2; 2 6 7 3; 3 7 8 4; 4 8 5 1];
      nv = 8;
    case '+'
      VERTICES = [1 1 0; 1 -1 0; -1 -1 0; -1 1 0; ...
                  1 0 1; 1 0 -1; -1 0 -1; -1 0 1; ... 
                  0 1 1; 0 1 -1; 0 -1 -1; 0 -1 1];
      FACES = [1 2 3 4; 5 6 7 8; 9 10 11 12];
      nv = 12;
    case 'triangle'
      h = sqrt(3)/2;
      x = sqrt(6)/3;
      VERTICES = [0 2*h/3 -x/3; 0.5 -h/3 -x/3; -0.5 -h/3 -x/3; 0 0 x*2/3];
      FACES = [1 2 3; 1 2 4; 2 3 4; 3 1 4];
      nv = 4;
    case 'sphere'
      [x,y,z] = sphere(11);
      fvc = surf2patch(x,y,z,'triangles');
      VERTICES = fvc.vertices;
      FACES = fvc.faces;
      nv = size(VERTICES,1);
    case 'tetrahedron'
      FACES = [1 2 3;1 3 4;1 4 2;4 3 2];
      x0 = -0.5; dx= 1;
      y0 = -0.5; dy= 1;
      z0 = -0.5; dz= 1;
      VERTICES = [x0 y0 z0; x0+dx y0+dy z0; x0+dx y0 z0+dz; x0 y0+dy z0+dz];  
      nv = size(VERTICES,1);
    case 'planez'
      VERTICES = [1 1 0; 1 -1 0; -1 -1 0; -1 1 0];
      FACES = [1 2 3 4];
      nv = size(VERTICES,1);
  end

  for i=1:length(X)
    if ~isempty(COLORS)
      FID = dxf_set(FID,'Color',COLORS(i,:));
    end
    if (size(SIZES,2) == 1 && size(SIZES,1) == length(X)) ...
     ||(size(SIZES,1) == 1 && size(SIZES,2) == length(X))
      FID = dxf_polymesh(FID, VERTICES.*SIZES(i)+repmat([X(i) Y(i) Z(i)],nv,1), FACES);
    elseif size(SIZES,2) == 3
      FID = dxf_polymesh(FID, VERTICES.*repmat(SIZES(i,:),size(VERTICES,1),1)+repmat([X(i) Y(i) Z(i)],nv,1), FACES);
    elseif size(SIZES,1) == 3
      SIZES = SIZES';
      FID = dxf_polymesh(FID, VERTICES.*repmat(SIZES(i,:),size(VERTICES,1),1)+repmat([X(i) Y(i) Z(i)],nv,1), FACES);
    end
  end

catch exception
  if FID.fid >= 0
    fclose(FID.fid);
  end
  rethrow(exception);
end
