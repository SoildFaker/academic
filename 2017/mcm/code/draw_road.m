function draw_road()
    figure;
    hold on;
    al=10;
    bl=3;
    cl=8;
    ay1=-2;
    ay2=4;
    by1=0;
    by2=2;
    ap1=[al,ay1];
    ap2=[al,ay2];
    bp1=[al+cl,by1];
    bp2=[al+cl,by2];
    rectangle('Position',[0 -2.25 2 abs(ay2)+abs(ay1)+0.5],'Curvature',0.2,'LineWidth',6);
    axis([0,(al+cl+bl),-20,20])
    plot([0,al], [ay1,ay1],'k','LineWidth',6);
    plot([0,al], [ay2,ay2],'k','LineWidth',6);
    plot([al+cl,al+cl+bl], [by1,by1],'k','LineWidth',6);
    plot([al+cl,al+cl+bl], [by2,by2],'k','LineWidth',6);
    bezier3(ap2, ap2+[3,0], bp2-[3,0], bp2);
    bezier3(ap1, ap1+[3,0], bp1-[3,0], bp1);
end
function bezier3(p0,p1,p2,p3) 
    t=0:0.001:1;  
    x=(1-t).^3*p0(1)+3*t.*(1-t).^2*p1(1)+3*t.^2.*(1-t)*p2(1)+t.^3*p3(1);
    y=(1-t).^3*p0(2)+3*t.*(1-t).^2*p1(2)+3*t.^2.*(1-t)*p2(2)+t.^3*p3(2);
    %plot([p0(1) p1(1) p2(1) p3(1)],[p0(2) p1(2) p2(2) p3(2)],'r'); 
    plot(x,y,'k','LineWidth',6); 
end
