% 散点图（scatter）作图，每个方法画一个混合层深度与QI值的相对分布。
% CALLER:  scatplot.m
clc,clear
% % 下面保存为data_scatter.mat
% dat=xlsread('D:\Papers\cscd_MLD\Data\ProcessedData\FinalXls\linklist.xlsx');
% thr=dat(:,[3 7]);
% cul=dat(:,[4 8]);
% olf=dat(:,[5 9]);
% gmm=dat(:,[6 10]);
% te={'(a)','(b)','(c)','(d)'};
% xla={'阈值法MLD(dbar)','曲率法MLD(dbar)','最优线性拟合法MLD(dbar)','最大角度法MLD(dbar)'};
load D:\Papers\cscd_MLD\Data\ProcessedData\data_scatter.mat %cul gmm olf te(图题) thr xla(xlabel)
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
    % 散点图
    out=scatplot(X(:,1),X(:,2),'circles', sqrt((range(X(:, 1))/30)^2 + (range(X(:,2))/30)^2), 100, 5, 1, 8);
    % colorbar
    ax=gca;
    axpos=ax.Position;
    %colormap jet
    ch=colorbar('YTickLabel',...           % set labels to the colorbar
    {'0','20%','40%','60%','80%','100%'},'position',[axpos(1)+axpos(3)+0.01,axpos(2),0.02,axpos(4)])
    set(get(ch,'title'),'string','频率','FontSize',10,'FontWeight','bold');
    % ylabel(colorbar,'密度','FontSize',8,'FontName','宋体','FontWeight','bold')
    xlabel(xla{n},'fontsize',5,'FontWeight','bold');hold on
    if n==1|n==3
        ylabel('QI','fontsize',5,'FontWeight','bold');hold on
    end
    xlim([0 300]); %设置坐标轴刻度取值范围
    ylim([0.0 1.01]);
    set(gca,'xtick',0:30:300,'ytick',0.0:0.1:1);
    % set(gca,'XtickLabel',{'冬季','春季','夏季','秋季'},'fontsize',13,'FontWeight','bold','FontName','宋体');
    set(gca,'YtickLabel',{'0','','0.2','','0.4','','0.6','','0.8','','1.0'},'fontsize',10,'FontWeight','bold','FontName','宋体');%修改坐标轴名称、字体
    set(gca,'XtickLabel',{'0','','60','','120','','180','','240','','300'},'fontsize',10,'FontWeight','bold','FontName','宋体');%修改坐标轴名称、字体
    xli=xlim;
    yli=ylim;
    set(gca,'XMinorTick','on','box','on');
    set(gca,'linewidth',1,'fontsize',12,'FontWeight','bold');
    set(gca,'xgrid','on','ygrid','on','gridlinestyle','-','Gridalpha',0.2);%网格线
    hold on
    % contour(out.xi,out.yi,out.zi)
    mean_QI=nanmean(dd(:,2))
    a=plot(xlim,[mean_QI mean_QI],'--','color','r','linewidth',2);%平均值
    a.Color(4) = 0.7;% 设置透明度
    b=plot(xlim,[0.8 0.8],'-','color','g','linewidth',2);%0.8
    b.Color(4) = 0.5;% 设置透明度
    c=plot(xlim,[0.5 0.5],'-','color','b','linewidth',2);%0.5
    c.Color(4) = 0.5;% 设置透明度
    xli=xlim;
    yli=ylim;
    text((xli(2)-xli(1))*0.88+xli(1),(yli(2)-yli(1))*0.1+yli(1),te{n},'FontSize',16,'FontWeight','bold','FontName','Times New Roman')
end
% print(gcf,'-dpng','散点密度图.png');
