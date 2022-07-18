function FID = dxf_polymesh(FID, VERTICES, FACES, varargin)
%DXF_POLYMESH Produce DXF polyface mesh from MATLAB patch data.
%   DXF_POLYMESH(FID, VERTICES, FACES) creates DXF data of polyface
%   mesh based on MATLAB patch data (vertices/faces).
%   
%   DXF_POLYMESH(..., COLOR) allows to specify color for each FACE. COLOR
%    matrix should be of size(FACES,1) (i.e. you can specify only
%    per-face color).
%   
%   See also DXF_POLYLINE.

%   Copyright 2011 Grzegorz Kwiatek
%   $Revision: 1.1.0 $  $Date: 2011.11.17 $

try
  
  if FID.show
    FVC.faces = FACES;
    FVC.vertices = VERTICES;
    if nargin == 3
      % Show mesh with a constant colour.
      FVC.facevertexcdata = repmat(dxf_aci2rgb(FID.color),size(FVC.vertices,1),1);
    else
      % Show mesh with per-face or per-vertex colouring.
      FVC.facevertexcdata = varargin{1};
    end
    h = patch(FVC);
    %lighting phong;
    set(h,'EdgeColor','none');
    %shading interp;
  end
  
  if FID.dump
    if nargin == 4
      COLOURS = varargin{1};
    end

    fprintf(FID.fid,'0\n');
    fprintf(FID.fid,'POLYLINE\n');

    dxf_print_layer(FID);
    fprintf(FID.fid,'66\n');  % entities follow (not necessary
    fprintf(FID.fid,'1\n');  
    dxf_print_point(FID,0,0.0,0.0,0.0); % dummy point before vertices

    % 8 = This is a 3D polyline
    % 16 = This is a 3D polygon mesh
    % 32 = The polygon mesh is closed in the N direction
    % 64 = The polyline is a polyface mesh

    fprintf(FID.fid,'70\n');  
    fprintf(FID.fid,'64\n');   

    % dump vertices
    if nargin == 4
      % place for per-vertex colouring, apparently it is not working
      % for DXF files.
      dxf_print_vertex(FID,VERTICES,128+64); % 64 means polyface mesh.
    else
      dxf_print_vertex(FID,VERTICES,128+64);
    end

    % dump faces
    if nargin == 4 
      % per-face colouring. The size of COLOURS matrix must be the same 
      % as the size of FACES matrix
      dxf_print_vertex(FID, FACES, 128, COLOURS);
    else
      dxf_print_vertex(FID, FACES, 128);
    end

    dxf_print_seqend(FID);
  end
catch
  fclose(FID.fid);
  rethrow(lasterror);
end
