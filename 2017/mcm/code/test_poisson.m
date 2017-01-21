function test_poisson()
L=20;
P=zeros(1,L);
X=[1:L];
    for t=0:1000
        i=poissrnd(6);
        P(i)=P(i)+1;
        drawnow
        plot(X,P);
        pause(0.01);
    end
end