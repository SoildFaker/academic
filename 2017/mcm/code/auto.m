plaza = [
    0 1 1 1 1 0 0 0 0 0 0 0;    
    0 0 0 0 1 1 1 1 0 0 0 0;
    0 0 0 0 0 0 0 1 1 1 1 0;
    0 0 0 0 0 0 0 0 0 0 1 1;
    0 0 0 0 0 0 0 0 0 0 0 0;
    ];
[L,C]=size(plaza);
Q = zeros(L,C);

function [q,qa,qb,qc]=flow_ctl(q,qa,qb,qc,m)
    R = k/(qa + qb + qc+k);
    if(m==3)
        
    end
    return
end
