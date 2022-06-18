function x = gendata_conv(s, P, N, sigma)

t_x = 0: 1/P: N-1/P;
X = zeros(length(t_x), 1);

for  i = 1:length(t_x)

      if mod(t_x(i),1) >= 0 && mod(t_x(i),1) < 0.25
          H = 1;
      elseif  mod(t_x(i), 1) >= 0.25 && mod(t_x(i), 1) < 0.5
          H = -1;
      elseif  mod(t_x(i), 1) >= 0.5 && mod(t_x(i), 1) < 0.75
          H = 1;
      elseif  mod(t_x(i), 1) >= 0.75 && mod(t_x(i), 1) < 1
          H = -1;
      end
      X(i) = H * s(floor(t_x(i)) + 1);
end

noise = zeros(length(t_x), 1);

for i=1:length(t_x)
    noise(i) = normrnd(0, sigma/2) + 1i * normrnd(0, sigma/2);
end
x = X + noise;
end