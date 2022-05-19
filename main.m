%% Hanyuan Ban (5519829) and Junzhe Yin () Array Processing Codes

%% Part 1: ESTIMATION OF DIRECTIONS AND FREQUENCIES
%% Signal Model:
    % model parameters
    M = 5;               % the number of antennas
    N = 20;              % the number of sources
    Delta = 0.5;         % antenna spacing per wavelength, commonly 0.5
    theta = [-20, 30, 50].'; % directions of sources in degrees (-90, 90)
    f = [0.1, 0.3, 0.4].';    % normalized frequency of sources [0, 1)
    SNR = 20;            % signal to noise ratio per source
    K = 512;             % signal samples
    
    % apply the signal model
    [X, A, S] = gendata(M, N, Delta, theta, f, SNR);
    
    % singular value decompostion
%     sv = svd(X);
%     plot(1:length(sv), sv, '-*')
%     title("Singular Values of X")

%% Estimation of Directions
    esprit_angle = esprit(X, size(theta, 1));  % esprit estimating angles
%% Estimation of Frequencies
    esprit_freq = espritfreq(X, size(theta, 1));  % esprit estimating angles

    