#' Scraping data from the U.S. Census Bureau's American Community Survey
#'
#' Scrape personal or household data for any state and any year(s) in the American Community Survey (ACS)
#' \url{https://www.census.gov/programs-surveys/acs/}
#'
#' The Census Bureau stores the data at \url{https://www2.census.gov/programs-surveys/acs/data/pums/}
#'
#' ACS PUMS documentation can be found at \url{https://www.census.gov/programs-surveys/acs/technical-documentation/pums/documentation.html}
#'
#' @author Lawrence R De Geest, \email{lrdegeest@@gmail.com}
#' @param start starting year (e.g. 2011)
#' @param end ending year (e.g. 2011)
#' @param state state abbreviation (e.g. "IA" for Iowa)
#' @param type personal ("p") or household ("h") data
#' @param save save csv files of each year's data to your directory. Defaults to FALSE.
#' @return list of data frames, one for each year
#' @note This package uses the function download.file() from base R's utils package
#' @keywords "American Community Survey"
#' @export
#' @examples
#' # Get personal data from Iowa for years 2001 to 2016:
#' p.data <- getStateACS(2001, 2016, state = "IA", type = "personal")


getStateACS <- function(start, end, state, type, save = FALSE) {
  if (class(start) != "numeric" | nchar(start) != 4) stop("'end' must be numeric (e.g. 2011)")
  if (class(end) != "numeric" | nchar(end) != 4) stop("end' must be numeric (e.g. 2011)")
  if (class(state) != "character" | nchar(state) > 2) stop("'state' must be a character object and cannot exceed two character state abbreviation (e.g. 'IA' for Iowa)")
  if (!(type %in% c("p","h"))) stop("for household data enter 'h'; for personal data enter 'p'")
  base_url <- "https://www2.census.gov/programs-surveys/acs/data/pums/"
  zip_download <- paste0("/csv_",type,tolower(state),".zip")
  datalist <- list()
  for(i in start:end) {
    file_name <- ifelse(i < 2007, paste0(base_url, as.character(i), zip_download), paste(base_url, as.character(i), "/1-Year", zip_download, sep=""))
    temp <- tempfile()
    cat(paste0("\nDownloading ", i, "\n"))
    tryCatch(download.file(file_name, temp, mode="wb"))
    csv_file <- paste("ss",substr(as.character(i), nchar(as.character(i))-1, nchar(as.character(i))),paste0(type,tolower(state),".csv"), sep = "" )
    cat(csv_file,"\n")
    df <- read.csv(unz(temp,csv_file))
    name <- paste0(type,"acs", i)
    datalist[[name]] <- df
    unlink(temp)
    if(i == end) cat("\nDownload complete.\n")
  }
  if(save == TRUE) {
    cat("\nSaving data.\n")
    lapply(names(datalist), function(x) write.csv(names(x), file = paste0(x, ".csv")))
  }
  return(datalist)
}
