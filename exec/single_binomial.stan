data {
    // successes
    int yA;
    int yB;
    // number of tries
    int nA;
    int nB;
}
parameters {
    real <lower = 0, upper = 1> pA;
    real <lower = 0, upper = 1> pB;
}
model {
    yA ~ binomial(nA, pA);
    yB ~ binomial(nB, pB);

    pA ~ beta(1, 1);
    pB ~ beta(1, 1);
}
generated quantities {
    // estimate difference
    real delta;
    delta = pB - pA;
}
