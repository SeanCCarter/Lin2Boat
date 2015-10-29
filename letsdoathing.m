function res = letsdoathing(nWaypoints, startPoint, endPoint)
    % Sean Carter and Rebecca Jordan's Linearity II Optimization Project
    % takes in a number of waypoints to place, 
    % and [x, y] start and end points. 
    % plots the fastest sailing path across a randomly generated windfield
    % returns the time taken to reach endpoint

    % set number of waypoints, start point, and end point
    nWaypoints = nWaypoints;
    startPoint = startPoint;
    endPoint = endPoint;
    
    % wangle is the direction the wind is COMING FROM
    % wind speed is in m/s
    wangle = 3*pi/4 ;
    wspeed = 2;
    
    % x and y matrices are generated based on the wind speed and direction
    % n is the number of values in the grid
    % at any [x, y] point the x and y components of the wind vectors are 
    % the values at those indices in the x and y matrices respectively.
    n = 30;
    windX = makeWindFun(n,n);
    windY = makeWindFun(n,n);
    
    % generates a random squiggle sort of between the points as first guess
    X0 = [];
    for i = 1:nWaypoints
        X0(i,1) = startPoint(1) + (rand*(endPoint(1) - startPoint(1))/(nWaypoints+1)) * i;
        X0(i,2) = startPoint(2) + (rand*(endPoint(2) - startPoint(2))/(nWaypoints+1)) * i;
    end
    
    % run the optimization
    [x, fval] = fmincon(@(Points)getTimeFromPoints(startPoint, endPoint, Points, windX, windY), X0, [], [], [], [], ones(nWaypoints, 2), Inf)
    
    %append the start and end points to the list of waypoints
    fullpath = [startPoint;x;endPoint];
    
    %graphing code
    clf
    hold on
    
    % initial guess
    %plot(X0(:,1), X0(:,2),'g')
    
    % wind vector
    quiver(-1.*windX, -1.*windY)
    
    % path, with dots at waypoints
    plot(fullpath(:,1),fullpath(:,2),'r')
    plot(fullpath(:,1),fullpath(:,2),'r.')
    
    axis([10,20,10,20])
    legend('Wind', 'Optimal Path')
    axis equal
    res = fval;    
end