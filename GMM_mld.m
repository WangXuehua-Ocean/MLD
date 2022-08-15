function [mld_GMM_t mld_GMM_dens QI_GMM_t QI_GMM_dens] = GMM_mld(temp,dens,depth)
% This programg calculate the mix layer depth from the Argo profile data
% And the method is Geometric Model method
% Reference:
% Peter C.Chu,Q. Q. Wang, and R. H. Bourke, 1999: A geometric model for
%the Beaufort/Chukchi Sea thermohaline structure. J. Atmos.
% Oceanic Technol.,16:613¨C632.
% clear all;
% Li Hong,revised 2016.3.30

% first initial the data
mld_GMM_t=10.;
mld_GMM_dens=10.;
% QI_GMM_t=1.;
% QI_GMM_dens=1.;
%%%%
aa1=(~isnan(dens));
dens1=smooth(dens(aa1));
t1=smooth(temp(aa1));
d1=depth(aa1);
% t1=smooth(temp);
% dens1=smooth(dens); % to smooth

T_1=diff(t1);
Dens_1=diff(dens1);
gg1=find(abs(d1-10)==min(abs(d1-10)));
gg2=max(find(abs(dens1-dens1(gg1))<=0.3));
if(gg2>gg1+2)
    T_2=zeros(gg2-max(gg1,2)+1,1);
    Dens_2=zeros(gg2-max(gg1,2)+1,1);
    dd1=d1(max(gg1,2)+1:gg2);
    for ii=max(gg1,2):min(gg2,length(d1)-2)
        T_2(ii)=(T_1(ii+1)-T_1(ii))/(d1(ii+1)-d1(ii-1));
        Dens_2(ii)=(Dens_1(ii+1)-Dens_1(ii))/(d1(ii+1)-d1(ii-1));
    end
    T_2=T_2(max(gg1,2)+1:end);
    Dens_2=Dens_2(max(gg1,2)+1:end);
    mld_GMM_t=dd1(min([find(abs(T_2)==max(abs(T_2)))]));
    mld_GMM_dens=dd1(min([find(abs(Dens_2)==max(abs(Dens_2)))]));
        QI_GMM_t = QI_cal(d1,t1,mld_GMM_t);
        QI_GMM_dens = QI_cal(d1,dens1,mld_GMM_dens);
    clear T_2 Dens_2 dd1
end
clear T_1 Dens_1 gg1 gg2
clear t1 dens1  aa1 d1 gg1 gg2 dens temp

