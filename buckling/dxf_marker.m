function FID = dxf_marker(FID, markertype, X, Y, Z, varargin)
%DXF_MARKER Draw a set of markers.
%   DXF_MARKER(FID, markertype, X, Y, Z) writes markers into DXF file. 
%    FID is a valid DXFLIB structure created with DXF_OPEN routine. 
%    markertype is a valid marker type of the following type:
%     'o' - circle,
%     'x' - x sign,
%     '+' - plus sign,
%     '^' - triangle.
%    X, Y and Z are vectors or matrices of the same size containing 
%    coordinates of points in 3D space. The default size of marker is 1.
%
%   DXF_MARKER(..., SIZE) allows to specify size of marker(s). If SIZE is 
%    a scalar, all markers have the same size according to the SIZE value 
%    specified. If SIZE is a matrix of size equal to X, Y or Z, each
%    marker is rescaled according to corresponding SIZE value.
%
%   See also DXF_POLYLINE, DXF_POINT, DXF_PRIMITIVE.

%   Copyright 2008-2011 Grzegorz Kwiatek
%   $Revision: 1.0.3 $  $Date: 2011.11.17 $

try

  % align matrices
  X=X(:);
  Y=Y(:);
  Z=Z(:);

  if nargin == 5
    SIZE = ones(size(X));
  elseif nargin == 6
    SIZE = varargin{1};
  end
  
  if isscalar(SIZE)
    SIZE = SIZE * ones(size(X));
  end
  
  switch lower(markertype)
    case 'o'
      for i=1:length(X)
        fprintf(FID.fid,'0\n');
        fprintf(FID.fid,'CIRCLE\n');
        dxf_print_layer(FID);
        dxf_print_point(FID,0,X(i),Y(i),Z(i));
        fprintf(FID.fid,'40\n');  
        fprintf(FID.fid,[sprintf('%d',SIZE(i)) '\n']);   
      end
    case 'x'
      a = sqrt(2);
      for i=1:length(X)
        XX = X(i) + [-a -a; a a]*SIZE(i)/2;
        YY = Y(i) + [ a -a; -a a]*SIZE(i)/2;
        ZZ = Z(i) + [0 0; 0 0];
        dxf_polyline(FID, XX, YY, ZZ);
      end
    case '+'
      for i=1:length(X)
        a = SIZE(i) / 2 ;
        XX = X(i) + [0 a; 0 -a];
        YY = Y(i) + [-a 0; a 0];
        ZZ = Z(i) + [0 0; 0 0];
        dxf_polyline(FID, XX, YY, ZZ);
      end
    case '^'
      for i=1:length(X)
        h = sqrt(3) / 2 * SIZE(i);
        a = SIZE(i);
        XX = X(i) + [-0.5*a 0 0.5*a -0.5*a]';
        YY = Y(i) + [-h/3 2*h/3 -h/3 -h/3]';
        ZZ = Z(i) + [0 0 0 0]';
        dxf_polyline(FID, XX, YY, ZZ);
      end
  end

catch exception
  if FID.fid >= 0
    fclose(FID.fid);
  end
  rethrow(exception);
end
