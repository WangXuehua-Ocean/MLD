% ɢ��ͼ��scatter����ͼ��ÿ��������һ����ϲ������QIֵ����Էֲ���
% CALLER:  scatplot.m
clc,clear
% % ���汣��Ϊdata_scatter.mat
% dat=xlsread('D:\Papers\cscd_MLD\Data\ProcessedData\FinalXls\linklist.xlsx');
% thr=dat(:,[3 7]);
% cul=dat(:,[4 8]);
% olf=dat(:,[5 9]);
% gmm=dat(:,[6 10]);
% te={'(a)','(b)','(c)','(d)'};
% xla={'��ֵ��MLD(dbar)','���ʷ�MLD(dbar)','����������Ϸ�MLD(dbar)','���Ƕȷ�MLD(dbar)'};
load D:\Papers\cscd_MLD\Data\ProcessedData\data_scatter.mat %cul gmm olf te(ͼ��) thr xla(xlabel)
n=0;
figure;
set(gcf,'color','white');
set(gcf,'unit','normalized','position',[0.02,0.2,0.62,0.63]);
for ipic=1:4
    subplot(2,2,ipic);
    ax=gca;
    axpos=ax.Position;
    position=[axpos(1),axpos(2),axpos(3)-0.028,axpos(4)];
    set(gca,'fontsize',10,'linewidth',2,'position',position,'FontWeight','bold');
    
    n=n+1;
    if n==1
        dd=thr;
    end
    if n==2
        dd=cul;
    end
    if n==3
        dd=olf;
    end
    if n==4
        dd=gmm;
    end
    a=[1:1:28392];
    data_out=dd;
    X=data_out(a,1:2);
    % ɢ��ͼ
    out=scatplot(X(:,1),X(:,2),'circles', sqrt((range(X(:, 1))/30)^2 + (range(X(:,2))/30)^2), 100, 5, 1, 8);
    % colorbar
    ax=gca;
    axpos=ax.Position;
    %colormap jet
    ch=colorbar('YTickLabel',...           % set labels to the colorbar
    {'0','20%','40%','60%','80%','100%'},'position',[axpos(1)+axpos(3)+0.01,axpos(2),0.02,axpos(4)])
    set(get(ch,'title'),'string','Ƶ��','FontSize',10,'FontWeight','bold');
    % ylabel(colorbar,'�ܶ�','FontSize',8,'FontName','����','FontWeight','bold')
    xlabel(xla{n},'fontsize',5,'FontWeight','bold');hold on
    if n==1|n==3
        ylabel('QI','fontsize',5,'FontWeight','bold');hold on
    end
    xlim([0 300]); %����������̶�ȡֵ��Χ
    ylim([0.0 1.01]);
    set(gca,'xtick',0:30:300,'ytick',0.0:0.1:1);
    % set(gca,'XtickLabel',{'����','����','�ļ�','�＾'},'fontsize',13,'FontWeight','bold','FontName','����');
    set(gca,'YtickLabel',{'0','','0.2','','0.4','','0.6','','0.8','','1.0'},'fontsize',10,'FontWeight','bold','FontName','����');%�޸����������ơ�����
    set(gca,'XtickLabel',{'0','','60','','120','','180','','240','','300'},'fontsize',10,'FontWeight','bold','FontName','����');%�޸����������ơ�����
    xli=xlim;
    yli=ylim;
    set(gca,'XMinorTick','on','box','on');
    set(gca,'linewidth',1,'fontsize',12,'FontWeight','bold');
    set(gca,'xgrid','on','ygrid','on','gridlinestyle','-','Gridalpha',0.2);%������
    hold on
    % contour(out.xi,out.yi,out.zi)
    mean_QI=nanmean(dd(:,2))
    a=plot(xlim,[mean_QI mean_QI],'--','color','r','linewidth',2);%ƽ��ֵ
    a.Color(4) = 0.7;% ����͸����
    b=plot(xlim,[0.8 0.8],'-','color','g','linewidth',2);%0.8
    b.Color(4) = 0.5;% ����͸����
    c=plot(xlim,[0.5 0.5],'-','color','b','linewidth',2);%0.5
    c.Color(4) = 0.5;% ����͸����
    xli=xlim;
    yli=ylim;
    text((xli(2)-xli(1))*0.88+xli(1),(yli(2)-yli(1))*0.1+yli(1),te{n},'FontSize',16,'FontWeight','bold','FontName','Times New Roman')
end
% print(gcf,'-dpng','ɢ���ܶ�ͼ.png');
