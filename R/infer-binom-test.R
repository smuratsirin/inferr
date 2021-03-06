#' @title Binomial Test
#' @description Test whether the proportion of successes on a two-level
#' categorical dependent variable significantly differs from a hypothesized value.
#' @param n number of observations
#' @param success number of successes
#' @param prob assumed probability of success on a trial
#' @param data a \code{data.frame} or a \code{tibble}
#' @param variable factor; column in \code{data}
#' @param ... additional arguments passed to or from other methods
#' @return \code{binom_test} returns an object of class \code{"binom_test"}.
#' An object of class \code{"binom_test"} is a list containing the
#' following components:
#'
#' \item{n}{number of observations}
#' \item{k}{number of successes}
#' \item{exp_k}{expected number of successes}
#' \item{obs_p}{assumed probability of success}
#' \item{exp_p}{expected probability of success}
#' \item{lower}{lower one sided p value}
#' \item{upper}{upper one sided p value}
#' @section Deprecated Functions:
#' \code{binom_calc()} and \code{binom_test()} have been deprecated. Instead use
#' \code{infer_binom_cal()} and \code{infer_binom_test()}.
#' @references Hoel, P. G. 1984. Introduction to Mathematical Statistics.
#' 5th ed. New York: Wiley.
#'
#' @seealso \code{\link[stats]{binom.test}}
#' @examples
#' # using calculator
#' infer_binom_calc(32, 13, prob = 0.5)
#'
#' # using data set
#' infer_binom_test(hsb, female, prob = 0.5)
#' @export
#'
infer_binom_calc <- function(n, success, prob = 0.5, ...) UseMethod("infer_binom_calc")

#' @export
infer_binom_calc.default <- function(n, success, prob = 0.5, ...) {
  if (!is.numeric(n)) {
    stop("n must be an integer")
  }

  if (!is.numeric(success)) {
    stop("success must be an integer")
  }

  if (!is.numeric(prob)) {
    stop("prob must be numeric")
  }

  if ((prob < 0) | (prob > 1)) {
    stop("prob must be between 0 and 1")
  }

  k <- binom_comp(n, success, prob)

  out <- list(
    n = n, k = k$k, exp_k = k$exp_k, obs_p = k$obs_p,
    exp_p = k$exp_p, lower = k$lower, upper = k$upper
  )

  class(out) <- "infer_binom_calc"
  return(out)
}

#' @export
#' @rdname infer_binom_calc
#' @usage NULL
#'
binom_calc <- function(n, success, prob = 0.5, ...) {
  .Deprecated("infer_binom_calc()")
  infer_binom_calc(n, success, prob = 0.5, ...)
}

#' @export
print.infer_binom_calc <- function(x, ...) {
  print_binom(x)
}

#' @export
#' @rdname infer_binom_calc
infer_binom_test <- function(data, variable, prob = 0.5) {
  
  varyable <- rlang::enquo(variable)
  fdata    <- dplyr::pull(data, !! varyable)

  if (!is.factor(fdata)) {
    stop("variable must be of type factor", call. = FALSE)
  }

  if (nlevels(fdata) > 2) {
    stop("Binomial test is applicable only to binary data i.e. categorical data with 2 levels.", call. = FALSE)
  }

  if (!is.numeric(prob)) {
    stop("prob must be numeric", call. = FALSE)
  }

  if ((prob < 0) | (prob > 1)) {
    stop("prob must be between 0 and 1", call. = FALSE)
  }

  n <- length(fdata)
  k <- table(fdata)[[2]]
  infer_binom_calc.default(n, k, prob)
}

#' @export
#' @rdname infer_binom_calc
#' @usage NULL
#'
binom_test <- function(data, prob = 0.5) {
  .Deprecated("infer_binom_test()")
}
