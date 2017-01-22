function draw_m(M)
[l,c] = size(M);

for x=1:l
    for y=1:c
        fx=[x-1,x,x,x-1];
        fy=[y-1,y-1,y,y];
        
        if(M(x,y)==0)
            fill(fx,fy,[0 0 0]);
        else
            m = max(0.1,M(x,y));
            a = 0.5*m/(1+0.5*m);
            fill(fx,fy,[ 1-a 1 1-a]);
        end
    end
end
end