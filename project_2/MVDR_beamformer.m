function Bkl = MVDR_beamformer(akl, Rn_invsqrt)
    Bkl = zeros(4, size(akl, 1), size(akl, 2));
    for k = 1:size(akl, 1)
        for l = 1:size(akl, 2)
            Rnkl_inv = Rn_invsqrt(:, :, k, l) * Rn_invsqrt(:, :, k, l);
            Bkl(:, k, l) = (Rnkl_inv * akl(:, k, l)) / (akl(:, k, l)' * Rnkl_inv * akl(:, k, l));
        end
    end
end

