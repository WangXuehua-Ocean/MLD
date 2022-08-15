function [mld_OLF_t mld_OLF_dens QI_OLF_t QI_OLF_dens] = ...
    OLF_mld(temp,dens,depth)
% This programg calculate the mix layer depth from the Argo profile data
% And the method is Optimal Linear Fitting
% Reference:
% Peter C.Chu and Chenwu Fan,2010,Optimal Linear Fitting
% for Objective Determination of Ocean Mix Layer Depth from Glider
% Profiles.,Journal of Atmospheric And Oceanic Technology,(0):1-6
% clear all;
% revised by Li Hong 2015.11.21
% tic;
mld_MAM_t=10.;
mld_MAM_dens=10.;
QI_MAM_t=1.;
QI_MAM_dens=1.;
    t1=(temp)';dens1=(dens)';
    aa1=find(~isnan(dens1));
    dens1=dens1(aa1);
    t1=t1(aa1);
    d1=depth(aa1);
    t1=smooth(t1,7);dens1=smooth(dens1,7);
%     disp(strcat('now begain calculating the mld,OLF method,at:','point=',...
%         num2str(i),',',num2str(lon(i)),'E',',',num2str(lat(i)),'N'));
    %%%%%%%%%%%%%%%%%%%%%%%% for temperature %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gg1=find(abs(d1-10)==min(abs(d1-10)));
    gg2=max(find(abs(dens1-dens1(gg1))<=0.3));
    t1(1:gg2)=smooth(t1(1:gg2));% need smooth the data
    dens1(1:gg2)=smooth(dens1(1:gg2));
    if(gg2>gg1+1)
        t11=t1(gg1+1:gg2);d11=d1(gg1+1:gg2);
        flag_t=nan*zeros(gg2-gg1,1);
        dens11=dens1(gg1+1:gg2);
        flag_dens=nan*zeros(gg2-gg1,1);
        for k=gg1+1:gg2
            jj=k-gg1;
            if(k<7) m=1;else m=4; end
            if(k+m<length(d1(gg1:end)))
                [E1_t E2_t]=E1E2_cal(d1(gg1:end),t1(gg1:end),k,m);
                [E1_dens E2_dens]=E1E2_cal(d1(gg1:end),dens1(gg1:end),k,m);
            end
            if(E1_t~=0); flag_t(jj)= E2_t/E1_t;end
            if(E1_dens~=0);flag_dens(jj)= E2_dens/E1_dens;end
        end
        mld_OLF_t=d11(min(find(flag_t==max(flag_t))));
        QI_OLF_t =QI_cal(d11,t11,mld_OLF_t);
        mld_OLF_dens=d11(min(find(flag_dens==max(flag_dens))));
        QI_OLF_dens =QI_cal(d11,dens11,mld_OLF_dens);
    clear t1 dens1 aa1 d1 gg1 gg2
end
