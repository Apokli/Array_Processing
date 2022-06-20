function ss = ISTFT1(S, X, FS1)
    d = 0.03 * FS1;
    c = d / 30;
    W = taylorwin(d);
    L = length(S);
    increment = fix(((L - d) / c) + 1);
    ss = zeros(2 * L, 1);
    for i = 1:increment
        A = d * (i - 1) / 30;
        B = A + d;
        Ss(A+1 : B, 1) = ifft(X(:, i, 1) .* W);
        ss(A+1:B, 1) = ss(A+1:B, 1) + Ss(A+1:B, 1);
    end
end