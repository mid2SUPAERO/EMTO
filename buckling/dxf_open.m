function FID = dxf_open(fname) 
%DXF_OPEN Open DXF file.
%   Fid = DXF_OPEN(fname) opens DXF file for writing and writes the DXF 
%   file header. The function returns the matlab structure 'Fid' with 
%   various parameters used later by other drawing functions. One must 
%   use this structure in the subsequent calls to drawing routines.
%   
%   REMARKS
%     The assumed units are meters.
%   
%   See also DXF_CLOSE

%   Copyright 2010-2011 Grzegorz Kwiatek
%   $Revision: 1.1.4 $  $Date: 2011.11.15 $

try
  
  fid = fopen(fname,'w');

  % Setup default values.
  FID.filename = fname;
  FID.fid = fid;
  FID.show = false;
  FID.dump = true;
  
  FID.layer = 0;
  FID.color = 255;
  FID.textheight = 1;  
  FID.textrotation = 0;  
	FID.textthickness = 0;  
	FID.textalignment = 0;  
	FID.textvalignment = 0;  
	FID.textextrusion = [0 0 1];  
	FID.textobliqueangle = 0;  

  fprintf(fid,'0\nSECTION\n');
  fprintf(fid,'2\nHEADER\n');
  fprintf(fid,'9\n$ACADVER\n1\nAC1006\n'); % Default units: meters.
  fprintf(fid,'9\n$INSUNITS\n70\n6\n'); % Default units: meters.
  fprintf(fid,'0\nENDSEC\n');

  % Start entities or produce TABLE first.
  %if nargin ~= 1
  %  dxf_layertable(FID, varargin);
  %end
  
  % Dump entities section.
  fprintf(FID.fid,'0\nSECTION\n');
  fprintf(FID.fid,'2\nENTITIES\n');

catch exception
  if FID.fid >= 0
    fclose(FID.fid);
  end
  rethrow(exception);
end
