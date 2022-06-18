function atf = Rx2atf(Rxkl)
    [evc, eva] = eig(Rxkl);
    [eva_sorted, index] = sort(diag(eva),'descend');
    evc_sorted = evc(:, index);
    atf = evc_sorted(:, 1);
end

