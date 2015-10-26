function res = findthebestthing(startPoint, endPoint)

    numbers = timefortack(3)

    function res = timefortack(npoints)
        %finds a fast route with the given number of tacks
        %returns the time taken and the path to get that time
        
        %get a first estimate of time by starting with a straight line
        %guess
        n = npoints;
        firstguess = lineguess(6)
        mintime = letsdoathing(npoints, firstguess, startPoint, endPoint); 
        %try five randomly generated start points. 
        for i = 1:5
            [a, path] = letsdoathing(npoints, randguess(npoints), startPoint, endPoint);
            if a > mintime
                mintime = a;
                bestpath = path;
            end
        end
        res = [mintime, bestpath];
    end

    function res = lineguess(nwaypoints)
        %generates a straight line of a certain number of waypoints between
        %start and end, for use as a first guess input of letsdoathing
        %nwaypoints = nwaypoints;
        res = zeros(nwaypoints, 2);
        for i = 1:nwaypoints
            res(i,1) = startPoint(1) + ((endPoint(1) - startPoint(1))/(nwaypoints+1)) * i;
            res(i,2) = startPoint(2) + ((endPoint(2) - startPoint(2))/(nwaypoints+1)) * i;
        end
        %res = guess;
    end

    function res = randguess(nWaypoints)
        %generates a random squiggle between the start and end points, for
        %use as a first guess input of letsdoathing
        for i = 1:nWaypoints
            guess(i,1) = startPoint(1) + (rand*(endPoint(1) - startPoint(1))/(nWaypoints+1)) * i;
            guess(i,2) = startPoint(2) + (rand*(endPoint(2) - startPoint(2))/(nWaypoints+1)) * i;
        end
        res = guess;
            
    end
end