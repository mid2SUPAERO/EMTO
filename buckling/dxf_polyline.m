function FID = dxf_polyline(FID, X, Y, Z)
%DXF_POLYLINE Store lines in DXF file.
%   DXF_POLYLINE(FID, X, Y, Z) writes polylines into DXF file. 
%   FID is valid DXFLIB structure created with DXF_OPEN routine. 
%   X, Y and Z are matrices of the same size containing coordinates of 
%   points for polylines. One separate line per column of matrix is 
%   drawn. 
%   
%   See also DXF_OPEN, DXF_CLOSE.

%   Copyright 2011 Grzegorz Kwiatek
%   $Revision: 1.2.0 $  $Date: 2011.11.17 $

try

  if FID.show
    line(X,Y,Z,'Color',dxf_aci2rgb(FID.color));
  end
  
  if FID.dump
    for i=1:size(X,2) % for each column!

      fprintf(FID.fid,'0\n');
      fprintf(FID.fid,'POLYLINE\n');

      dxf_print_layer(FID);
      fprintf(FID.fid,'66\n');  % entities follow (not necessary)
      fprintf(FID.fid,'1\n');  
      dxf_print_point(FID,0,0.0,0.0,0.0); % dummy point before vertices

      % 8 = This is a 3D polyline
      % 16 = This is a 3D polygon mesh
      % 32 = The polygon mesh is closed in the N direction
      % 64 = The polyline is a polyface mesh

      fprintf(FID.fid,'70\n');  
      fprintf(FID.fid,'8\n');   
      dxf_print_vertex(FID, [X(:,i) Y(:,i) Z(:,i)],32);
      dxf_print_seqend(FID);
    end % for loop
  end

catch exception
  if FID.fid >= 0
    fclose(FID.fid);
  end
  rethrow(exception);
end
