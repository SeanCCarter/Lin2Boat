function res = getTimeFromPoints(startPoint, endPoint, Points, windX, windY)
    % Objective function for letsdoathing.m
    % takes in [x, y] start and end points, a list of waypoints, 
    % and matrices of the x and y components of wind at each point.
    
    % append the start and end points to the matrix of waypoints
    X = [startPoint;Points;endPoint];
    
    % initialize time taken
    totalTime = 0;
    
    for step = 1:length(X)-1
        % interpolate between each two consecutive points
        interpolated_path = makeMorePoints(X(step,:),X(step+1,:), 15);
        
        % add time taken to sail this segment
        totalTime = totalTime + speedOfPath(interpolated_path);
        
        % add penalty for tacking on all but the last step
        if step < (length(X) - 1)
            tackwindx = interp2(windX, X(step+1,1), X(step+1,2));
            tackwindy = interp2(windY, X(step+1,1), X(step+1,2));
            totalTime = totalTime + tacktime(X(step,:), X(step+1,:), X(step+2,:), tackwindx, tackwindy);
        end
    end
    % return time taken
    res = totalTime;
    
    function res = makeMorePoints(p1, p2, n)
        % returns a list of n points between [x,y] points p1 and p2
        res =[];
        for i = 1:n+2
            res(i,1) = p1(1) + ((p2(1) - p1(1))/(n+1)) * (i-1);
            res(i,2) = p1(2) + ((p2(2) - p1(2))/(n+1)) * (i-1);
        end
    end
           
    function res = speedOfPath(path)
        % takes in a list of waypoints
        % returns the time it takes to sail that path
        % not counting tacking delays
        
        % use MATLAB's built in interpolation to find wind along the path
        X_wind = interp2(windX, path(:,1), path(:,2), 'linear');
        Y_wind = interp2(windY, path(:,1), path(:,2), 'linear');
        
        % initialize time taken
        time = 0;
        for i = 1:length(path)-1
            % determine relative wind angle
            angle = abs(windangle(path(i,:), path(i+1,:), X_wind(i), Y_wind(i)));
            
            % Finding the boat speed based on relative wind angle
            speed = norm([X_wind(i), Y_wind(i)])*(0.45*cos(angle) + 0.55);
            
            % add time for this leg to total time
            time = time + distancebetweenpoints(path(i,:),path(i+1,:))/speed;
        end
        
        % return time taken
        res = time;
    end
    
    function res = distancebetweenpoints(p1,p2)
        % simple distance between two points calculation
        dx = p2(1) - p1(1);
        dy = p2(2) - p1(2);
        res = norm([dx,dy]);
    end

    function res = windangle(p1,p2, wX, wY)
        % given two [x,y] points and the wind X and Y values
        % returns the angle between the wind and the boat heading
        % from -pi to pi. starboard tack is positive.
        pathx = p2(1) - p1(1);
        pathy = p2(2) - p1(2);
        wnd = atan2(wY,wX);
        pth = atan2(pathy, pathx);
        ang = pi - (wnd - pth);
        %disp([wnd, pth, ang])
        if ang > pi
            ang = ang - 2*pi;
        end
        res = ang;
    end
    
    function res = tacktime(p1, p2, p3, wx, wy)
        % given three waypoints and the x and y wind components,
        % determines whether the boat changes tack at p2
        angle1 = windangle(p1, p2, wx, wy);
        angle2 = windangle(p2, p3, wx, wy);
        % starboard tack is a positive angle, port tack is negative.
        % sign of angle changes if tack changes
        if sign(angle1) == sign(angle2)
            delay = 0;
        else
            delay = 15;
        end

        res = delay;
    end
        
end