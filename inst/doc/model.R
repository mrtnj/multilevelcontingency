## ------------------------------------------------------------------------
hist(rbeta(1e6, 1, 1), main = "Beta(1, 1)")
hist(rbeta(1e6, 0.1, 1), xlim = c(0, 1), main = "Beta(0.1, 1)")
hist(rbeta(1e6, 1, 0.1), xlim = c(0, 1), main = "Beta(1, 0.1)")

## ---- results = "hide"---------------------------------------------------
model <- rstan::sampling(stanmodels$single_binomial,
                         data = list(yA = 340, nA = 10000, yB = 11, nB = 100))

## ------------------------------------------------------------------------
model
rstan::plot(model)

## ------------------------------------------------------------------------
posteriors <- rstan::extract(model)
hist(posteriors$pA, xlim = c(0, 0.5), main = "Posterior pA")
hist(posteriors$pB, xlim = c(0, 0.5), main = "Posterior pB")
hist(posteriors$delta, xlim = c(-0.5, 0.5), main = "Posterior delta")

