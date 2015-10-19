function res = letsdoathing(nWaypoints, startPoint, endPoint)
    % set number of waypoints, start point, and end point
    nWaypoints = 4;
    startPoint = [2,1];
    endPoint = [1,2];
    
    % wangle is the direction the wind is COMING FROM
    % wind speed is in knots
    wangle = 5*pi/4;
    wspeed = 2;
    % x and y values of wind vector are calculated
    % n is the number of values in the grid
    n = 10;
    windX = wspeed*cos(wangle)*ones(n);
    windY = wspeed*sin(wangle)*ones(n);
    
    % generates a random squiggle sort of between the points as first guess
    X0 = [];
    for i = 1:nWaypoints
        X0(i,1) = startPoint(1) + (rand*(endPoint(1) - startPoint(1))/(nWaypoints+1)) * i;
        X0(i,2) = startPoint(2) + (rand*(endPoint(2) - startPoint(2))/(nWaypoints+1)) * i;
    end
    
    %X0(1,1) = -0.1
    %X0(2,1) = .1
    
    hold on
        
    [x, fval] = fminunc(@(Points)getTimeFromPoints(startPoint, endPoint, Points, windX, windY), X0)
    
    clf
    thing = [startPoint;x;endPoint];
    hold on
    plot(X0(:,1), X0(:,2),'g')
      %quiver(1,1,windX, windY)
    plot(thing(:,1),thing(:,2),'r')
    plot(thing(:,1),thing(:,2),'r.')
    
    axis equal
    res = fval;    
end