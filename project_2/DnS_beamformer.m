function Bkl = DnS_beamformer(akl)
    Bkl = zeros(4, size(akl, 1), size(akl, 2));
    for k = 1:size(Xkl, 1)
        for l = 1:size(Xkl, 2)
            Bkl(:,k,l) = akl(:,k,l) / (akl(:,k,l)' * akl(:,k,l));
        end
    end
end

