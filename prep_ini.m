function []=prep_ini(filOut);

gcmfaces_global;

nfloats=300;
r1=[nfloats -1 0 0 0 nfloats 0 0 -1]';

npart=[1:nfloats];
tstart=3600*ones(1,nfloats);

m=convert2vector(mygrid.mskC(:,:,1));
x=convert2vector(mygrid.XC);
y=convert2vector(mygrid.YC);
ii=find(~isnan(m));
jj=randsample(ii,nfloats);
ipart=x(jj)';
jpart=y(jj)';
kpart=mygrid.RC(20)*ones(1,nfloats);
%kpart=0*ones(1,nfloats);
kfloat=0*ones(1,nfloats);
iup=-1*ones(1,nfloats);
itop=0*ones(1,nfloats);
tend=-1*ones(1,nfloats);

rA=[npart;tstart;ipart;jpart;kpart;kfloat;iup;itop;tend];
var=[r1 rA];

dirOut='./';
fid=fopen([dirOut filOut],'w','b'); fwrite(fid,var,'real*8'); fclose(fid);

