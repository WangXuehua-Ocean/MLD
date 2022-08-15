% ��ȡ��������
% ����ddepth ssal ttemp view��dataprofile.mat
% CALLER:  read_data_from_float.m
clc,clear
path = 'D:\Papers\cscd_MLD\Data\OriginalData'; 
dir_output = dir(fullfile(path));
dat=zeros(14,6);
dat_core=zeros(2000,2)
np=4902933;sp=3901283;na=3901970;sa=3901228;in=5902527;% ��̫ƽ�� ��̫ƽ�� �������� �ϴ����� ӡ����
mm=0;
for ifloat=[np sp na sa in]
    for imonth=[2 5 8 11]
        mm=mm+1;
        dir_output(imonth+2).name;
        argo_Path=fullfile(path, dir_output(imonth+2).name,'\');    
        [eng,pos,data]=read_data_from_float(argo_Path,num2str(ifloat));
        lat=getfield(pos,'lat');lat=lat(2);
        lon=getfield(pos,'lon');lon=lon(2);
        depth=getfield(data, 'pres_adj');depth=depth(:,2);
        ind_nan = find(isnan(depth));depth(ind_nan)=[];
        temp=getfield(data, 'temp_adj');temp=temp(:,2);temp(ind_nan)=[];
        sal=getfield(data, 'psal_adj');sal=sal(:,2); sal(ind_nan)=[];
        ddepth{mm}=depth;
        ssal{mm}=sal;
        ttemp{mm}=temp;
        view{mm}=128;% ʵ��λ��    
    end
end