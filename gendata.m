function [X, A, S] = gendata(M, N, Delta, theta, f, SNR)
% gendata - generates the RADAR signal data
%                   
% Inputs:
%   M - the number of antennas
%   N - the number of samples
%   Delta - antenna spacing per wavelength, commonly 0.5
%   theta - directions of sources in degrees (-90, 90)
%   f - normalized frequency of sources [0, 1)
%   SNR - signal to noise ratio per source

    degree2rad = pi/180;
    K = 0: 511; % signal samples
    d = 0: Delta: (M-1) * Delta; 
    A = exp(1i * 2 * pi * d.' * sin(theta * degree2rad).');  % Array Response Vector
    
    S = exp(1i * 2 * pi * f * K);      % Source Signal
    X = A * S;                    % Received Signal
    X = awgn(X, SNR, 'measured'); % Add Noise
end