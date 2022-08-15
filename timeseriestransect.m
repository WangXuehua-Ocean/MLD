% ������ͼ��ʱ������ͼ
% CALLER:  read_data_from_float.m
% CALLER:  transect.m|transectc.m
% CALLER:  distinguishable_colors.m
clc,clear
path = 'D:\Papers\cscd_MLD\Data\OriginalData';
dir_output = dir(fullfile(path));
month=[1:12];month=month';
np=4902933;sp=3901283;na=3901970;sa=3901228;in=5902527; %��̫ƽ�� ��̫ƽ�� �������� �ϴ����� ӡ����
mm=0;nn=0;
figure;
set(gcf,'color','white');
set(gcf,'unit','normalized','position',[0.02,0.04,0.71,0.85]);
te={'(a)','(b)','(c)','(d)','(e)'};
% ��������
for ifloat=[np sp na sa in]
    mm=mm+1;
    for imonth=1:12
        dir_output(imonth+2).name;
        argo_Path=fullfile(path, dir_output(imonth+2).name,'\')
        [eng,pos,data]=read_data_from_float(argo_Path,num2str(ifloat));
        depth=getfield(data, 'pres_adj');depth=depth(:,2);depth=depth';
        ind_nan = find(isnan(depth));depth(ind_nan)=[];
        temp=getfield(data, 'temp_adj');temp=temp(:,2);temp=temp'; temp(ind_nan)=[];
        sal=getfield(data, 'psal_adj');sal=sal(:,2);sal=sal'; sal(ind_nan)=[];
        lat=getfield(pos,'lat');lat=lat(2);
        lon=getfield(pos,'lon');lon=lon(2);
        % akima��ֵ
        xi=linspace(0,10000,5001);
        x1=min(xi(find(xi-min(depth)>0)));
        x2=min(xi(find(xi-max(depth)+2>0)));
        n=(x2-x1)/2+1;
        xi=linspace(x1,x2,n);
        temp=akima(depth,temp,xi);
        sal=akima(depth',sal,xi);
        PT = sw_ptmp(sal',temp',xi,0);
        pden = sw_pden(sal',PT,xi,0);
        depth=xi(1:349);
        dens=pden(1:349);% 200m
        Dens{imonth}=dens';
        Depth{imonth}=depth';
    end
    DDens{mm}=Dens;
    DDepth{mm}=Depth;
end
for ifloat=[np sp na sa in]
    eval(['load ' 'D:\Papers\cscd_MLD\Data\ProcessedData\datatimeseries\',num2str(ifloat) '.mat']); %��ϲ��������
    data=dat([3:14],[3:6]);
    nn=nn+1;
    % λ��
    marx=0.1;
    mary=0.78-0.15*(nn-1)-nn*0.02;
    wid1=0.67;
    hei1=0.16;
    max_index=ceil(max(data(:)/100));
    % ytick
    if max_index>3
        step=100
    else
        step=50
    end
    hax1=subplot(5,1,nn)
    set(gca,'position',[marx mary wid1 hei1]);
    set(gca,'xaxislocation','top');
    set(gca,'ydir','reverse');
    set(gca,'xgrid','on','gridlinestyle','-','Gridalpha',0.1)
    set(gca,'fontsize',10,'linewidth',2)
    set(gca,'xlim',[1 12],'ylim',[10 max_index*100],'XMinorTick','on', 'box','on','ytick',10:step:max_index*100);
    xli=xlim;
    yli=ylim;
    % xlabel('�·�','fontsize',10,'FontWeight','bold');
    % ylabel('���(dbar)','fontsize',10,'FontWeight','bold');
    % set(gca,'xticklabel',[])
    hold on
    % climate data toolbox for matlab
    transect(month,DDepth{nn},DDens{nn},'marker','none','extrap' );%����ͼ
    transectc(month,DDepth{nn},DDens{nn},'w'); %��ֵ��ͼ
    % colormap(othercolor('Set13'));
    % colormap(othercolor('BuOr_10'));
    %     clim = [1025 1028];
    % colorbar('position',[0.15 0.15 0.04 0.2]);
    %     caxis(clim);
    colormap(m_colmap('jet'));
    %     shading interp
    % cmocean balance
    %     clim = [1024 1027];
    % colormap(othercolor('',7))
    if nn==5
        colorbar('Ytick',1025.7:0.3:1027,'position',[marx+wid1+0.01 mary 0.02 hei1])
        shading interp
        ylabel('λ���ܶ�/kg�qm^-^3','fontsize',14,'FontWeight','bold');hold on
    else
        colorbar('position',[marx+wid1+0.01 mary 0.02 hei1])
    end
    %     caxis(clim);
    %         colorbar
    C = distinguishable_colors(4);
    hold on
    a=plot(month,data(:,1),'-ko','MarkerFaceColor',C(1, :),'MarkerSize',5,'linewidth',1);%��ֵ��
    b=plot(month,data(:,2),'-ks','MarkerFaceColor',C(2, :),'MarkerSize',5,'linewidth',1);%���ʷ�
    c=plot(month,data(:,3),'-kd','MarkerFaceColor',C(3, :),'MarkerSize',5,'linewidth',1);%���Ƕȷ�
    d=plot(month,data(:,4),'-k^','MarkerFaceColor',C(4, :),'MarkerSize',5,'linewidth',1);%����������Ϸ�
    if nn==1
        xlabel('�·�','fontsize',14,'FontWeight','bold');hold on
        
        h1=legend([a,b,c,d],{'��ֵ��','���ʷ�','����������Ϸ�','���Ƕȷ�'},'Location','South','fontsize',10,'FontWeight','bold');
        
        set(h1,'box','off')
    else
        set(gca,'xticklabel',[]);
    end
    if nn==3
        ylabel('MLD/dbar','fontsize',14,'FontWeight','bold','FontName','Times New Roman');hold on
    end
    xli=xlim;
    yli=ylim;
    text(1.2,yli(2)*0.85,te{nn},'FontSize',16,'FontWeight','bold','FontName','Times New Roman')
end

% title('λ�ڱ�̫ƽ���4902933����Ļ�ϲ����');
% 'λ�ڱ�̫ƽ���4902933����Ļ�ϲ����' 'λ����̫ƽ���3901283����Ļ�ϲ����'
% 'λ�ڱ��������3901970����Ļ�ϲ����' 'λ���ϴ������3901228����Ļ�ϲ����'
% 'λ��ӡ�����5902527����Ļ�ϲ����'
