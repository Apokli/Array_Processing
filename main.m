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
    SNR = 20;     
    
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



%  Joint estimation of directions and frequencies
     d=2;
     m=5;
     [j_theta, j_freq] = joint(X, d, m);


%% Comparison
    M = 3;               % the number of antennas
    N = 20;              % the number of sources
    Delta = 0.5;         % antenna spacing per wavelength, commonly 0.5
    theta = [-20, 30].'; % directions of sources in degrees (-90, 90)
    f = [0.1, 0.12].';    % normalized frequency of sources [0, 1)
    SNR = [0, 4, 8, 12, 16, 20];            % signal to noise ratio per source
    X = zeros(M, N, length(SNR));
    
%% ---- angle estimation
    angles = zeros(6, 1000, 2);
    for i = 1:length(SNR)
        for j = 1:1000
            [X(:, :, i), A, S] = gendata(M, N, Delta, theta, f, SNR(i));
            angles(i, j, :) = esprit(X(:, :, i), size(theta, 1));
        end
    end
    angle_means = [mean(angles(:, :, 1), 2), mean(angles(:, :, 2), 2)];
    angle_stds = [std(angles(:, :, 1), 0, 2), std(angles(:, :, 2), 0, 2)];
    figure(2);
    subplot(1,2,1)
    plt = plot(SNR, angle_means, '-*', 'Linewidth', 2);
    hold on
    plot([0, 20], [theta(1), theta(2); theta(1), theta(2)], '--m');
    ylabel("angles")
    xlabel("SNR")
    title("angle estimation at different SNRs")
    legend(plt, ["angle1 mean", "angle2 mean"]);
    subplot(1,2,2);
    plot(SNR, angle_stds, '-*', 'Linewidth', 2);
    ylabel("standard deviations")
    xlabel("SNR")
    title("standard deviations at different SNRs")
    
    
%% ---- frequency estimation
    freqs = zeros(6, 1000, 2);
    for i = 1:length(SNR)
        for j = 1:1000
            [X(:, :, i), A, S] = gendata(M, N, Delta, theta, f, SNR(i));
            freqs(i, j, :) = espritfreq(X(:, :, i), size(f, 1));
        end
    end
    freq_means = [mean(freqs(:, :, 1), 2), mean(freqs(:, :, 2), 2)];
    freq_stds = [std(freqs(:, :, 1), 0, 2), std(freqs(:, :, 2), 0, 2)];
    figure(3);
    subplot(1,2,1)
    plt = plot(SNR, freq_means, '-*', 'Linewidth', 2);
    hold on
    plot([0, 20], [f(1), f(2); f(1), f(2)], '--m');
    ylabel("frequencies")
    xlabel("SNR")
    title("frequency estimation at different SNRs")
    legend(plt, ["freq1 mean", "freq2 mean"]);
    subplot(1,2,2);
    plot(SNR, freq_stds, '-*', 'Linewidth', 2);
    ylabel("standard deviations")
    xlabel("SNR")
    title("standard deviations at different SNRs")
    
%% ---- joint estimation
    freqs = zeros(6, 1000, 2);
     d=2;
     m=5;
    for i = 1:length(SNR)
        for j = 1:1000
            [X(:, :, i), A, S] = gendata(M, N, Delta, theta, f, SNR(i));
            [j_theta, j_freq] = joint(X(:, :, i), d, m);
            angles(i, j, :) = j_theta;                
            freqs(i, j, :) =  j_freq;
        end
    end

    freq_means = [mean(freqs(:, :, 1), 2), mean(freqs(:, :, 2), 2)];
    freq_stds = [std(freqs(:, :, 1), 0, 2), std(freqs(:, :, 2), 0, 2)];
    figure(4);
    subplot(1,2,1)
    plt = plot(SNR, freq_means, '-*', 'Linewidth', 2);
    hold on
    plot([0, 20], [f(1), f(2); f(1), f(2)], '--m');
    ylabel("frequencies")
    xlabel("SNR")
    title("joint frequency estimation at different SNRs")
    legend(plt, ["freq1 mean", "freq2 mean"]);
    subplot(1,2,2);
    plot(SNR, freq_stds, '-*', 'Linewidth', 2);
    ylabel("standard deviations")
    xlabel("SNR")
    title("standard deviations at different SNRs")

    angle_means = [mean(angles(:, :, 1), 2), mean(angles(:, :, 2), 2)];
    angle_stds = [std(angles(:, :, 1), 0, 2), std(angles(:, :, 2), 0, 2)];
    figure(5);
    subplot(1,2,1)
    plt = plot(SNR, angle_means, '-*', 'Linewidth', 2);
    hold on
    plot([0, 20], [theta(1), theta(2); theta(1), theta(2)], '--m');
    ylabel("angles")
    xlabel("SNR")
    title("angle estimation at different SNRs")
    legend(plt, ["angle1 mean", "angle2 mean"]);
    subplot(1,2,2);
    plot(SNR, angle_stds, '-*', 'Linewidth', 2);
    ylabel("standard deviations")
    xlabel("SNR")
    title("standard deviations at different SNRs")

    
% -- zero-forcing beamformer
% ---- angle
    [X, A, S] = gendata(M, N, Delta, theta, f);
    a = esprit(X, size(theta, 1));
    d = 0: Delta: (M-1) * Delta; 
    Ab = exp(1i * 2 * pi * d.' * sin(a.' * pi / 180).');
    Wha = pinv(Ab);
    angle_beamform_diff = S - Wha * X;
    angle_beamform_diff(abs(angle_beamform_diff)<1e-10) = 0;
    
%% ---- frequency
    f = espritfreq(X, size(f, 1));
    K = 0: N - 1;
    Sb = exp(1i * 2 * pi * f.' * K);
    Whf = pinv(X * pinv(Sb));
    freq_beamform_diff = S - Whf * X;
    freq_beamform_diff(abs(angle_beamform_diff)<1e-10) = 0;
%% ---- beamfromer plot
    M = 5;               % the number of antennas
    N = 20;              % the number of sources
    d = 2;
    Delta = 0.5;         % antenna spacing per wavelength, commonly 0.5
    f = [0.1, 0.3].';    % normalized frequency of sources [0, 1)
    SNR = 10;           % signal to noise ratio per source
    theta = linspace(-90, 90, 181);
%     theta = [-90,-80,-70,-60,-50,-40, -30.-20,-10,0,10,20,30,40,50,60,70,80,90].'; % directions of sources in degrees (-90, 90)
    A = zeros(M, d, length(theta));

    y1=zeros(length(theta),1);
    y2=zeros(length(theta),1);
   for i=1:size(theta) - 1
    [X, A(:,:,i), S] = gendata(M, N, Delta, theta(i:i+1,:), f);
    y1(i)=abs(det(Wha*A(:,:,i)));
    y2(i)=abs(det(Whf*A(:,:,i)));
   end
   figure(6);
   plot(theta,y1);
   figure(7);
   plot(theta,y2);
% %% CHANNEL EQUALIZATION
% clear 
% N = 500;
% P = 4;
% sigma = 0;
% 
% sr = randi([0,3], N, 1);
% s = exp(1i*(pi/4 + pi*sr/2));
% x = gendata_conv(s,P,N,sigma);
% 
% X_noise = zeros(2*P,N-1);
% for i=1:N-1
%     A = 1 + i * P - P;
%     B = i * P + P;
%     X_noise(:, i) = x(A: B, 1);
% end
% % rank=rank(X_noise);






