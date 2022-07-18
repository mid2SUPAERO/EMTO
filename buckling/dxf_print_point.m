function dxf_print_point(FID,pointno,x,y,z)
%DXF_PRINT_POINT Dump entity properties.
%   Internal function: Not usable directly.
%
%   Copyright 2011 Grzegorz Kwiatek
%   $Revision: 1.0.0 $  $Date: 2011.08.25 $%

try
  fprintf(FID.fid,'1%1d\n%1.8g\n2%1d\n%1.8g\n3%1d\n%1.8g\n',pointno,x,pointno,y,pointno,z);
catch exception
  if FID.fid >= 0
    fclose(FID.fid);
  end
  rethrow(exception);
end
