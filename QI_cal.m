function [QI] =QI_cal(depth,temp,mld)
% calculating the Qulinity Index of the mix layer depth of calculation
% Reference:
% Lorbacher,K.,Dommenget,D.,et al.,2006.Ocean mixed layer depth:
% A subsurface proxy of ocean-atmosphere variability.J.Geophys.Res.,
E1=0;E2=0;
r =1.5;
imld=max(find(depth<=mld));
i2=max(find(depth<=r*mld));
QI=0;
gg1=find(abs(depth-10)==min(abs(depth-10)));
if(imld>=gg1&i2>imld)
    E1=std(temp(gg1:imld));
    E2=std(temp(gg1:i2));
    if(E2 ~=0)
        QI=1-E1/E2;
    end
end
% else
%     QI = nan;
% end

