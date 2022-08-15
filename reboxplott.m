% œ‰œﬂÕº
clc,clear
close all
set(gcf,'color','white');
set(gcf,'unit','normalized','position',[0.02,0.02,0.63,0.92]);
FSize=12;
n=0;posi=[1 3 5 7 2 4 6 8]
titlename={'(a1)£∫±±∞Î«Ú-∂¨ºæ','(b1)£∫±±∞Î«Ú-¥∫ºæ','(c1)£∫±±∞Î«Ú-œƒºæ','(d1)£∫±±∞Î«Ú-«Ôºæ',...
    '(a2)£∫ƒœ∞Î«Ú-∂¨ºæ','(b2)£∫ƒœ∞Î«Ú-¥∫ºæ','(c2)£∫ƒœ∞Î«Ú-œƒºæ','(d2)£∫ƒœ∞Î«Ú-«Ôºæ'}
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
        subplot(4,2,posi(n))
        set(gca,'fontsize',FSize,'linewidth',1,'FontWeight','bold')
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
        set(gca,'ylim',[0 400],'fontsize',FSize,'FontWeight','bold');
        set(gca,'ytick',0:100:400);
        if n==1
            ylabel('ªÏ∫œ≤„…Ó∂»/dbar','fontsize',14,'FontWeight','bold')
        end
        text(1.4,350,titlename{n},'fontsize',12,'FontWeight','bold');
        set(gca,'ygrid','on','gridlinestyle','-','Gridalpha',0.1)
    end
end