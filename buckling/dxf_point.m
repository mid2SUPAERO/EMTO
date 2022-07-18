function dxf_point(FID, X, Y, Z, varargin)
%DXF_POINT Store points in DXF file.
%   DXF_POINT(FID, X, Y, Z) writes 3D points into DXF file. 
%   FID is a valid DXFLIB structure created with DXF_OPEN routine. 
%   X, Y and Z are vectors or matrices of the same size containing 
%   coordinates of points in 3D space.
%   
%   DXF_POINT(..., COLOR) where COLOR is either n-by-1 ACI color vector or
%   n-by-3 RGB color matrix allows to specify color for each individual 
%   point.
%
%   See also DXF_OPEN, DXF_CLOSE, DXF_RGB2ACI, DXF_ACI2RGB, DXF_POLYLINE.

%   Copyright 2008-2011 Grzegorz Kwiatek
%   $Revision: 1.3.0 $  $Date: 2011.11.17 $

try

  if nargin == 5
    % color information included
    C = varargin{1};
    if size(C,2) == 3
      C = dxf_rgb2aci(C);
    else
      throw(MException('dxflib:dxf_point', 'Color vector must be m-by-3 or m-by-1.'));
    end
    C = C(:);
  elseif nargin == 4
  else
    throw(MException('dxflib:dxf_point', 'Inapropriate number of input arguments.'));
  end
  
  X = X(:);
  Y = Y(:);
  Z = Z(:);
  
  if FID.show
    set(gca,'NextPlot','add');
    if nargin == 4
      % Only one color per whole sequence.
      plot3(X,Y,Z,'.','Color',dxf_aci2rgb(FID.color));
    elseif nargin == 5
      % Color per point.
      scatter3(X,Y,Z,4,dxf_aci2rgb(C));
    end
    set(gca,'NextPlot','replace');
  end

  if FID.dump
    if nargin == 4
      for i=1:length(X)
        fprintf(FID.fid,'0\n');
        fprintf(FID.fid,'POINT\n');
        dxf_print_layer(FID);
        dxf_print_point(FID,0,X(i),Y(i),Z(i));
      end 
    else
      currentcolor = FID.color;
      for i=1:length(X)
        fprintf(FID.fid,'0\n');
        fprintf(FID.fid,'POINT\n');
        FID.color = C(i);
        dxf_print_layer(FID);
        dxf_print_point(FID,0,X(i),Y(i),Z(i));
      end
      FID.color = currentcolor;
    end
  end
  
catch exception
  if FID.fid >= 0
    fclose(FID.fid);
  end
  rethrow(exception);
end