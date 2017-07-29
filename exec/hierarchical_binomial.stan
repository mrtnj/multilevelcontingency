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
    real<lower = 0> alpha;
    real<lower = 0> beta;	
}
model {
    for (i in 1:N) {
        yA[i] ~ binomial(nA[i], pA[i]);
        yB[i] ~ binomial(nB[i], pB[i]);
    }
    pA ~ beta(alpha, beta);
    pB ~ beta(alpha, beta);
}
generated quantities {
    vector[N] delta;
    real average_pB;
    real average_pA;
    real average_delta;

    vector[N] yA_rep;
    vector[N] yB_rep;

    // estimate average delta
    delta = pB - pA;
    average_delta = mean(delta);
    average_pB = mean(pB);
    average_pA = mean(pA);

    // posterior predictive check
    for (i in 1:N) {
        yA_rep[i] = binomial_rng(nA[i], pA[i]);
        yB_rep[i] = binomial_rng(nB[i], pB[i]);
    }
}
