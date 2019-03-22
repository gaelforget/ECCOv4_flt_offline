
fid=fopen('rename_pick.sh','wt');
for ii=1:96;
fprintf(fid,'mv pickup_flt.0000008772.%03d.001.data init_flt_0000008772.%03d.001.data\n',ii,ii);
end;
fclose(fid);

