function dxf_print_layer(FID)
%DXF_PRINT_LAYER Dump entity properties.
%   Internal function: Not usable directly.
%
%   Copyright 2010-2011 Grzegorz Kwiatek.
%   $Revision: 1.0.3 $  $Date: 2011.08.25 $%

try
  fprintf(FID.fid,'8\n');  % layer, default 0
  if isnumeric(FID.layer)
    fprintf(FID.fid,'%d\n', FID.layer);  
  else
    fprintf(FID.fid,'%s\n', FID.layer);  
  end
  
  % Dump color.
  fprintf(FID.fid,'62\n%d\n',FID.color); % color group code.

catch exception
  if FID.fid >= 0
    fclose(FID.fid);
  end
  rethrow(exception);
end