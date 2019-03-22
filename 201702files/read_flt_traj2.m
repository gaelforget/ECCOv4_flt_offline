function [flt,data,header] = read_flt_traj(varargin)
% Reads the float_trajectories files.
%
% flts=read_flt_traj(File_Names,[Worldlength],[FloatList]);
%
% inputs: File_Names is a file name
%         Worldlength (= 4 or 8) is optional
%         FloatList (= a subset of [1:n] where n is the number of floats) is the second optional argument
%
% output: flt is a structured array with fields 'time','x','y','k','u','v','t','s','p'
%         data (optional) is an array of all data points (concatenated 13x1 vectors)
%         header (optional) summarizes all output times (concatenated 13x1 vectors)
%         
% Example:
% >> [flt,data,header]=read_flt_traj('float_trajectories',4);
% >> plot( flts(3).time, flts(3).x/1e3 )
% >> for k=1:126;plot(flts(k).x/1e3,flts(k).y/1e3);hold on;end;hold off

% $Header: /u/gcmpack/MITgcm/verification/flt_example/input/read_flt_traj.m,v 1.6 2012/02/03 04:08:12 dfer Exp $
% $Name:  $

fName = varargin{1};
imax=13;                  % record size
ieee='b';                 % IEEE big-endian format
WORDLENGTH = 8;           % 8 bytes per real*8
if length(varargin)==2
   WORDLENGTH = varargin{2};
end
bytesPerRec=imax*WORDLENGTH;
rtype =['real*',num2str(WORDLENGTH)];
if length(varargin)==3;
   list_flt=varargin{3};
else;
   list_flt=[];
end;

[I]=strfind(fName,'/');
if length(I) == 0,
 bDr='';
else
 fprintf(' found Dir Sep in file name (');
 fprintf(' %i',I);
 bDr=fName(1:I(end));
 fprintf(' ) ; load files from Dir "%s"\n',bDr);
end

fls=dir([fName,'.*data']);

data=zeros(imax,0);
header=zeros(imax,0);

% Read everything
for k=1:size(fls,1)
 fid=fopen([bDr,fls(k).name],'r',ieee);
%fprintf('fid= %i\n',fid);
 nrecs=fls(k).bytes/bytesPerRec;
 ldata=fread(fid,[imax nrecs],rtype);
 fclose(fid);
 header=[header ldata(:,1)];
 data=[data ldata(:,2:end)];
 clear ldata;
end

flt=struct('numsteps',[],'time',[],'x',[],'y',[],'z',[]);
nflt=max(max(data(1,:)));
if isempty(list_flt); list_flt=[1:nflt]; end;
nflt=length(list_flt);
flt=repmat(flt,[1 nflt]);

% Sort it all out
for k=1:nflt;
 j=find( data(1,:)==list_flt(k) );
 [t,jj]=sort( data(2,j) ); j=j(jj);
 flt(k).time=data(2,j);
 flt(k).x=data( 3,j);
 flt(k).y=data( 4,j);
 flt(k).z=data( 5,j);
 flt(k).i=data( 6,j);
 flt(k).j=data( 7,j);
 flt(k).k=data( 8,j);
 flt(k).p=data( 9,j);
 flt(k).u=data(10,j);
 flt(k).v=data(11,j);
 flt(k).t=data(12,j);
 flt(k).s=data(13,j);
end

return
