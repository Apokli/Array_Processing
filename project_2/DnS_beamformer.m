function Bkl = DnS_beamformer(akl)
    Bkl = zeros(4, size(akl, 2), size(akl, 3));
    for k = 1:size(akl, 2)
        for l = 1:size(akl, 3)
            Bkl(:,k,l) = akl(:,k,l) / (akl(:,k,l)' * akl(:,k,l));
        end
    end
end

