#' Central England temperature (CET) data from 1961 until 2020
#'
#' Central England temperature (CET) data from 1961 until 2020
#' employed in \insertCite{HauptFritsch2021quantWarming;textual}{quantWarming}.
#' The dataset contains mean monthly temperatures in columns 1 to 12
#' and annual mean temperatures in column 13. The rownames represent
#' the years.
#'
#' @name dat1961
#'
#' @docType data
#'
#' @usage data(dat1961)
#'
#' @format A dataset with 60 rows and 13 variables containing:
#' \describe{
#' \item{Jan}{Monthly mean temperature January}
#' \item{Feb}{Monthly mean temperature February}
#' \item{Mar}{Monthly mean temperature March}
#' \item{Apr}{Monthly mean temperature April}
#' \item{May}{Monthly mean temperature May}
#' \item{Jun}{Monthly mean temperature June}
#' \item{Jul}{Monthly mean temperature July}
#' \item{Aug}{Monthly mean temperature August}
#' \item{Sep}{Monthly mean temperature September}
#' \item{Oct}{Monthly mean temperature October}
#' \item{Nov}{Monthly mean temperature November}
#' \item{Dec}{Monthly mean temperature December}
#' \item{Annual}{Annual mean temperature}
#' }
#'
#' @keywords datasets
#'
#' @references
#' \insertAllCited{}
#'
#' @source \href{https://www.metoffice.gov.uk/hadobs/hadcet/cetml1659on.dat}
#'
#' @examples
#' \dontrun{
#'   data(dat1961, package = "quantWarming")
#'   annMean <- dat1961[,13]
#'   year <- as.numeric(rownames(dat1961))
#'   \donttest{plot(y = year, x = annMean)}
#' }
#'
NULL
