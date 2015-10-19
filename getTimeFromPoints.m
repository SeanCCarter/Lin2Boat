function res = getTimeFromPoints(startPoint, endPoint, Points, windX,windY)
    %Points is a matrix X,Y coordinates
    
    X = [startPoint;Points;endPoint];
    
    time = 0;
    for i = 1:length(X)-1
        %determine relative wind angle
        angle = windangle(X(i,:),X(i+1,:));
        if angle > pi
            angle = 2*pi - angle;
        end
        
        %determine speed on this tack
        speed = speedofboat(angle);
        
        %determine how long travel to the next point will take
        %if speed > 0
            time = time + distancebetweenpoints(X(i,:),X(i+1,:))/speed;     
        %else
        %    time = time + distancebetweenpoints(X(i,:),X(i+1,:))*100000;
        %end
        
        %add penalty for tacking
        if i < (length(X) - 1)
            time = time + tacktime(X(i,:), X(i+1,:), X(i+2,:));
        end
        
    end
    res = time;

    function res = speedofboat(ang)
        spd = norm([windX,windY])*(ang)/(pi);
        if ang < 30
            spd = abs(ang/10);
        end
        res = spd;
    end
    
    function res = distancebetweenpoints(p1,p2)
        dx = p2(1) - p1(1);
        dy = p2(2) - p1(2);
        res = norm([dx,dy]);
    end

    function res = windangle(p1,p2)
        %given the start and end points of a leg
        %returns the angle between the wind and the boat's heading
        pathx = p2(1) - p1(1);
        pathy = p2(2) - p1(2);
        wind = [windX, windY];
        path = [pathx, pathy];
        windang = atan(windY/windX);
        pathang = atan(pathy/pathx);
        res = pathang - windang;
        %res = acos(dot(wind,path)/(norm(wind)*norm(path)));
    end

    function res = tacktime(p1, p2, p3)
        %given three waypoints
        %determines how long it takes to adjust course at p2
        angle1 = windangle(p1, p2);
        disp(angle1)
        if angle1 > pi
            angle1 = angle1 - 2*pi;
        end
        
        angle2 = windangle(p2, p3);
        if angle2 > pi
            angle2 = angle2 - 2*pi;
        end
              
        if sign(angle1) == sign(angle2)
            delay = 0;
        else
            delay = 1;
        end

        res = delay;
    end
        
end