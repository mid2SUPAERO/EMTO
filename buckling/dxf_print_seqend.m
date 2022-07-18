function FID = dxf_print_seqend(FID)
%DXF_PRINT_SEQEND Dump entity properties.
%   Internal function: Not usable directly.
%
%   Copyright 2011 Grzegorz Kwiatek.
%   $Revision: 1.0.0 $  $Date: 2011.08.25 $%

try 
  fprintf(FID.fid,'0\nSEQEND\n8\n%d\n',FID.layer);
catch exception
  if FID.fid >= 0
    fclose(FID.fid);
  end
  rethrow(exception);
end  