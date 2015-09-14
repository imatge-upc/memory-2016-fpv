%Gaussian filter
function g=Gaussian_filter(fsiz, sigma)
%size=5; %filter size, odd number
size1 = fsiz(1);
size2 = fsiz(2);
g=zeros(size1,size2); %2D filter matrix
%sigma=2; %standard deviation
%gaussian filter
for i=-(size2-1)/2:(size2-1)/2
    for j=-(size1-1)/2:(size1-1)/2
        x0=(size2+1)/2; %center
        y0=(size1+1)/2; %center
        x=i+x0; %row
        y=j+y0; %col
        g(y,x)=exp(-((x-x0)^2+(y-y0)^2)/2/sigma/sigma);
    end
end
%normalize gaussian filter
sum1=sum(g);
sum2=sum(sum1);
g=g/sum2;
g = g/max(max(g));
end

%plot 3D
%g1=Gaussian_filter(50,2);
%g2=Gaussian_filter(50,7);
%g3=Gaussian_filter(50,11);
%figure(1);
%subplot(1,3,1);surf(g1);title('filter size = 50, sigma = 2');
%subplot(1,3,2);surf(g2);title('filter size = 50, sigma = 7');
%subplot(1,3,3);surf(g3);title('filter size = 50, sigma = 11');