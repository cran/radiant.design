#' Sample size calculation
#'
#' @details See \url{https://radiant-rstats.github.io/docs/design/sample_size.html} for an example in Radiant
#'
#' @param type Choose "mean" or "proportion"
#' @param err_mean Acceptable Error for Mean
#' @param sd_mean Standard deviation for Mean
#' @param err_prop Acceptable Error for Proportion
#' @param p_prop Initial proportion estimate for Proportion
#' @param conf_lev Confidence level
#' @param incidence Incidence rate (i.e., fraction of valid respondents)
#' @param response Response rate
#' @param pop_correction Apply correction for population size ("yes","no")
#' @param pop_size Population size
#'
#' @return A list of variables defined in sample_size as an object of class sample_size
#'
#' @examples
#' sample_size(type = "mean", err_mean = 2, sd_mean = 10)
#'
#' @seealso \code{\link{summary.sample_size}} to summarize results
#' @export
sample_size <- function(type, err_mean = 2, sd_mean = 10, err_prop = .1,
                        p_prop = .5, conf_lev = 0.95, incidence = 1,
                        response = 1, pop_correction = "no", pop_size = 1000000) {
  if (pop_correction == "yes" && is_not(pop_size)) pop_size <- 1000000
  if (is_not(conf_lev) || conf_lev < 0 || conf_lev > 1) conf_lev <- 0.95
  zval <- -qnorm((1 - conf_lev) / 2)

  if (type == "mean") {
    if (is_not(err_mean)) {
      return("Please select an acceptable error greater than 0" %>%
        add_class("sample_size"))
    }
    n <- (zval^2 * sd_mean^2) / err_mean^2
    rm(err_prop, p_prop)
  } else {
    if (is_not(err_prop)) {
      return("Please select an acceptable error greater than 0" %>%
        add_class("sample_size"))
    }
    n <- (zval^2 * p_prop * (1 - p_prop)) / err_prop^2
    rm(err_mean, sd_mean)
  }

  if (pop_correction == "yes") {
    n <- n * pop_size / ((n - 1) + pop_size)
  } else {
    rm(pop_size)
  }

  n <- ceiling(n)

  as.list(environment()) %>% add_class("sample_size")
}

#' Summary method for the sample_size function
#'
#' @details See \url{https://radiant-rstats.github.io/docs/design/sample_size.html} for an example in Radiant
#'
#' @param object Return value from \code{\link{sample_size}}
#' @param ... further arguments passed to or from other methods
#'
#' @examples
#' sample_size(type = "mean", err_mean = 2, sd_mean = 10) %>%
#'   summary()
#'
#' @seealso \code{\link{sample_size}} to generate the results
#'
#' @export
summary.sample_size <- function(object, ...) {
  if (is.character(object)) {
    return(object)
  }

  cat("Sample size calculation\n")

  if (object$type == "mean") {
    cat("Calculation type     : Mean\n")
    cat("Acceptable Error     :", object$err_mean, "\n")
    cat("Standard deviation   :", object$sd_mean, "\n")
  } else {
    cat("Calculation type     : Proportion\n")
    cat("Acceptable Error     :", object$err_prop, "\n")
    cat("Proportion           :", object$p_prop, "\n")
  }

  cat("Confidence level     :", object$conf_lev, "\n")
  cat("Incidence rate       :", object$incidence, "\n")
  cat("Response rate        :", object$response, "\n")

  if (object$pop_correction == "no") {
    cat("Population correction: None\n")
  } else {
    cat("Population correction: Yes\n")
    cat("Population size      :", format_nr(object$pop_size, dec = 0), "\n")
  }

  cat("\nRequired sample size     :", format_nr(object$n, dec = 0))
  cat("\nRequired contact attempts:", format_nr(ceiling(object$n / object$incidence / object$response), dec = 0))

  rm(object)
}
