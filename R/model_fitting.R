#' Turn list of 2 x 2 contingency tables into data frame.
#'
#' This convenience function turns a list of 2 x 2 matrices into a data frame.
#' There should be two columns each containing a group. The first row should
#' contain the number of successes, and the second row the number of tries.
#'
#' @param ctables a list of matrices or data frames.
#' @return A data frame where each row corresponds to a contingency table.
tables_to_df <- function(ctables) {
  dfs <- lapply(ctables,
                function(ctable) {
                    data.frame(yA = ctable[1, 1],
                               nA = ctable[2, 1],
                               yB = ctable[1, 2],
                               nB = ctable[2, 2])
                })
  Reduce(rbind, dfs)
}

#' Fit the multilevel model
#'
#' @param tables_df A data frame with columsn yA (successes group A),
#'    nA (tries group A), yB (successes group B), and nB (tries group B).
#' @param chains Number of chains to run.
#' @param iter Number of iterations per chain.
#' @param warmup Number of iterations per chain to discard as warmup.
#' @return A stanfit object.
fit_model <- function(tables_df, chains = 4, iter = 2000, warmup = 1000) {
    rstan::sampling(stanmodels$hierarchical_binomial,
                    data = list(N = nrow(tables_df),
                                yA = tables_df$yA,
                                nA = tables_df$nA,
                                yB = tables_df$yB,
                                nB = tables_df$nB),
                    chains = chains, iter = iter, warmup = warmup,
                    control = list(adapt_delta = 0.95))
}

#' Simulate fake data with a fixed difference between groups
#'
#' The function can either simulate the groups from one beta distribution
#' and setting afixed difference (delta) between them, or by drawing from
#' two different Beta distributions. Set delta to NULL and give parameter
#' values for (alphaB, betaB) to activate the second behaviour.
#'
#' @param alphaA true parameter of prior Beta-distribution for group A
#' @param betaA true parameter of prior Beta-distribution for group A
#' @param delta true difference in probability between groups
#' @param alphaB true parameter of prior Beta-distribution for group B
#' @param betaB true parameter of prior Beta-distribution for group B
#' @param N number of contingency tables
#' @param nA number of tries group A
#' @param nB number of tries group B
#' @return Data frame of fake data and true probabilities
sim_tables <- function(alphaA = 0.5, betaA = 5, delta = 0.1,
                       alphaB = NULL, betaB = NULL,
                       N = 10, nA = 10000, nB = 100) {

  if (is.null(delta)) {
    pA <- rbeta(N, alphaA, betaA)
    pB <- rbeta(N, alphaB, betaB)
  } else {
    pA <- rbeta(N, alphaA, betaA)
    pB <- pA + delta
  }

  data.frame(yA = rbinom(N, nA, pA),
             yB = rbinom(N, nB, pB),
             nA, nB,
             pA_true = pA, pB_true = pB)
}
