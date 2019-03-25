
dirIn='nctiles_climatology/';
dirOut='run/diags/';

p=genpath('gcmfaces/'); addpath(p);
gcmfaces_global; if isempty(mygrid); grid_load; end;

varList={'UVELMASS','VVELMASS','WVELMASS','THETA','SALT','ETAN'};
filList={'trsp_3d_set1','trsp_3d_set1','trsp_3d_set1','state_3d_set1','state_3d_set1','state_2d_set1'};
recList=[1:3 1:2 1];
for vv=1:length(varList);
nam=varList{vv};
fldIn=read_nctiles([dirIn nam '/' nam]);
fldOut=rdmds2gcmfaces([dirOut filList{vv} '*'],NaN,'rec',recList(vv));

if length(size(fldIn{1}))==4;
msk=1+0*fldIn(:,:,:,1); s4=size(fldOut{1},4);
fldOut=fldOut.*repmat(msk,[1 1 1 s4]);
else;
msk=1+0*fldIn(:,:,1); s3=size(fldOut{1},3);
fldOut=fldOut.*repmat(msk,[1 1 s3]);
end;

zmIn=calc_zonmean_T(fldIn);
zmOut=calc_zonmean_T(fldOut);
faceoneIn=squeeze(nanmean(fldIn{1},1));
faceoneOut=squeeze(nanmean(fldOut{1},1));

if vv==4||vv==5;
figure;
tmp1=squeeze(zmIn(:,1,1:12)); tmp1=[tmp1 tmp1]; tmp2=squeeze(zmOut(:,1,1:24));
subplot(2,1,1); plot(tmp1(1:10:end,:)','rx-'); hold on; plot(tmp2(1:10:end,:)','b.-');
tmp1=squeeze(zmIn(:,40,1:12)); tmp1=[tmp1 tmp1]; tmp2=squeeze(zmOut(:,40,1:24));
subplot(2,1,2); plot(tmp1(1:10:end,:)','rx-'); hold on; plot(tmp2(1:10:end,:)','b.-');
elseif vv<4;
figure;
tmp1=squeeze(faceoneIn(:,1,1:12)); tmp1=[tmp1 tmp1]; tmp2=squeeze(faceoneOut(:,1,1:24));
subplot(2,1,1); plot(tmp1(1:10:end,:)','rx-'); hold on; plot(tmp2(1:10:end,:)','b.-');
tmp1=squeeze(faceoneIn(:,40,1:12)); tmp1=[tmp1 tmp1]; tmp2=squeeze(faceoneOut(:,40,1:24));
subplot(2,1,2); plot(tmp1(1:10:end,:)','rx-'); hold on; plot(tmp2(1:10:end,:)','b.-');
elseif vv==6;
figure;
tmp1=squeeze(zmIn(:,1:12)); tmp1=[tmp1 tmp1]; tmp2=squeeze(zmOut(:,1:24));
plot(tmp1(1:10:end,:)','rx-'); hold on; plot(tmp2(1:10:end,:)','b.-');
else;
keyboard;
end;

end;



