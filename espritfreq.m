function f = espritfreq(X, d)
% espritfreq - estimates the frequency using esprit algorithm
%                   
% Inputs:
%   X - the signals received at antennas
%   d - the number of sources
    m = size(X, 1);   % number of antennas
    k = size(X, 2);  % data sample length
   
    x1 = X(:, 1:k-1);
    x2 = X(:, 2:k);
    Xt = [x1;x2];
    
    [U, S, V]=svd(Xt);
    Us = U(:, 1:d);
    Us1 = Us(1:m, :);
    Us2 = Us(m+1:2*m, :);
    M = Us1 \ Us2;
    
    [evc, eva]=eig(M);
    eva = (diag(eva)).';
    f = angle(eva)/(2*pi);
end

