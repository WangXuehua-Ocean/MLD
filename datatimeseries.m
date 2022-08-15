% 读取浮标数据
% 保存为[num2str(ifloat) '.mat'] 用来生成时间序列图
clc,clear
path = 'D:\Papers\cscd_MLD\Data\OriginalData';
dir_output = dir(fullfile(path));
dat=zeros(14,6);
dat_core=zeros(2000,2)
for imonth=1:12
    a(imonth).name;
    argo_Path=fullfile(argo_path, a(imonth).name,'\')
    %np=4902933;sp=3901283;na=3901970;sa=3901228;in=5902527; %北太平洋 南太平洋 北大西洋 南大西洋 印度洋
    [eng,pos,data]=read_data_from_float(argo_Path,'4902933');
    depth=getfield(data, 'pres_adj');depth=depth(:,2);depth=depth';
    ind_nan = find(isnan(depth));depth(ind_nan)=[];
    temp=getfield(data, 'temp_adj');temp=temp(:,2);temp=temp';temp(ind_nan)=[];
    sal=getfield(data, 'psal_adj');sal=sal(:,2);sal=sal'; sal(ind_nan)=[];
    lat=getfield(pos,'lat');lat=lat(2);
    lon=getfield(pos,'lon');lon=lon(2);
    % akima插值
    xi=linspace(0,10000,5001);
    x1=min(xi(find(xi-min(depth)>0)));
    x2=min(xi(find(xi-max(depth)+2>0)));
    n=(x2-x1)/2+1;
    xi=linspace(x1,x2,n);
    temp=akima(depth,temp,xi);
    sal=akima(depth',sal,xi);
    depth=xi';
    PT = sw_ptmp(sal,temp,depth,0);
    pden = sw_pden(sal,PT,depth,0);
    % 混合层深度
    [mld_GMM_t mld_GMM_dens ] = GMM_mld(temp,pden,depth);
    [mld_MAM_t mld_MAM_dens ] = MAM_mld(temp,pden,depth);
    [mld_OLF_t mld_OLF_dens ] = OLF_mld(temp,pden,depth);
    [mld_thr_dens]=threshold_mld(depth, pden);
    dat(imonth,:)=[lon lat  mld_thr_dens mld_GMM_dens mld_OLF_dens mld_MAM_dens];
end
