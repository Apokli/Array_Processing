%% Read all data, create sound data matrix
clear;
load('impulse_responses.mat');
[y1, Fs1] = audioread('clean_speech.wav');
[y2, Fs2] = audioread('clean_speech_2.wav');
[y3, Fs3] = audioread('babble_noise.wav');
[y4, Fs4] = audioread('aritificial_nonstat_noise.wav');
[y5, Fs5] = audioread('Speech_shaped_noise.wav');

w1=[conv(y1,h_target(1,:)), conv(y1,h_target(2,:)), conv(y1,h_target(3,:)), conv(y1,h_target(4,:))];
w2=[conv(y2,h_inter1(1,:)), conv(y2,h_inter1(2,:)), conv(y2,h_inter1(3,:)), conv(y2,h_inter1(4,:))];
w3=[conv(y3,h_inter2(1,:)), conv(y3,h_inter2(2,:)), conv(y3,h_inter1(2,:)), conv(y3,h_inter2(4,:))];
w4=[conv(y4,h_inter3(1,:)), conv(y4,h_inter3(2,:)), conv(y4,h_inter3(3,:)), conv(y4,h_inter3(4,:))];
w5=[conv(y5,h_inter4(1,:)), conv(y5,h_inter4(2,:)), conv(y5,h_inter4(3,:)), conv(y5,h_inter4(4,:))];

N = size(w1, 1);
S = w1;
N1 = [w2; zeros(N - size(w2, 1), 4)];
N2 = w3(1:N, :);
N3 = w4(1:N, :);
N4 = w5(1:N, :);
Xt = S + N1 + N2 + N3 + N4;
Nt = N1 + N2 + N3 + N4; 
fprintf("======Done data read======\n");

%% Implement the STFT
Xkl = STFT1(Xt, Fs1);
Nkl = STFT1(Nt, Fs1);
Skl = STFT1(S, Fs1);
fprintf("======Done STFTs======\n");

%% get Rn ^ (-1/2) and prewhitened Rx
Rn_invsqrt = zeros(4, 4, size(Nkl, 1), size(Nkl, 2));
Rnkl = zeros(4, 4);
kernel_len = 4;
for k = 1:size(Nkl, 1)
    for l = 1:size(Nkl, 2)
        down = max(1, l - kernel_len / 2);
        up = min(size(Nkl, 2), l + kernel_len / 2);
        for i = down : up
            tmp_vec = Nkl(k, i, :);
            Rnkl = Rnkl + tmp_vec(:) * tmp_vec(:)';
        end
        Rnkl = Rnkl / (up - down + 1);
        [evc, eva] = eig(Rnkl);
        Rn_invsqrt(:, :, k, l) = evc / sqrt(eva) * evc'; % calculate Rn ^ (-1/2)
    end
    if mod(k, size(Xkl, 1) / 8) == 0
        fprintf("======Done %d / 8 calculations of the Rn_invsqrt======\n", k / (size(Nkl, 1) / 8));
    end
end

Rx_wh = zeros(4, 4, size(Xkl, 1), size(Xkl, 2));
Rxkl = zeros(4, 4);
kernel_len = 4;
for k = 1:size(Xkl, 1)
    for l = 1:size(Xkl, 2)
        down = max(1, l - kernel_len / 2);
        up = min(size(Xkl, 2), l + kernel_len / 2);
        for i = down : up
            tmp_vec = Xkl(k, i, :);
            tmp_vec = Rn_invsqrt(:, :, k, i) * tmp_vec(:);
            Rxkl = Rxkl + tmp_vec * tmp_vec';
        end
        Rx_wh(:, :, k, l) = Rxkl / (up - down + 1);
    end
    if mod(k, size(Xkl, 1) / 8) == 0
        fprintf("======Done %d / 8 calculations of the prewhitened Rx======\n", k / (size(Xkl, 1) / 8));
    end
end

%% Calculate the ATF
akl = zeros(4, size(Xkl, 1), size(Xkl, 2));
for k = 1:size(Xkl, 1)
    for l = 1:size(Xkl, 2)
        [evc, eva] = eig(Rx_wh(:, :, k, l));
        [eva_sorted, index] = sort(diag(eva),'descend');
        evc_sorted = evc(:, index);
        akl = Rn_invsqrt(:, :, k, l) \ evc_sorted(:, 1); % De-whiten

    end
end
fprintf("======Done calculating ATF======\n");

%% Calculate the beamfromers
Bkl_DnS = DnS_beamformer(akl);
Bkl_MVDR = MVDR_beamformer(akl, Rn_invsqrt);

%% Apply to Signals
SSkl = zeros(size(Xkl, 1), size(Xkl, 2));
skl = zeros(4, 1);
for k = 1:size(Xkl, 1)
    for l = 1:size(Xkl, 2)
        for o=1:4
        skl(o,1)=Xkl(k,l,o);
        end
        SSkl(k,l)=Bkl_DnS(:,k,l)'*skl;
    end
end

fprintf("======Done calculating SS======\n");
y = ISTFT1(S,SSkl,Fs1);
fprintf("======Done calculating y======\n");
d = stoi(S(:,4), y, Fs1);
