function mld_thr_dens = threshold_mld(depth, dens)
%��ֵ�������ϲ����
%xΪ��ȣ���λdbar
%yΪλ���ܶȣ���λkg/m^3
val=0.03;
n=find(depth==10);
idx = find((dens-dens(n) )> val, 1);
mld_thr_dens=depth(idx);
end