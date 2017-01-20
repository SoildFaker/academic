
function merge_sim()
    area = [
        3 1 0 0 0 0 0 0 0 0 0 0;
        3 3 3 3 1 0 0 0 0 0 0 0;
        3 3 3 3 3 3 3 1 0 0 0 0;
        3 3 3 3 3 3 3 3 3 3 1 0;
        2 2 2 2 2 2 2 2 2 2 2 2;
        %2 2 2 2 2 2 2 2 2 2 2 2;
        %2 2 2 2 2 2 2 2 2 2 2 2;
        6 6 6 6 6 6 6 6 6 6 4 0;
        6 6 6 6 6 6 6 4 0 0 0 0;
        6 6 6 6 4 0 0 0 0 0 0 0;
        6 4 0 0 0 0 0 0 0 0 0 0;
    ];
    C = 12;
    L = 9;
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
    for t=0:250
    for i=1:C
        for j=1:L
            if (i == 1)
                if (Q(j,i+1)<2)
                    in = 10*rand*calv(Q(j,i+1));
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
                    cur_flow = cur_flow - div;
                    Q(j,i) = Q(j,i) - div;
                else
                    [Q(j,i),Q(j,i+1)]=flow_forward(Q(j,i),Q(j,i+1));
                end
            end
            if (area(j,i) == 1) % down
                [Q(j,i),Q(j+1,i)]=flow_updown(Q(j,i),Q(j+1,i));
            end
            if (area(j,i) == 4) % up
                 [Q(j,i),Q(j-1,i)]=flow_updown(Q(j,i),Q(j-1,i));
            end
            if (area(j,i) == 6) % up left
                [Q(j,i),Q(j-1,i),Q(j,i+1)]=flow_div(Q(j,i),Q(j-1,i),Q(j,i+1));
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
    %matrixplot(Q,'DisplayOpt','off','FigSize','Auto','ColorBar','on');
    subplot(3,1,1);
    %draw_m(Q);
    %plot(HI);
    plot(SUM);
    subplot(3,1,2);
    plot(HF);
    subplot(3,1,3);
    plot(HO);
    pause(0.01);
    end
end

function [q,qd,ql]=flow_div(q,qd,ql)
    k1 = 0.5;
    v=calv(q);
    vd=calv(qd);
    vl=calv(ql);
    dq = v*q;
    div = dq*(k1/(qd+1));
    qd = qd+vd*div;
    ql = ql + vl*(dq-div);
    q = q-dq;
    return
end

function [q,qf]=flow_forward(q,qf)
    k1 = 0.5;
    v=calv(q);
    vf=calv(qf);
    dq = v*q;
    q = q-dq;
    div = dq*(k1/(qf+1));
    qf = qf+vf*div;
    return
end

function [qu,q]=flow_updown(q,qu)
    k1 = 0.5;
    v=calv(q);
    vu=calv(qu);
    dq = v*q;
    q = q-dq;
    div = dq*(k1/(qu+1));
    qu = qu+vu*div;
    return
end

function v=calv(q)
    k2=0.5;
    v=k2/(q+1);
    return
end

function draw_m(M)
[l,c] = size(M);

for x=1:l
    for y=1:c
        fx=[x-1,x,x,x-1];
        fy=[y-1,y-1,y,y];
        
        if M(x,y)>9
            fill(fx,fy,[9/M(x,y) 0.1 0]);
        elseif M(x,y)>5
            fill(fx,fy,[5/M(x,y) 0.1 0]);
        elseif M(x,y)>1
            fill(fx,fy,[1/M(x,y) 0.1 0]);
        end
        
    end
end
end