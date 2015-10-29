function res = letsdoathing(nWaypoints, startPoint, endPoint)
    % set number of waypoints, start point, and end point
    nWaypoints = nWaypoints;
    startPoint = startPoint;
    endPoint = endPoint;
    
    % wangle is the direction the wind is GOING TOWARD
    % wind speed is in knots
    wangle = 5*pi/4;
    wspeed = 2;
    % x and y values of wind vector are calculated
    % n is the number of values in the grid
    n = 100;
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
    
    [x, fval] = fmincon(@(Points)getTimeFromPoints(startPoint, endPoint, Points, windX, windY), X0, [], [], [], [], ones(nWaypoints, 2), Inf)
    
    clf
    thing = [startPoint;x;endPoint];
    hold on
    plot(X0(:,1), X0(:,2),'g')
    quiver(endPoint(1), endPoint(2),windX(1), windY(1),'b')
    plot(thing(:,1),thing(:,2),'r')
    plot(thing(:,1),thing(:,2),'r.')
    
    axis equal
    res = fval;    
end