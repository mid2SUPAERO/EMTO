function dxf_text(FID, X, Y, Z, Label, varargin)
%DXF_TEXT Print text.
%   DXF_TEXT(FID, X, Y, Z, Label) writes text at locations specified by
%   coordinates (X,Y,Z). Label is a cell array containing labels or 
%   numeric array.
%
%   DXF_TEXT(..., 'PropertyName',PropertyValue) allow to set up various
%   text properties. The properties can also be se using DXF_SET routine.
%   In second case, the changes to the text properties are persistent and
%   the following calls to DXF_TEXT routine will use these properties as
%   defaults.
%
%   Available properties:
%
%     'TextHeight' - height of text.
%     'TextRotation' - rotation of text.
%     'TextThickness' - thickness of text.
%     'TextAlignment' - horizontal alignment (0-2).
%     'TextVAlignment' - vertical alignment (0-3).
%     'TextExtrusion' - Extrusion vector.
%     'TextObliqueAngle' - Oblique angle.
%   
%   See also DXF_SET.

%   Copyright 2011 Grzegorz Kwiatek
%   $Revision: 1.1.2 $  $Date: 2011.09.06 $

try

  p = inputParser;
  p.addRequired('FID', @isstruct);
  p.addRequired('X', @isvector);
  p.addRequired('Y', @isvector);
  p.addRequired('Z', @isvector);
  p.addRequired('Label', @(x) iscell(x) || isnumeric(x) || ischar(x));
  
  p.addParamValue('TextHeight', FID.textheight, @(x)x >= 0);  
  p.addParamValue('TextRotation', FID.textrotation, @(x)x >= 0);  
  p.addParamValue('TextThickness', FID.textthickness, @(x)x >= 0);  
  p.addParamValue('TextAlignment', FID.textalignment, @(x)x >= 0);  
  p.addParamValue('TextVAlignment', FID.textvalignment, @(x)x >= 0);  
  p.addParamValue('TextExtrusion', FID.textextrusion, @(x)(isvector(x) && size(x,1)==1 && size(x,2) ==3));  
  p.addParamValue('TextObliqueAngle', FID.textobliqueangle, @(x)x >= 0);  
  p.addParamValue('TextNormal', 'd', @(x)any(strcmpi(x,{'x','y','z','-x','-y','-z'})));  
    
  p.parse(FID, X, Y, Z, Label, varargin{:});
  
  X = X(:);
  Y = Y(:);
  Z = Z(:);
  EX = p.Results.TextExtrusion;
  RO = p.Results.TextRotation;
  TH = p.Results.TextThickness;
  AL = p.Results.TextAlignment;
  VAL = p.Results.TextVAlignment;
  OA = p.Results.TextObliqueAngle;
  HE = p.Results.TextHeight;
  NO = p.Results.TextNormal;
  
  if length(X) == 1
    if isnumeric(Label)
      Label = num2str(Label);
    end
  else
    if ~iscell(Label) && isnumeric(Label)
      Label = num2cell(Label);
    elseif iscell(Label)
    else
      error('dxflib:dxf_text','Label must be either a vector or cell array of strings/values');
    end
  end
  
  if AL > 0 || VAL > 0
    fp = 1;
  else
    fp = 0;
  end
  if FID.dump
    for i=1:length(X)
      fprintf(FID.fid,'0\n');
      fprintf(FID.fid,'TEXT\n');
      dxf_print_layer(FID);
      if strcmpi(NO,'d')
        dxf_print_point(FID,fp,X(i),Y(i),Z(i));
      elseif strcmpi(NO,'z')
        EX = [0 0 1]; 
        dxf_print_point(FID,fp,X(i),Y(i),Z(i));
      elseif strcmpi(NO,'-z')
        EX = [0 0 -1]; 
        dxf_print_point(FID,fp,X(i),Y(i),Z(i));
      elseif strcmpi(NO,'x')
        EX = [1 0 0]; 
        dxf_print_point(FID,fp,Z(i),Y(i),X(i));
      elseif strcmpi(NO,'-x')
        EX = [-1 0 0]; 
        dxf_print_point(FID,fp,Z(i),Y(i),X(i));
      elseif strcmpi(NO,'-y')
        EX = [0 -1 0];
        dxf_print_point(FID,fp,X(i),Z(i),Y(i));
      elseif strcmpi(NO,'y')
        EX = [0 1 0];
        dxf_print_point(FID,fp,X(i),Z(i),Y(i));
      end
      fprintf(FID.fid,'210\n%d\n220\n%d\n230\n%d\n',EX); % Extrusion direction
      fprintf(FID.fid,'40\n%d\n',HE);  % Text height
      fprintf(FID.fid,'51\n%d\n',OA);  % Oblique angle
      fprintf(FID.fid,'50\n%d\n',RO);  % Text rotation
      fprintf(FID.fid,'39\n%d\n',TH);  % Thickness
      fprintf(FID.fid,'72\n%d\n',AL);  % Horizontal alignment
      fprintf(FID.fid,'73\n%d\n',VAL); % Vertical alignment
      
      if length(X) == 1
        label = Label;
      else
        if iscell(Label{i}) || isnumeric(Label{i})
          label = num2str(Label{i});
        else
          label = Label{i};
        end
      end
      fprintf(FID.fid,'1\n%s\n',label);
    end % for loop
  end
  
catch exception
  if FID.fid >= 0
    fclose(FID.fid);
  end
  rethrow(exception);
end