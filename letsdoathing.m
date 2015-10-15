function res = letsdoathing(nWaypoints, startPoint, endPoint)

    nWaypoints = 4;
    startPoint = [2,-1];
    endPoint = [1,1];
    windSpeed = 0;
    windDirection = 0;
    
    X0 = [];
    %Navigating from -1,-1 to 1,1
    for i = 1:nWaypoints
        X0(i,1) = startPoint(1) + ((endPoint(1) - startPoint(1))/(nWaypoints+1)) * i;
        X0(i,2) = startPoint(2) + ((endPoint(2) - startPoint(2))/(nWaypoints+1)) * i;
    end
    
    X0(2,2) = 0.1
    
    [x, fval] = fminunc(@(Points)getTimeFromPoints(startPoint, endPoint, Points, windSpeed, windDirection), X0)
    
    clf
    thing = [startPoint;x;endPoint];
    plot(thing(:,1),thing(:,2))
    
    
end