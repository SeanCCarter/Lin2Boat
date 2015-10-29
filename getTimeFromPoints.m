function res = getTimeFromPoints(startPoint, endPoint, Points, windX,windY)
    %Points is a matrix X,Y coordinates
    
    X = [startPoint;Points;endPoint];
    
    totalTime = 0;
    for step = 1:length(X)-1
        interpolated_path = makeMorePoints(X(step,:),X(step+1,:), 15);
        totalTime = totalTime + speedOfPath(interpolated_path);
        %add penalty for tacking
        if step < (length(X) - 1)
            tackwindx = interp2(windX, X(step+1,1), X(step+1,2));
            tackwindy = interp2(windY, X(step+1,1), X(step+1,2));
            totalTime = totalTime + tacktime(X(step,:), X(step+1,:), X(step+2,:), tackwindx, tackwindy);
        end
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
    end
           

    function res = speedOfPath(path)
        X_wind = interp2(windX, path(:,1), path(:,2), 'linear');
        Y_wind = interp2(windY, path(:,1), path(:,2), 'linear');
        time = 0;
        for i = 1:length(path)-1
            %determine relative wind angle
            angle = windangle(path(i,:), path(i+1,:), X_wind(i), Y_wind(i));
            if angle > pi
                angle = 2*pi - angle;
            end
            
            %Finding the boat speed
            %ooh aah limacon
            speed = norm([X_wind(i), Y_wind(i)])*(0.45*cos(angle) + 0.55);
%             speed = norm([X_wind(i),Y_wind(i)])*(angle-pi/6)/(pi);
%             if angle < 30
%                 speed = abs(angle/10);
%             end
            time = time + distancebetweenpoints(path(i,:),path(i+1,:))/speed;
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
        wnd = atan2(wY,wX);
        pth = atan2(pathy, pathx);
        ang = pi - (wnd - pth);
        disp([wnd, pth, ang])
        if ang > pi
            ang = ang - 2*pi;
        end
        res = ang;
    end
    
    function res = tacktime(p1, p2, p3, wx, wy)
        %given three waypoints
        %determines how long it takes to adjust course at p2
        angle1 = windangle(p1, p2, wx, wy);
        if angle1 > pi
            angle1 = angle1 - 2*pi;
        end
        
        angle2 = windangle(p2, p3, wx, wy);
        if angle2 > pi
            angle2 = angle2 - 2*pi;
        end
              
        if sign(angle1) == sign(angle2)
            disp('Didnt delay')
            delay = 0;
        else
            disp('Did delay')
            delay = 5;
        end

        res = delay;
    end
        
end