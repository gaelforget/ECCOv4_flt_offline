function []=create_input_offline(dirIn,dirOut);
% create_input_offline(dirOut) creates input fields for MITgcm/pkg/offline
%   that will be stored into dirOut ('input_climatology/' by default).

if isempty(whos('dirIn')); dirIn=[pwd filesep 'nctiles_climatology' filesep]; end;
if isempty(whos('dirOut')); dirOut=[pwd filesep 'input_climatology' filesep]; end;
if ~isdir(dirOut); mkdir(dirOut); end;

p=genpath('gcmfaces/'); addpath(p);
gcmfaces_global; if isempty(mygrid); grid_load; end;

varList={'UVELMASS','VVELMASS','WVELMASS','THETA','SALT'};
for vv=1:length(varList);
nam=varList{vv};
fld=read_nctiles([dirIn nam '/' nam]);
fld(isnan(fld))=0;
write2file([dirOut nam '_mon.bin'],convert2gcmfaces(fld));
end;



