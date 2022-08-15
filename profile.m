 % ��������ͼ
% CALLER:  akima.m
% CALLER:  sw_ptmp.m|sw_pden.m
% CALLEE:  threshold_mld.m|GMM_mld.m|OLF_mld.m|MAM_mld.m|QI_cal.m
% CALLER:  distinguishable_colors.m
clc,clear,close all
load D:\Papers\cscd_MLD\Data\ProcessedData\dataprofile.mat %ddepth ssal tidat(ͼ��) ttemp view
% ȷ��λ��
top_margin = 0.13; % top margin
btm_margin = 0.05; % bottom margin
left_margin = 0.10;% left margin
right_margin = 0.10;% right margin
fig_margin = 0.02; % margin beween figures(sub)
fig_margin_h = 0.15
%
row = 2; % rows
col = 4; % cols
FSize=14
mm=0;nn=8;% nn=0̫ƽ�� nn=8������ nn=16ӡ����
set(gcf,'color','white');
set(gcf,'unit','normalized','position',[0.02,0.2,0.92,0.63]);
dat=[];
for i=1:row
    for j=1:col
        mm=mm+1;
        nn=nn+1;
        subplot(2,4,mm)
        fig_h = (1- top_margin - btm_margin - (row-1) * fig_margin_h) / row;
        fig_w = (1 - left_margin - right_margin - (col-1) * fig_margin) / col;
        position = [left_margin + (j-1)*(fig_margin+fig_w), ...
            1- (top_margin + i * fig_h + (i-1) * fig_margin_h), ...
            fig_w, fig_h];
        p=position;
        set(gca,'fontsize',FSize,'linewidth',2,'position',position,'FontWeight','bold');
        depth=ddepth{nn};
        temp=ttemp{nn};
        sal=ssal{nn};
        % akima��ֵ
        xi=linspace(0,10000,5001);
        x1=min(xi(find(xi-min(depth)>0)));
        x2=min(xi(find(xi-max(depth)+2>0)));
        n=(x2-x1)/2+1;
        xi=linspace(x1,x2,n);%��Ҫ��ֵ��λ��
        temp=akima(depth,temp,xi);
        sal=akima(depth,sal,xi);
        depth=xi';
        PT = sw_ptmp(sal,temp,depth,0);%�õ�λ���¶�
        pden = sw_pden(sal,PT,depth,0);%�õ�λ���ܶ�
        % �����ϲ����
        [mld_thr_dens] = threshold_mld(depth, pden);
        [mld_GMM_t mld_GMM_dens ] = GMM_mld(temp,pden,depth);
        [mld_OLF_t mld_OLF_dens ] = OLF_mld(temp,pden,depth);
        [mld_MAM_t mld_MAM_dens ] = MAM_mld(temp,pden,depth);
        dat=[dat;mld_thr_dens mld_GMM_dens mld_OLF_dens mld_MAM_dens,view{nn}];
        hl1=plot(pden,depth,'k','linewidth',2);    % ���ܶ�����
        % ȷ��xlim ylim
        OLF_y=mld_OLF_dens;
        OLF_xt=pden(find(depth==OLF_y));
        xlast=pden(find(depth==600));
        set(gca,'xlim',[OLF_xt-1 xlast],'ylim',[0 180],'xlim',[1022.5,1029.5],'XMinorTick','on','ydir','reverse',...
            'box','on','XAxisLocation','top')
        % ax = gca;
        % ax.YAxis.TickDirection = 'out';
        set(gca,'linewidth',2,'fontsize',FSize,'FontWeight','bold');
        set(gca,'ytick',0:30:180);
        if mm==1
            ylabel('���(dbar)','fontsize',FSize,'FontWeight','bold')
            xlabel('λ���ܶ�(kg/m^3)','fontsize',FSize,'FontWeight','bold')
        elseif mm==5
            ylabel=[];
        else
            set(gca,'yticklabel',[]);
        end
        xlim=xlim;
        ylim=ylim;
        % grid on
        C = distinguishable_colors(5);% 5����ɫ
        % ��ֵ��
        thr_y=mld_thr_dens;
        thr_xt=pden(find(depth==thr_y));
        thr_x=[thr_xt-(xlim(2)-xlim(1))*0.1,thr_xt+(xlim(2)-xlim(1))*0.1];
        hold on
        a=plot(thr_x,[thr_y thr_y],'color',C(1, :),'linewidth',2)
        a.Color(4) = 0.6;% ����͸����
        % ���ʷ�
        GMM_y=mld_GMM_dens;
        GMM_xt=pden(find(depth==GMM_y));
        GMM_x=[GMM_xt-(xlim(2)-xlim(1))*0.1,GMM_xt+(xlim(2)-xlim(1))*0.1];
        hold on
        b=plot(GMM_x,[GMM_y GMM_y],'color',C(2, :),'linewidth',2)
        b.Color(4) = 0.6;% ����͸����
        % ����������Ϸ�
        OLF_y=mld_OLF_dens;
        OLF_xt=pden(find(depth==OLF_y));
        OLF_x=[OLF_xt-(xlim(2)-xlim(1))*0.1,OLF_xt+(xlim(2)-xlim(1))*0.1];
        c=plot(OLF_x,[OLF_y OLF_y],'color',C(3, :),'linewidth',2)
        c.Color(4) = 0.6;% ����͸����
        % ���Ƕȷ�
        MAM_y=mld_MAM_dens;
        MAM_xt=pden(find(depth==MAM_y));
        MAM_x=[MAM_xt-(xlim(2)-xlim(1))*0.1,MAM_xt+(xlim(2)-xlim(1))*0.1];
        d=plot(MAM_x,[MAM_y MAM_y],'color',C(4, :),'linewidth',2);
        d.Color(4) = 0.6;% ����͸����
        % ʵ��λ��
        view_y=view{nn};
        view_x=pden(find(depth==view_y));
        plot1=plot(view_x,view_y,'v','MarkerFaceColor',C(5, :),'MarkerSize',5);
        % ͼ��
        xliml=p(1);
        xlimr=p(1)+p(3);
        ylimt=p(2)+p(4);
        ylimb=p(2);
        %     text((xlimr-xliml)*1.2+xliml,(ylimt-ylimb)*1.2+ylimb,tidat{mm},'FontSize',14,'FontWeight','bold','FontName','Times New Roman')
%         text(1022.6,180,tidat{mm},'FontSize',16,'FontWeight','bold','FontName','Times New Roman');
text(1022.6,550,tidat{mm},'FontSize',16,'FontWeight','bold','FontName','Times New Roman');
    end
end
h=legend([a,b,c,d,plot1],{'��ֵ��','���ʷ�','����������Ϸ�','���Ƕȷ�','ʵ��λ��'
    },'position',position,'Orientation','horizon','box','off','fontsize',FSize,'FontWeight','bold');
