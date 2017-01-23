
function s=merge_sim()
    area = [
        3 1 0 0 0 0 0 0 0 0 0 0 0;
        3 3 3 3 1 0 0 0 0 0 0 0 0;
        3 3 3 3 3 3 3 1 0 0 0 0 0;
        3 3 3 3 3 3 3 3 3 3 1 0 0;
        2 2 2 2 2 2 2 2 2 2 2 2 2;
        %2 2 2 2 2 2 2 2 2 2 2 2 2;
        2 2 2 2 2 2 2 2 2 2 2 2 2;
        6 6 6 6 6 6 6 6 6 6 4 0 0;
        6 6 6 6 6 6 6 4 0 0 0 0 0;
        6 6 6 6 4 0 0 0 0 0 0 0 0;
        6 4 0 0 0 0 0 0 0 0 0 0 0;
    ];
    auto = [0 0];
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
    hold on
    for t=0:79
    for i=1:C
        for j=1:round(L/2)
            cj=L-j+1;
            if (i == 1)
                k = 0.9;
                if (calv(Q(j,i))>0.5)
                    in = k*(poisspdf(j,round(L/2+1)));%* calv(Q(j,i))
                    if(j==4||j==5)
                        %in = in*1.4;
                    end
                    Q(j,i) = Q(j,i)+in;
                    %in_flow = in_flow + in;
                     cur_flow = cur_flow + in;
                end
                if (calv(Q(cj,i))>0.5)
                    in = k*(poisspdf(cj,L/2));%* calv(Q(j,i))
                    Q(cj,i) = Q(cj,i)+in;
                    %in_flow = in_flow + in;
                     cur_flow = cur_flow + in;
                end
            end
            if (area(j,i) == 3)
                [Q(j,i),Q(j+1,i),Q(j,i+1)]=flow_div(Q(j,i),Q(j+1,i),Q(j,i+1));
            end
            if(cj == j)
                if(i==C)
                    div = Q(j,i) *calv(Q(j,i));
                    Out = Out + div;
                    s = s + Out;
                    cur_flow = cur_flow - div ;
                    Q(j,i) = Q(j,i) - div;
                else
                    [Q(j,i),Q(j,i+1)]=flow_forward(Q(j,i),Q(j,i+1));
                end
            end
            if (area(cj,i) == 2 && cj ~= j)
                if(i==C)
                    div = Q(cj,i) * calv(Q(cj,i));
                    Out = Out + div;
                    s = s + Out;
                    cur_flow = cur_flow - div ;
                    Q(cj,i) = Q(cj,i) - div;
                else
                    [Q(cj,i),Q(cj,i+1)]=flow_forward(Q(cj,i),Q(cj,i+1));
                    if(area(cj-1,i)==2)
                        [Q(cj,i),Q(cj-1,i)]=flow_updown(Q(cj,i),Q(cj-1,i));
                    end
                end
            end
            if (area(j,i) == 2 && cj ~= j)
                if(i==C)
                    div = Q(j,i) * calv(Q(j,i));
                    Out = Out + div;
                    s = s + Out;
                    cur_flow = cur_flow - div ;
                    Q(j,i) = Q(j,i) - div;
                else
                    [Q(j,i),Q(j,i+1)]=flow_forward(Q(j,i),Q(j,i+1));
                    if(area(j+1,i)==2)
                       [Q(j,i),Q(j+1,i)]=flow_updown(Q(j,i),Q(j+1,i));
                    end
                end
            end
            if (area(j,i) == 1) % down
                [Q(j,i),Q(j+1,i)]=flow_updown(Q(j,i),Q(j+1,i));
            end
            
            if (area(cj,i) == 4) % up
                 [Q(cj,i),Q(cj-1,i)]=flow_updown(Q(cj,i),Q(cj-1,i));
            end
            if (area(cj,i) == 6) % up left
                [Q(cj,i),Q(cj-1,i),Q(cj,i+1)]=flow_div(Q(cj,i),Q(cj-1,i),Q(cj,i+1));
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
    
    subplot(3,1,1);
    plot(SUM);
    title('throughput sum');
    subplot(3,1,2);
    plot(HF);
    title('q in plaza');
    subplot(3,1,3);
    plot(HO);
    title('current out q');
    
    %draw_m(Q);
    %pause(0.01);
    end
    %s
    %draw_m(Q);
    %matrixplot(Q,'DisplayOpt','off','FigSize','Auto','ColorBar','on');
end

function v=calv(q)
    v=2/(1+exp(q));
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
    k=0.3;
    dq = k*q*calv(qu);
    q = q-dq;
    qu = qu+dq;
    return
end


