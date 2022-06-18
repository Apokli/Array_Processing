function X = STFT1(S, FS1)
    d = 0.02 * FS1;
    c = d/2;
    W = hamming(d);
    L = length(S);
    increment = fix(((L - d) / c) + 1);
    X = zeros(d, increment, 4);
    
    for i = 1:increment
        A = d * (i - 1) / 2;
        B = A + d;
        X(:,i,1) = fft(S(A+1 : B, 1).* W);
        X(:,i,2) = fft(S(A+1 : B, 2).* W);
        X(:,i,3) = fft(S(A+1 : B, 3).* W);
        X(:,i,4) = fft(S(A+1 : B, 4).* W);
    end
end

