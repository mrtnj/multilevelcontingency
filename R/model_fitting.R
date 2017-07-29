#' Turn list of 2 x 2 contingency tables into data frame.
#'
#' This convenience function turns a list of 2 x 2 matrices into a data frame.
#' There should be two columns each containing a group. The first row should
#' contain the number of successes, and the second row the number of tries.
#' 
#' @param ctables a list of matrices or data frames
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
#' @return A stanfit object.
fit_model <- function(tables_df) {
    rstan::sampling(stanmodels$hierarchical_binomial,
                    data = list(N = nrow(tables_df),
                                yA = tables_df$yA,
                                nA = tables_df$nA,
                                yB = tables_df$yB,
                                nB = tables_df$nB),
                    control = list(adapt_delta = 0.9))
}

#' Simulate fake data
#' 
#' @param alpha true parameter of prior Beta-distribution
#' @param beta true parameter of prior Beta-distribution
#' @param delta true difference in probability between groups
#' @param N number of contingency tables
#' @param nA number of tries group A
#' @param nB number of tries group B
#' @return Data frame of fake data and true probabilities
sim_tables <- function(alpha = 0.5, beta = 5, delta = 0.1,
                       N = 10, nA = 10000, nB = 100) {

  pA <- rbeta(N, alpha, beta)
  pB <- pA + delta

  data.frame(yA = rbinom(N, nA, pA),
             yB = rbinom(N, nB, pB),
             nA, nB,
             pA_true = pA, pB_true = pB)
}
