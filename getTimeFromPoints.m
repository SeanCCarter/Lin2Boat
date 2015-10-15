function res = getTimeFromPoints(startPoint, endPoint, Points, windSpeed,windDirection)
    %Points is a matrix X,Y coordinates
   
    X = [startPoint;Points;endPoint];
    
    time = 0;
    for i = 1:length(X)-1
        time = time + distancebetweenpoints(X(i,:),X(i+1,:))*speedofboat;
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
end