function dx = loranzatt(t,x)
    sigma = 10;beta = 8/3;rho = 28;
    dx = zeros(3,1);
    dx(1) = sigma*(x(2) - x(1));
    dx(2) = x(1)*(rho - x(3)) -x(2);
    dx(3) = x(1)*x(2) - beta*x(3);
    return
end


