% œ‰œﬂÕº
clc,clear
close all
set(gcf,'color','white');
set(gcf,'unit','normalized','position',[0.02,0.2,0.92,0.63]);
FSize=12;
n=0;
for ihemi=1:2
    if ihemi==1
        path = 'D:\Papers\cscd_MLD\Data\ProcessedData\hemisphere\north';
        month=[1 2 3 4];
    else
        path = 'D:\Papers\cscd_MLD\Data\ProcessedData\hemisphere\south';
        month=[3 4 1 2];
    end
    for imonth=month
        n=n+1
        a=dir(fullfile(path,'*.xlsx'));
        subplot(2,4,n)
        set(gca,'fontsize',FSize,'linewidth',2,'FontWeight','bold')
        data=xlsread(fullfile(path, a(imonth).name));
        x = data(:,3);
        y = data(:,4);
        z = data(:,5);
        h = data(:,6);
        % group = [repmat(1, size(x,1), 1); repmat(2, size(y,1), 1); repmat(3, size(z,1), 1)];
        group = [repmat('x', size(x,1), 1); repmat('y', size(y,1), 1); repmat('z', size(z,1), 1);repmat('h', size(h,1), 1),];
        bh=boxplot([x;y;z;h], group,'symbol','','Labels',{'TH','CU','OL','MA'});
        set(bh,'LineWidth',1.1);
        set(gca,'linewidth',2);
        set(gca,'ylim',[0 320],'fontsize',FSize,'FontWeight','bold');
        set(gca,'ytick',0:50:320);
        if n==1
            ylabel('ªÏ∫œ≤„…Ó∂»/dbar','fontsize',14,'FontWeight','bold')
        end
        if n==1|n==5
            title('∂¨ºæ','fontsize',12,'FontWeight','bold');
            
        else
            set(gca,'yticklabel',[]);
        end
        if n==2|n==6
            title('¥∫ºæ','fontsize',12,'FontWeight','bold')
        end
        if n==3|n==7
            title('œƒºæ','fontsize',12,'FontWeight','bold')
        end
        if n==4|n==8
            title('«Ôºæ','fontsize',12,'FontWeight','bold')
        end
        set(gca,'ygrid','on','gridlinestyle','-','Gridalpha',0.1)
    end
end




