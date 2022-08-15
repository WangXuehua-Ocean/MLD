% 生成20个站点的数据
% CALLER:  akima.m
% CALLER:  sw_ptmp.m|sw_pden.m
% CALLEE:  threshold_mld.m|GMM_mld.m|OLF_mld.m|MAM_mld.m|QI_cal.m
% CALLER:  distinguishable_colors.m
clc,clear,close all
load D:\Papers\cscd_MLD\Data\ProcessedData\dataprofile.mat %ddepth ssal tidat(图题) ttemp view
% 确认位置
dat=[];
for nn=1:20
        depth=ddepth{nn};
        temp=ttemp{nn};
        sal=ssal{nn};
        % akima插值
        xi=linspace(0,10000,5001);
        x1=min(xi(find(xi-min(depth)>0)));
        x2=min(xi(find(xi-max(depth)+2>0)));
        n=(x2-x1)/2+1;
        xi=linspace(x1,x2,n);%需要插值的位置
        temp=akima(depth,temp,xi);
        sal=akima(depth,sal,xi);
        depth=xi';
        PT = sw_ptmp(sal,temp,depth,0);%得到位势温度
        pden = sw_pden(sal,PT,depth,0);%得到位势密度
        % 求出混合层深度
        [mld_thr_dens] = threshold_mld(depth, pden);
        [mld_GMM_t mld_GMM_dens ] = GMM_mld(temp,pden,depth);
        [mld_OLF_t mld_OLF_dens ] = OLF_mld(temp,pden,depth);
        [mld_MAM_t mld_MAM_dens ] = MAM_mld(temp,pden,depth);
        dat=[dat;mld_thr_dens mld_GMM_dens mld_OLF_dens mld_MAM_dens,view{nn}];
end
bbias=dat-dat(:,5)
winter=(bbias(1,:)+bbias(5,:)+bbias(9,:)+bbias(13,:)+bbias(17,:))./5;
spring=(bbias(2,:)+bbias(6,:)+bbias(10,:)+bbias(14,:)+bbias(18,:))./5;
summer=(bbias(3,:)+bbias(7,:)+bbias(11,:)+bbias(15,:)+bbias(19,:))./5;
autumn=(bbias(4,:)+bbias(8,:)+bbias(12,:)+bbias(16,:)+bbias(20,:))./5;