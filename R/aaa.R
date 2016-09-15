# to avoid 'no visible binding for global variable' NOTE
globalVariables(c(".","rnd_number"))

#' radiant.design
#'
#' @name radiant.design
#' @docType package
#' @import radiant.data shiny mvtnorm
#' @importFrom dplyr %>% arrange arrange_ desc slice
#' @importFrom methods is
#' @importFrom stats as.formula cor na.omit power.prop.test power.t.test qnorm runif
#' @importFrom import from
NULL

#' 100 random names
#' @details A list of 100 random names generated by \url{listofrandomnames.com}.  Description provided in attr(rndnames,"description")
#' @docType data
#' @keywords datasets
#' @name rndnames
#' @usage data(rndnames)
#' @format A data frame with 100 rows and 2 variables
NULL