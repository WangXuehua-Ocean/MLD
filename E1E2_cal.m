function [rmse mae] =E1E2_cal(d1,obv,k,m)
a=polyfit(d1(1:k),obv(1:k),1);
for n=1:k
    pred1(n)=polyval(a,n);
    obv1(n)=obv(n);
end
for m=1:4
    pred2(m)=polyval(a,k+m);
    obv2(m)=obv(k+m);
end
rmse=sqrt(mean((pred1-obv1).^2));
mae=mean(abs(pred2-obv2));
end
