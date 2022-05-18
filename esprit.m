function theta = esprit(X, d)
% esprit - estimates the angle using esprit algorithm
%                   
% Inputs:
%   X - the signals received at antennas
%   d - the number of sources
    m = size(X, 1) - 1; % number of antennas - 1
    x1 = X(1:m, :);
    x2 = X(2:m+1, :);
    Xt = [x1;x2];
    
    [U, S, V]=svd(Xt);
    Us = U(:, 1:d);
    Us1 = Us(1:m, :);
    Us2 = Us(m+1:2*m, :);
    M = pinv(Us1) * Us2;
    
    [evc, eva]=eig(M);
    eva = (diag(eva)).';
    theta = asin(angle(eva)/pi)*180/pi;
end

