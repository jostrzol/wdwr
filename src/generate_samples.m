N = 5000;
mu = [9; 8; 7; 6];
sigma = [
    16, -2, -1, -3;
    -2,  9, -4, -1;
    -1, -4,  4,  1;
    -3, -1,  1,  1;
];
l = zeros(4, 1) + 5 - mu;
u = zeros(4, 1) + 12 - mu;
samples = mvrandn(l, u, sigma, N);
samples = samples + mu;

means = mean(samples, 2)

writematrix(samples.', "./out/z2-samples.csv");