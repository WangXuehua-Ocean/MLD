% ��ͬ��ϲ��㷨ԭ��ͼ
% CALLER:  read_data_from_single_file.m
% CALLER:  akima.m
% CALLER:  sw_ptmp.m|sw_pden.m
% CALLEE:  threshold_mld.m|GMM_mld.m|OLF_mld.m|MAM_mld.m|QI_cal.m
clc,clear
path = 'D:\Papers\cscd_MLD\Data\OriginalData\202007\';
dir_output = dir(fullfile(path,'*.dat'));
filenames = {dir_output.name}';
thr=1388;gmm=1332;olf=1288;mam=1256;%��������������
nn=0;mm=0;
figure;
set(gcf,'color','white');
set(gcf,'unit','normalized','position',[0.02,0.2,0.92,0.63]);
for ifile=[thr gmm olf mam]
    filename=strcat(path, filenames(ifile));
    nn=nn+1;
    % �õ�����������
    [eng,pos,data]=read_data_from_single_file(filename{1});
    depth=getfield(data, 'pres_adj');
    temp=getfield(data, 'temp_adj');
    sal=getfield(data, 'psal_adj');
    lat=getfield(pos,'lat');
    lon=getfield(pos,'lon');
    % akima��ֵ
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
    ddens{nn}=pden;
    ddepth{nn}=depth;
    % ��ϲ����
    [mld_GMM_t mld_GMM_dens ] = GMM_mld(temp,pden,depth);
    [mld_MAM_t mld_MAM_dens ] = MAM_mld(temp,pden,depth);
    [mld_OLF_t mld_OLF_dens ] = OLF_mld(temp,pden,depth);
    [mld_thr_dens]=threshold_mld(depth, pden);
    %     QI_OLF_dens =QI_cal(depth,pden,mld_OLF_dens);
    %     QI_MAM_dens =QI_cal(depth,pden,mld_MAM_dens);
    %     QI_GMM_dens =QI_cal(depth,pden,mld_GMM_dens);
    %     QI_thr_dens =QI_cal(depth,pden,mld_thr_dens);
    % ��ֵ��
    if nn==1
        x{nn}=pden;%λ���ܶ�
        y{nn}=depth;
        mld{nn}=mld_thr_dens;
        num{nn}='(a)';
        xxlim{nn}=[1019.5 1022]
    end
    % ���ʷ�
    if nn==2
        d1=depth;
        dens1=smooth(pden);
        Dens_1=diff(dens1);
        gg1=find(abs(d1-10)==min(abs(d1-10)));
        %gg2=max(find(abs(dens1-dens1(gg1))<=0.3));
        gg2=18;
        if(gg2>gg1+2)
            Dens_2=zeros(gg2-max(gg1,2)+1,1);
            dd1=d1(max(gg1,2)+1:gg2);
            for ii=max(gg1,2):min(gg2,length(d1)-2)
                Dens_2(ii)=(Dens_1(ii+1)-Dens_1(ii))/(d1(ii+1)-d1(ii-1));
            end
            Dens_2=Dens_2(max(gg1,2)+1:end);
        end
        mld_GMM_dens=dd1(min([find(abs(Dens_2)==max(abs(Dens_2)))]));
        
        x{nn}=Dens_2;%����
        y{nn}=dd1;
        mld{nn}=mld_GMM_dens;
        num{nn}='(b)'
        xxlim{nn}=[min(Dens_2)-0.0001 max(Dens_2)+0.001]
    end
    % ����������Ϸ�
    if nn==3
        mld_OLF_dens=10.;
        dens1=pden;
        d1=depth;
        gg1=find(abs(d1-10)==min(abs(d1-10)));
        gg2=max(find(abs(dens1-dens1(gg1))<=0.3));
        %gg2=29;
        dens1(1:gg2)=smooth(dens1(1:gg2));
        if(gg2>gg1+1)
            d11=d1(gg1+1:gg2);
            dens11=dens1(gg1+1:gg2);
            flag_dens=nan*zeros(gg2-gg1,1);
            for k=gg1+1:gg2
                jj=k-gg1;
                if(k<7) m=1;else m=4; end
                if(k+m<length(d1(gg1:end)))
                    [E1_dens E2_dens]=E1E2_cal(d1(gg1:end),dens1(gg1:end),k,m);
                end
                if(E1_dens~=0);flag_dens(jj)= E2_dens/E1_dens;end
            end
        end
        mld_OLF_dens=d11(min(find(flag_dens==max(flag_dens))));
        
        x{nn}=flag_dens;%����
        y{nn}=d11;
        mld{nn}=mld_OLF_dens;
        num{nn}='(c)';
        xxlim{nn}=[min(flag_dens)-0.01 max(flag_dens)+0.3]
    end
    % ���Ƕȷ�
    if nn==4
        mld_MAM_dens=10.;
        dens1=smooth(pden);
        d1=depth;
        D_dens=max(dens1)-min(dens1);
        aa1=min(find(dens1>=min(dens1)+D_dens*0.1));
        aa2=min(find(dens1>=min(dens1)+D_dens*0.7));
        m=min(aa2-aa1+1,10);
        gg1=find(abs(d1-10)==min(abs(d1-10)));
        %gg2=max(find(abs(dens1-dens1(gg1))<=0.3));
        gg2=26;
        Ang_dens=nan*zeros(length(d1),1);
        if(gg2>max(2,gg1))
            for k=max(gg1,2):gg2
                if(k<=m) j=k-1; else j=m; end
                if(k+m<=length(d1))
                    P1=polyfit(d1(k-j:k),dens1(k-j:k),1);
                    P2=polyfit(d1(k+1:k+m),dens1(k+1:k+m),1);
                    if(1+P2(1)*P1(1)~=0)
                        Ang_dens(k)=(P2(1)-P1(1))/(1+P2(1)*P1(1));
                    end
                end
                
                Ang_dens=abs(Ang_dens(find(~isnan(Ang_dens))));
                dd1=d1(find(~isnan(Ang_dens)));
                
            end
        end
        Ang_dens(1)=0;
        mld_MAM_dens=dd1(min(find(Ang_dens==max(Ang_dens))));
        
        x{nn}=Ang_dens;%�Ƕ�
        y{nn}=dd1;
        mld{nn}=mld_MAM_dens;
        num{nn}='(d)';
        xxlim{nn}=[min(Ang_dens)-0.01 max(Ang_dens)+0.01]
    end
end
% ��˫x��ͼ
for ipic=1:4
    marx=0.1*ipic+(ipic-1)*0.11;%����x�����
    mary=0.2;%����y�����
    wid1=0.16;%ͼƬ���
    hei1=0.6;%ͼƬ�߶�
    
    mm=mm+1;
    Fsize=14
    % ������һ��axes
    hax1 = subplot(1,4,mm)
    set(gca,'fontsize',Fsize,'linewidth',2,'position',[marx mary wid1 hei1]);
    
    if ipic==1
        xdata1 = x{mm};
        ydata1 = y{mm};
        hl1=plot(xdata1, ydata1,'k--','linewidth',2);
        set(gca,'xlim',[1020 1025],'ylim',[0 110],'XMinorTick','on','ydir','reverse',...
            'box','on','ytick',[0:10:110],'xtick',[1020:2:1025])
        ylabel('���/dbar','fontsize',Fsize,'FontWeight','bold');hold on
        xlabel('λ���ܶ�/kg�qm^-^3','fontsize',Fsize,'FontWeight','bold');
        plot(min(xdata1(find(ydata1==10))),10,'ko-','MarkerFaceColor','k','MarkerSize',5);hold on
        plot(min(xdata1(find(ydata1==mld{ipic}))),mld{ipic},'ko-','MarkerFaceColor','k','MarkerSize',5);hold on
        plot([1020 1025],[10 10],'LineStyle','-','color','k','linewidth',1); hold on %��׼��
        mldline=plot(xlim,[mld{ipic} mld{ipic}],'color','b','linewidth',2);
        mldline.Color(4) = 0.6; %͸����              
        set(gca,'fontsize',Fsize,'linewidth',2);
        xlim=xlim;
        ylim=ylim;
        text((xlim(2)-xlim(1))*0.05+xlim(1),(ylim(2)-ylim(1))*0.95,'(a)','FontSize',16,'FontWeight','bold');
    else
        
        % ʵ�߻���һ��axes���plot
        xdata1 = x{ipic};
        ydata1 = y{ipic};
        hplot1 = line(xdata1, ydata1,'color','k','LineStyle','-','linewidth',2);
        ax1=gca; %current axes
        posi=axis;
        set(ax1,'XAxisLocation','bottom','xlim',xxlim{ipic},...
            'ylim',[0 110],'XMinorTick','on','ydir','reverse','ytick',[0:10:110],'yticklabel',[]);       
        % ����һ��͸�������ڵ�һ����Ķ���������x���ڶ�����û��ytick���(���ǩ)  
        hax2 = axes('Position', get(hax1, 'Position'), ...  % Copy λ��
            'XAxisLocation', 'top', ...             % ��x���������
            'YAxisLocation', 'right', ...           % �޹ؽ�Ҫ
            'xlim', [1020 1025], ...                % ����xlim
            'Color', 'none', ...                    % ��͸��
            'ylim',[0 110],...
            'yticklabel',[],...
            'XMinorTick','on',...
            'ydir','reverse',...
            'xtick',[1020:2:1025],...
            'ytick',[0:10:110]);
        set(gca,'fontsize',Fsize,'linewidth',2);
        % ���߻��ڶ���axes���plot���в�ͬ��xrange
        xdata2 = ddens{ipic};
        ydata2 = ddepth{ipic};
        hplot2 = line(xdata2, ydata2,'color','k','linewidth',2,'LineStyle','--', 'Parent', hax2);    
        % ��y�ļ��޺�λ��������һ��
        linkprop([hax1, hax2], {'ylim', 'Position'});       
        % дlabels
        if ipic==2
           xlabel(hax1, '���׵���/C�qdbar^-^2  ','fontsize',Fsize,'FontWeight','bold','position',[0.10*posi(2) 12.3*posi(3)]);
           xlabel(hax2, 'λ���ܶ�/kg�qm^-^3','fontsize',Fsize,'FontWeight','bold');
        end
        if ipic==3
            xlabel(hax1,'E2(k)/E1(k)','fontsize',Fsize,'FontWeight','bold');
            xlabel(hax2, 'λ���ܶ�/kg�qm^-^3','fontsize',Fsize,'FontWeight','bold');
        end
        if ipic==4
            xlabel(hax1, 'tan��','fontsize',Fsize,'FontWeight','bold');
            xlabel(hax2, 'λ���ܶ�/kg�qm^-^3','fontsize',Fsize,'FontWeight','bold');
        end
        % ��legend
        % legend([hplot1, hplot2], {'Blue', 'Red'})
        hold on
        % ����ϲ������
        xlim=xlim;
        ylim=ylim;
        mldline=plot(xlim,[mld{ipic} mld{ipic}],'color','b','linewidth',2);
        mldline.Color(4) = 0.6;%����͸����
        text((xlim(2)-xlim(1))*0.05+xlim(1),(ylim(2)-ylim(1))*0.95,num{ipic},'FontSize',16,'FontWeight','bold');%ͼ��
    end   
end