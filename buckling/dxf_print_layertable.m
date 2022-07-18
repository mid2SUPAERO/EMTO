function dxf_print_layertable(FID, LAYERS)
%DXF_PRINT_LAYERTABLE Print table containing names of layer.
%   Internal function: Not usable directly.
%
%   Copyright 2011 Grzegorz Kwiatek
%   $Revision: 1.0.0 $  $Date: 2011.11.17 $

try
  fprintf(FID.fid,'0\n');  
  fprintf(FID.fid,'SECTION\n');  
  fprintf(FID.fid,'2\n');  
  fprintf(FID.fid,'TABLES\n');  

  fprintf(FID.fid,'0\n');  
  fprintf(FID.fid,'TABLE\n');  
  fprintf(FID.fid,'2\n');  
  fprintf(FID.fid,'LAYER\n');  
  fprintf(FID.fid,'70\n');  
  fprintf(FID.fid,'%d\n', length(LAYERS)+1);  

  for i=1:length(LAYERS)
    fprintf(FID.fid,'0\n');  
    fprintf(FID.fid,'LAYER\n');  
    fprintf(FID.fid,'2\n');  
    fprintf(FID.fid,'%s\n', LAYERS{i}); % Layer name 
    fprintf(FID.fid,'70\n');  
    fprintf(FID.fid,'64\n'); % Layer flag.
    fprintf(FID.fid,'62\n');  
    fprintf(FID.fid,'2\n'); % Layer color.
    fprintf(FID.fid,'6\n');  
    fprintf(FID.fid,'CONTINUOUS\n'); % Layer linetype  
  end
  
  fprintf(FID.fid,'0\n');
  fprintf(FID.fid,'ENDTAB\n');  
  fprintf(FID.fid,'0\n');  
  fprintf(FID.fid,'ENDSEC\n');  
catch exception
  if FID.fid >= 0
    fclose(FID.fid);
  end
  error(exception.message);
end


