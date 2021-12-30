#' Central England temperature (CET) anomaly data from 1850 until 2020
#'
#' Central England temperature (CET) anomaly data from 1850 until 2020
#' employed in \insertCite{HauptFritsch2021quantWarming;textual}{persistenceqr}.
#' The dataset contains mean monthly temperatures in columns 1 to 12.
#' The rownames represent the years. The anomaly data are obtained by
#' subtracting the mean for each month over the years 1850 until 1900
#' from the respective month.
#'
#' @name dat1850Ano
#'
#' @docType data
#'
#' @usage data(dat1850Ano)
#'
#' @format A dataset with 171 rows and 12 variables containing:
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
#'   data(dat1850Ano, package = "quantWarming")
#'   meanTemp <- dat1850Ano[,1]
#'   tmp <- cbind("Year" = as.numeric(rownames(dat1850Ano)), "meanTemp" = meanTemp)
#'   \donttest{plot(y = tmp$Year, x = tmp$meanTemp)}
#' }
#'
NULL
