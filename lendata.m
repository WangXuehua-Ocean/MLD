clc,clear
n1=0;num{1}='(a)';num{2}='(b)';
len=0;
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
        len=len+length(dat);
    end
end