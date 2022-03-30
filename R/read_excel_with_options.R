

#' Read Excel with options
#'
#' Reads an Excel file.
#' Checks first whether the file exists and suggests
#' alternatives if not.
#'
#' @param filename A string of path to Excel file
#' @param recursive Boolean. Whether to search for alternatives recursively or not
#'
#' @return
#' @export
#'
#' @examples
#'
read_excel_with_options <- function(filename, recursive=TRUE){

  filename <- check_file(filename,
                         recursive=recursive)

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
#' @param recursive Boolean. Whether to search for alternatives recursively or not
#'
#' @return
#' @export
#'
#' @examples
#'
read_csv_with_options <- function(filename, recursive=TRUE){

  filename <- check_file(filename,
                         recursive=recursive)

  readfile <- utils::read.csv(filename,
                              header = TRUE,
                              stringsAsFactors = FALSE,
                              check.names=FALSE)

  return(readfile)
}



#' Create loader with options
#'
#' Function factory which generates a function for reading in
#' a particular type of file.
#'
#' The method for loading this file type is supplied as
#' customloader, along with any additional necessary parameters.
#'
#' Useful if your file type is not Excel or csv but you still want
#' a generic function which loads the file but provides alternatives.
#'
#' @param customloader Function for reading a given filetype, e.g. readRDS
#' @param recursive Boolean. Whether to search for alternatives recursively or not
#' @param ... Additional parameters to supply to customloader
#'
#' @return Function which reads that given filetype but first checks the file
#' exists and provides alternatives
#'
#' @export
#'
#' @examples
#' read_rds_with_options <- create_loader_with_options(readRDS)
#'
#' # myrds <- read_rds_with_options("/path/to/rds/myrds.rds")
#'
create_loader_with_options <- function(customloader, recursive=TRUE, ...){

  function(filename){

    filename <- check_file(filename,
                           recursive=recursive)

    readfile <- customloader(filename, ...)

    return(readfile)

  }
}

