

#' Read Excel with options
#'
#' Reads an Excel file.
#' Checks first whether the file exists and suggests
#' alternatives if not.
#'
#' @param filename A string of path to Excel file
#'
#' @return
#' @export
#'
#' @examples
#'
read_excel_with_options <- function(filename){

  filename <- check_file(filename)
  readfile <- readxl::read_excel(filename)

  return(readfile)
}

#' Read csv with options
#'
#'Reads a csv file.
#'Checks first whether the file exists and suggests
#'alternatives if not.
#'
#' @param filename A string of path to csv file
#'
#' @return
#' @export
#'
#' @examples
#'
read_csv_with_options <- function(filename){

  filename <- check_file(filename)
  readfile <- utils::read.csv(filename, header = TRUE, stringsAsFactors = FALSE, check.names=FALSE)

  return(readfile)
}


