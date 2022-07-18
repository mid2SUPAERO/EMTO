function FID = dxf_set(FID, varargin)
%DXF_SET Set property.
%   DXF_SET(FID, 'PropertyName', 'PropertyValue', ...) sets up property
%   in DXF file.
%
%   Properties:
%   'Layer' - Layer number, followed by a scalar value in a range 0-256.
%   'Color' - Current color, followed either by a scalar value in a range
%             1-255 (ACI color) or MATLAB color vector [R G B], where 
%             R,G,B ranges 0-1. [0 0 0] is black, [1 1 1] is white, 
%             [1 0 0] is pure red, [0 1 0] is pure green and [0 0 1] is 
%             pure blue. Also ACI value 0 represent BYBLOCK and 256 represent
%             BYLAYER (currently both values are not used!)
%   
%   Copyright 2010-2011 Grzegorz Kwiatek.
%   $Revision: 1.1.2 $  $Date: 2011.09.06 $

p = inputParser;
p.addRequired('FID', @isstruct);
p.addParamValue('Layer', FID.layer, @(x) ischar(x) || (isnumeric(x) && x > 0) );  
p.addParamValue('Color', FID.color, @(x) (isscalar(x) && x>=0 && x<=256) || (isvector(x) && size(x,1)==1 && size(x,2) ==3) );  
p.addParamValue('TextHeight', FID.textheight, @(x)x >= 0);  
p.addParamValue('TextRotation', FID.textrotation, @(x)x >= 0);  
p.addParamValue('TextThickness', FID.textthickness, @(x)x >= 0);  
p.addParamValue('TextAlignment', FID.textalignment, @(x)x >= 0);  
p.addParamValue('TextVAlignment', FID.textvalignment, @(x)x >= 0);  
p.addParamValue('TextExtrusion', FID.textextrusion, @(x)(isvector(x) && size(x,1)==1 && size(x,2) ==3));  
p.addParamValue('TextObliqueAngle', FID.textobliqueangle, @(x)x >= 0);  
p.parse(FID, varargin{:});

FID.layer = p.Results.Layer;
if size(p.Results.Color,2) == 3
  FID.color = dxf_rgb2aci(p.Results.Color);
else
  FID.color = p.Results.Color;
end
FID.textheight = p.Results.TextHeight;  
FID.textrotation = p.Results.TextRotation;  
FID.textthickness = p.Results.TextThickness;  
FID.textalignment = p.Results.TextAlignment;  
FID.textvalignment = p.Results.TextVAlignment;  
FID.textextrusion = p.Results.TextExtrusion;  
FID.textobliqueangle = p.Results.TextObliqueAngle;  
  
