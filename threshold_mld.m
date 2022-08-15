function mld_thr_dens = threshold_mld(depth, dens)
%阈值法计算混合层深度
%x为深度，单位dbar
%y为位势密度，单位kg/m^3
val=0.03;
n=find(depth==10);
idx = find((dens-dens(n) )> val, 1);
mld_thr_dens=depth(idx);
end