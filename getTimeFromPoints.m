function res = getTimeFromPoints(startPoint, endPoint, Points, windX,windY)
    %Points is a matrix X,Y coordinates
    
    X = [startPoint;Points;endPoint];
    
    time = 0;
    for i = 1:length(X)-1
        angle = windangle(X(i,:),X(i+1,:));
        if angle > 180
            angle = 360 -angle;
        end
        speed = norm(windX,windY)*(angle-pi/6)/(pi);
        if speed > 0
            time = time + distancebetweenpoints(X(i,:),X(i+1,:))/speed;     
        else
            time = time + distancebetweenpoints(X(i,:),X(i+1,:))*100000;
        end
        
    end
    res = time;

    function res = speedofboat()
        res = 10;
    end
    
    function res = distancebetweenpoints(p1,p2)
        dx = p2(1) - p1(1);
        dy = p2(2) - p1(2);
        res = norm([dx,dy]);
    end

    function res = windangle(p1,p2)
        pathx = p2(1) - p1(1);
        pathy = p2(2) - p1(2);
        wind = [windX, windY];
        path = [pathx, pathy];
        res = acos(dot(wind,path)/(norm(wind)*norm(path)));
    end
end