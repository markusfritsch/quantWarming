#' Central England temperature (CET) anomaly data from 1961 until 2020
#'
#' Central England temperature (CET) anomaly data from 1961 until 2020
#' employed in \insertCite{HauptFritsch2021quantWarming;textual}{quantWarming}.
#' The dataset contains mean monthly temperatures in columns 1 to 12.
#' The rownames represent the years. The anomaly data are obtained by
#' subtracting the mean for each month over the years 1850 until 1900
#' from the respective month.
#'
#' @name dat1961Ano
#'
#' @docType data
#'
#' @usage data(dat1961Ano)
#'
#' @format A dataset with 60 rows and 12 variables containing:
#' \describe{
#' \item{Jan}{Monthly mean temperature anomaly January}
#' \item{Feb}{Monthly mean temperature anomaly February}
#' \item{Mar}{Monthly mean temperature anomaly March}
#' \item{Apr}{Monthly mean temperature anomaly April}
#' \item{May}{Monthly mean temperature anomaly May}
#' \item{Jun}{Monthly mean temperature anomaly June}
#' \item{Jul}{Monthly mean temperature anomaly July}
#' \item{Aug}{Monthly mean temperature anomaly August}
#' \item{Sep}{Monthly mean temperature anomaly September}
#' \item{Oct}{Monthly mean temperature anomaly October}
#' \item{Nov}{Monthly mean temperature anomaly November}
#' \item{Dec}{Monthly mean temperature anomaly December}
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
#'   data(dat1961Ano, package = "quantWarming")
#'   meanTemp <- dat1961Ano[,1]
#'   tmp <- cbind("Year" = as.numeric(rownames(dat1961Ano)), "meanTemp" = meanTemp)
#'   \donttest{plot(y = tmp$Year, x = tmp$meanTemp)}
#' }
#'
NULL
