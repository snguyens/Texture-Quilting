function [path] = shortest_path(costs)

%
% given a 2D array of costs, compute the minimum cost vertical path
% from top to bottom which, at each step, either goes straight or
% one pixel to the left or right.
%
% costs:  a HxW array of costs
%
% path: a Hx1 vector containing the indices (values in 1...W) for 
%       each step along the path
%
%
%

%Psuedocode:
%start at bottom, initialize S1(i) = e(1,i)
%for i = 2, n use formula to compute Si+1(.)
%Si(J) = e(i,j) + min{Si-1(j-1)
%                     Si-1(j)
%                     Si-1(j+1)}
%pick best among top row, backtrack

%Initialize height and width variables
[n, m] = size(costs);

%Create a matrix to store the costs
S = zeros(n, m);

%Fill in first row since there are no energies above it
S(1,:) = costs(1,:);

%Use dynamic programming to fill in the rest of the matrix
for i = 2:n
    for j = 1:m
        if (j == 1)
            S(i,j) = costs(i,j) + min([S(i-1,j) S(i-1,j+1)]);
        elseif (j == m)
            S(i,j) = costs(i,j) + min([S(i-1,j-1) S(i-1,j)]);
        else
            S(i,j) = costs(i,j) + min([S(i-1,j-1) S(i-1,j) S(i-1,j+1)]);
        end
    end
end

%Initialize matrix to store path locations from 1...W for each H rows.
path = zeros(n, 1);

%Search last row of cost matrix to find the smallest cost
[minValue, minIndex] = min(S(n,:));

%After minimum value is found, place that index in last index of path
path(n, 1) = minIndex;

%Use backtracking to fill in remaining indexes for path location
for i = (n):-1:2
    minValue = Inf;
    tempY = minIndex;
    if (tempY ~= 1 && S(i-1, tempY-1) < minValue)
        minValue = S(i-1, tempY-1);
        minIndex = tempY-1;
    end
    if (S(i-1, tempY) < minValue)
        minValue = S(i-1, tempY);
        minIndex = tempY;
    end  
    if (tempY ~= m && S(i-1, tempY+1) < minValue)
        minValue = S(i-1, tempY+1);
        minIndex = tempY+1;         
    end    
    path(i-1, 1) = minIndex;    
end