
function s=merge_sim2()
    area = [
        3 1 0 0 0 0 0 0 0 0 0 0 0;
        3 3 3 3 1 0 0 0 0 0 0 0 0;
        3 3 3 3 3 3 3 1 0 0 0 0 0;
        3 3 3 3 3 3 3 3 3 3 1 0 0;
        2 2 2 2 2 2 2 2 2 2 2 2 2;
        %2 2 2 2 2 2 2 2 2 2 2 2 2;
        %2 2 2 2 2 2 2 2 2 2 2 2 2;
    ];
    
    [L,C]=size(area);
    
    Q = zeros(L,C);
    Out = 0;
    HO =[];
    SUM = [];
    s = 0;
    HF =[];
    figure;
    cur_flow = 0;
    in_flow = 0;
    HI = [];
    %C=6;
    hold on
    for t=0:45
    for i=1:C
        for j=1:L
            if (i == 1)
                k = 1.6;
                if (Q(j,i)<3)
                    in = k*(poisspdf(L-j,1));%* calv(Q(j,i))
                    Q(j,i) = Q(j,i)+in;
                    %in_flow = in_flow + in;
                     cur_flow = cur_flow + in;
                end
            end
            if (area(j,i) == 3)
                [Q(j,i),Q(j+1,i),Q(j,i+1)]=flow_div(Q(j,i),Q(j+1,i),Q(j,i+1));
            end
            if (area(j,i) == 2)
                if(i==C)
                    div = Q(j,i) * calv(Q(j,i));
                    Out = Out + div;
                    s = s + Out;
                    cur_flow = cur_flow - div ;
                    Q(j,i) = Q(j,i) - div;
                else
                    [Q(j,i),Q(j,i+1)]=flow_forward(Q(j,i),Q(j,i+1));
                    if(j<L && area(j+1,i)==2)
                       [Q(j,i),Q(j+1,i)]=flow_updown(Q(j,i),Q(j+1,i));
                    end
                end
            end
            if (area(j,i) == 1) % down
                [Q(j,i),Q(j+1,i)]=flow_updown(Q(j,i),Q(j+1,i));
            end
        end
    end
    %HI = [HI in_flow];
    HF = [HF cur_flow];
    SUM = [SUM  s];
    HO = [HO Out];
    %in_flow = 0;
    Out = 0;
    drawnow
    
%     subplot(3,1,1);
%     plot(SUM);
%     title('throughput sum');
%     subplot(3,1,2);
%     plot(HF);
%     title('q in plaza');
%     subplot(3,1,3);
%     plot(HO);
%     title('current out q');
%     draw_m(Q);
    %pause(0.01);
    end
    %s
    draw_m(Q);
    %matrixplot(Q,'DisplayOpt','off','FigSize','Auto','ColorBar','on');
end

function v=calv(q)
    v=1/(1+exp(q*3-7));
    %v=max(v,0.1);
    return
end


function [q,qd,ql]=flow_div(q,qd,ql)
    k=0.9;
    if(qd<ql)
        dq = k*q*calv(qd);
        q = q - dq;
        qd = qd +dq;
        dq = q*calv(ql);
        q = q-dq;
        ql = ql + dq;
    else
        dq = q*calv(ql);
        q = q - dq;
        ql = ql +dq;
        dq = k*q*calv(qd);
        q = q-dq;
        qd = qd + dq;
    end
    return
end

function [q,qf]=flow_forward(q,qf)
    v=calv(qf);
    %vf=calv(qf);
    dq = v*q;
    q = q-dq;
    qf = qf+dq;
    return
end

function [q,qu]=flow_updown(q,qu)
    k=0.8;
    dq = k*q*calv(qu);
    q = q-dq;
    qu = qu+dq;
    return
end