function res = getTimeFromPoints(startPoint, endPoint, Points, windX,windY)
    %Points is a matrix X,Y coordinates
    
    X = [startPoint;Points;endPoint];
    
    totalTime = 0;
    for step = 1:length(X)-1
        interpolated_path = makeMorePoints(X(step,:),X(step+1,:), 15);
        totalTime = totalTime + speedOfPath(interpolated_path);
    end
    res = totalTime;
    
    function res = makeMorePoints(p1, p2, n)
        %n is the number of extra points that we want to add
        %(for interpolation purposes)
        res =[];
        for i = 1:n+2
            res(i,1) = p1(1) + ((p2(1) - p1(1))/(n+1)) * (i-1);
            res(i,2) = p1(2) + ((p2(2) - p1(2))/(n+1)) * (i-1);
        end
        res;
    end

    function res = speedOfPath(path)
        %X_wind = interp2(windX, path(:,1), path(:,2), 'linear');
        %Y_wind = interp2(windY, path(:,1), path(:,2), 'linear');
        X_wind = -1.4142*ones(17,1);
        Y_wind = 1.4142*ones(17,1);
        time = 0;
        for i = 1:length(path)-1
            angle = windangle(path(i,:), path(i+1,:), X_wind(i), Y_wind(i));
            if angle > 180
                angle = 360 -angle;
            end
            %windthing = [X_wind(i),Y_wind(i)]
            %normthing = norm([X_wind(i),Y_wind(i)])
            speed = norm([X_wind(i),Y_wind(i)])*(angle-pi/6)/(pi);
            if speed > 0
                time = time + distancebetweenpoints(path(i,:),path(i+1,:))/speed;     
            else
                time = time + distancebetweenpoints(path(i,:),path(i+1,:))*100000;
            end
        end
        res = time;
    end
    
    function res = distancebetweenpoints(p1,p2)
        dx = p2(1) - p1(1);
        dy = p2(2) - p1(2);
        res = norm([dx,dy]);
    end

    function res = windangle(p1,p2, wX, wY)
        pathx = p2(1) - p1(1);
        pathy = p2(2) - p1(2);
        wind = [wX, wY];
        path = [pathx, pathy];
        res = acos(dot(wind,path)/(norm(wind)*norm(path)));
    end
end