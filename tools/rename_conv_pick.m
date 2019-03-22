
for ii=1:96;
  filIn=sprintf('%s/pickup_flt1/pickup_flt.0000008772.%03d.001.data',pwd,ii);
  filOut=sprintf('%s/init_flt2/init_flt.%03d.001.data',pwd,ii);
  tmp1=read2memory(filIn,[],64);
  write2file(filOut,tmp1,32);
end;

