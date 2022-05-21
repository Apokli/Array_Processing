%% Hanyuan Ban (5519829) and Junzhe Yin () Array Processing Codes

%% Part 1: ESTIMATION OF DIRECTIONS AND FREQUENCIES
%% Signal Model:
    % model parameters
    M = 5;               % the number of antennas
    N = 20;              % the number of samples
    Delta = 0.5;         % antenna spacing per wavelength, commonly 0.5
    theta = [-20, 30, 50].'; % directions of sources in degrees (-90, 90)
    f = [0.1, 0.3, 0.4].';    % normalized frequency of sources [0, 1)
    SNR = 20;            % signal to noise ratio per source
    
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
%% Joint estimation of directions and frequencies
%     j_theta, j_freq = joint(X, d, m);

%% Comparison
    M = 3;               % the number of antennas
    N = 20;              % the number of sources
    Delta = 0.5;         % antenna spacing per wavelength, commonly 0.5
    theta = [-20, 30].'; % directions of sources in degrees (-90, 90)
    f = [0.1, 0.12].';    % normalized frequency of sources [0, 1)
    SNR = [0, 4, 8, 12, 16, 20];            % signal to noise ratio per source
    
    % angle estimation
    angles = zeros(6, 1000, 2);
    for i = 1:length(SNR)
        for j = 1:1000
            [X, A, S] = gendata(M, N, Delta, theta, f, SNR(i));
            angles(i, j, :) = esprit(X, size(theta, 1));
        end
    end
    angle_params = [mean(angles(:, :, 1), 2), std(angles(:, :, 1), 0, 2), mean(angles(:, :, 2), 2), std(angles(:, :, 2), 0, 2)];
    plt = plot(SNR, angle_params, '-*', 'Linewidth', 2);
    hold on
    plot([0, 20], [0, 0; theta(1), theta(1); theta(2), theta(2)], '--m');
    legend(plt, ["angle1 mean", "angle 1 standard deviation", "angle2 mean", "angle 2 standard deviation"])
    title("angle estimation accuracy at different SNRs")

    