clc,clear
n1=0;n3=0;n5=0
num{1}='(a)';num{2}='(b)';
color_c = {'r','b','k','g','k','g','r','b'};
for ihemi=1:2
    n1=n1+1;
    if ihemi==1
        path = 'D:\Papers\cscd_MLD\Data\ProcessedData\seasonhemisphere\north\';
    else
        path = 'D:\Papers\cscd_MLD\Data\ProcessedData\seasonhemisphere\south\';
    end
    dir_output = dir(fullfile(path,'*.xlsx'));
    filenames = {dir_output.name}';
    order_month=[4 5 6 7 8 9 10 11 12 1 2 3];
    n2=0;
    for imonth=order_month
        n2=n2+1;
        filename=strcat(path, filenames(imonth));
        datxls=filename{1};
        dat=xlsread(datxls);
        data=dat(:,[3:6]);
        meandata(n2,:)=mean(data)
        month=[1:12];
        C = distinguishable_colors(4)
        
    end
    subplot(2,1,n1)
    set(gcf,'color','white');
    set(gca,'xaxislocation','top');
    set(gca,'xgrid','on','gridlinestyle','-','Gridalpha',0.1)
    set(gca,'ydir','reverse');
    set(gcf,'unit','normalized','position',[0.02,0.02,0.92,0.90]);
    set(gca,'fontsize',10,'linewidth',2);
    set(gca,'xlim',[1 12],'ylim',[0 180],'ytick',0:30:180,'xtick',1:1:12,'box','on' );
    if ihemi==1
        xlabel('�·�','fontsize',14,'FontWeight','bold');
        ylabel('��ϲ����/dbar','fontsize',14,'FontWeight','bold');
    end
    hold on
    a=plot(month,meandata(:,1),'-ko','Color',C(1, :),'MarkerFaceColor',C(1, :),'MarkerSize',2,'linewidth',2);%��ֵ��
    b=plot(month,meandata(:,2),'--ko','Color',C(2, :),'MarkerFaceColor',C(2, :),'MarkerSize',2,'linewidth',2);%���ʷ�
    c=plot(month,meandata(:,3),':ko','Color',C(3, :),'MarkerFaceColor',C(3, :),'MarkerSize',2,'linewidth',2);%���Ƕȷ�
    d=plot(month,meandata(:,4),'-.ko','Color',C(4, :),'MarkerFaceColor',C(4, :),'MarkerSize',2,'linewidth',2);%����������Ϸ�
    xlim=xlim;
    ylim=ylim;
    text((xlim(2)-xlim(1))*0.02+xlim(1),(ylim(2)-ylim(1))*0.85,num{n1},'FontSize',16,'FontWeight','bold');%ͼ��
    n4=0
    for imonth=order_month
    n3=n3+1;
    if mod(n3,3)==0
    n4=n4+1;n5=n5+1;
    X=[(n4-1)*3 n4*3 n4*3 (n4-1)*3]
    Y=[0 0 180 180]
    f1=fill(X,Y,color_c{n5});
    set(f1,'edgealpha',0,'facealpha',0.1);
    end
    
    end
end
h1=legend([a,b,c,d],{'��ֵ��','���ʷ�','����������Ϸ�','���Ƕȷ�'},'Location','best','Orientation','horizon','box','off','fontsize',13,'FontWeight','bold');
