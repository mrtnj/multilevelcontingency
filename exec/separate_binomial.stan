data {
    // number of contingency tables
    int N;
    // successes
    int yA[N];
    int yB[N];
    // number of tries
    int nA[N];
    int nB[N];
}
parameters {
    vector<lower = 0, upper = 1>[N] pA;
    vector<lower = 0, upper = 1>[N] pB;
}
model {
    for (i in 1:N) {
        yA[i] ~ binomial(nA[i], pA[i]);
        yB[i] ~ binomial(nB[i], pB[i]);
    }
    pA ~ beta(1, 1);
    pB ~ beta(1, 1);
}
generated quantities {
    vector[N] delta;
    real average_pB;
    real average_pA;
    real average_delta;

    // estimate average delta
    delta = pB - pA;
    average_delta = mean(delta);
    average_pB = mean(pB);
    average_pA = mean(pA);
}
