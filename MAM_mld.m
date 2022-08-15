function [mld_MAM_t mld_MAM_dens  QI_MAM_dens QI_MAM_t] = ...
    MAM_mld(temp,dens,depth)
% This programg calculate the mix layer depth from the Argo profile data
% And the method is Maximum Angle method
% Reference:
% Peter C.Chu and Chenwu Fan,2011,Maximum angle method for
% determining  Mix Layer Depth from seaglider data.,
% Journal of Oceanogr,(67):219-230
% clear all;
% tic;
mld_MAM_t=10.;
mld_MAM_dens=10.;
% QI_MAM_t=1.;
% QI_MAM_dens=1.;
aa1=find(~isnan(dens)&~isnan(temp));
dens1=dens(aa1);
t1=temp(aa1);
d1=depth(aa1);

D_dens=max(dens1)-min(dens1);
aa1=min(find(dens1>=min(dens1)+D_dens*0.1));% 0.1*dens
aa2=min(find(dens1>=min(dens1)+D_dens*0.7));% 0.7*dens

m=min(aa2-aa1+1,10);
gg1=6; % 0 2 4 6 8 10
gg2=max(find(abs(dens1-dens1(gg1))<=0.3)); %%
Ang_dens=nan*zeros(length(d1),1);
Ang_t=nan*zeros(length(d1),1);
% if(gg2>max(2,gg1))
for k=max(gg1,2):gg2
    if(k<=m) j=k-1; else j=m; end
    if(k+m<=length(d1))
        P1=polyfit(d1(k-j:k),dens1(k-j:k),1);
        P2=polyfit(d1(k+1:k+m),dens1(k+1:k+m),1);
        P3=polyfit(d1(k-j:k),t1(k-j:k),1);
        P4=polyfit(d1(k+1:k+m),t1(k+1:k+m),1);
        if(1+P2(1)*P1(1)~=0)
            Ang_dens(k)=(P2(1)-P1(1))/(1+P2(1)*P1(1));
        end
        if(1+P3(1)*P4(1)~=0)
            Ang_t(k)=(P4(1)-P3(1))/(1+P4(1)*P3(1));
        end
    end
    %     end
    Ang_dens=abs(Ang_dens(find(~isnan(Ang_dens))));
    dd1=d1(find(~isnan(Ang_dens)));
    mld_MAM_dens=dd1(min(find(Ang_dens==max(Ang_dens))));
    QI_MAM_dens =QI_cal(d1,dens1,mld_MAM_dens);
    
    Ang_t=abs(Ang_t(find(~isnan(Ang_t))));
    dd2=d1(find(~isnan(Ang_t)));
    mld_MAM_t=dd2(min(find(Ang_t==max(Ang_t))));
    QI_MAM_t =QI_cal(d1,dens1,mld_MAM_t);
end
clear t1 dens1 aa1 d1 gg1 gg2


