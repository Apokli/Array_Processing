% Hanyuan Ban (5519829) and Junzhe Yin (5504325) Array Processing Codes
% 
% Part 1: ESTIMATION OF DIRECTIONS AND FREQUENCIES
% Signal Model:
%     model parameters
    M = 5;               % the number of antennas
    N = 20;              % the number of samples
    Delta = 0.5;         % antenna spacing per wavelength, commonly 0.5
    theta = [-20, 30].'; % directions of sources in degrees (-90, 90)
    f = [0.1, 0.3].';    % normalized frequency of sources [0, 1)
    SNR = 60;     
    
%     signal to noise ratio per source
%     
%     apply the signal model
    [X, A, S] = gendata(M, N, Delta, theta, f, SNR);
    
%     singular value decompostion
    sv = svd(X);
    figure(1);
    plot(1:length(sv), sv, '-*')
    title("Singular Values of X")
%       
%     % double number of sample
%     N = 40;
%     [X, A, S] = gendata(M, N, Delta, theta, f, SNR);
%     sv1 = svd(X);
%     figure;
%     plot(1:length(sv1), sv1, '-*')
%     title("Singular Values of X with double N")
%         
%     % double number of antennas
%     N = 20;
%     M = 10;
%     [X, A, S] = gendata(M, N, Delta, theta, f, SNR);
%     sv2 = svd(X);
%     figure;
%     plot(1:length(sv2), sv2, '-*')
%     title("Singular Values of X with double M")
%     
%     % smaller angle
%     N = 20;
%     M = 5;
%     theta = [-10, 15].';
%     [X, A, S] = gendata(M, N, Delta, theta, f, SNR);
%     sv3 = svd(X);
%     figure;
%     plot(1:length(sv3), sv3, '-*')
%     title("Singular Values of X with small angle")
% 
%     % smaller frequency
%     N = 20;
%     M = 5;
%     theta = [-20, 30].';
%     f = [0.1, 0.15].';  
%     [X, A, S] = gendata(M, N, Delta, theta, f, SNR);
%     sv4 = svd(X);
%     figure;
%     plot(1:length(sv4), sv4, '-*')
%     title("Singular Values of X with small frequency")


%% Estimation of Directions
    esprit_angle = esprit(X, size(theta, 1));  % esprit estimating angles


%% Estimation of Frequencies
    esprit_freq = espritfreq(X, size(f, 1));  % esprit estimating angles