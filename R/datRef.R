#' Central England temperature (CET) data from 1850 until 1900
#'
#' Central England temperature (CET) data from 1850 until 1900
#' employed in \insertCite{HauptFritsch2021quantWarming;textual}{quantWarming}.
#' The dataset contains mean monthly temperatures in columns 1 to 12
#' and annual mean temperatures in column 13. The rownames represent
#' the years.
#'
#' @name datRef
#'
#' @docType data
#'
#' @usage data(datRef)
#'
#' @format A dataset with 51 rows and 13 variables containing:
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
#'   data(datRef, package = "quantWarming")
#'   annMean <- datRef[,13]
#'   tmp <- cbind("Year" = as.numeric(rownames(datRef)), "annMean" = annMean)
#'   \donttest{plot(y = tmp$Year, x = tmp$annMean)}
#' }
#'
NULL
