#' Check File
#'
#' Check whether a file exists and if not suggest alternatives.
#' If the file exists the original filename is returned. If not
#' the user is prompted with alternative files based on the
#' keywords in the original filename, and they can select one
#' of these. The selected file is returned, or else an error
#' is thrown.
#'
#' @param filename A character vector of legth one
#' @param recursive Boolean. Whether to search for alternatives recursively or not
#' @param useRstudio Boolean for whether to use interactive R studio to find files
#'
#' @return A character vector
#' @export
#'
#' @examples
#'
#'# check_file("data/my_apples.csv")
check_file <- function(filename, recursive=TRUE, useRstudio=TRUE){

  ##### First check file is there and if not suggest alternatives
  if(file.exists(filename) == FALSE){

    if (useRstudio){

      rstudioapi::showDialog(title="Could not find file",
                             message=glue::glue("Could not find file {filename}. Redirecting to menu to select an alternative."))

      alternative <- suggest_alternative_files(keywords=NULL,
                                               dirname(filename),
                                               file_filter=paste0("(*.", tools::file_ext(filename), ")"),
                                               recursive=recursive,
                                               useRstudio=useRstudio)

    } else {

      message(glue::glue("Could not find file {filename}. Searching for possible alternatives."))

      # Get keyword possibilities based off filename
      keywords <- get_keywords(filename)

      # Suggest alternatives based off keywords
      alternative <- suggest_alternative_files(keywords,
                                               dirname(filename),
                                               recursive=recursive,
                                               useRstudio=useRstudio)

    }


    if(is.null(alternative)){

      if (useRstudio){
        rstudioapi::showDialog(title="Invalid file selection",
                               message=glue::glue("Could not find file {filename} or suitable alternatives. Terminating script."))

      } else {
        stop(glue::glue("Could not find file {filename} or suitable alternatives. Terminating script."))
      }

    } else {

      return(alternative)

    }
  } else {
    return(filename)
  }

}

#' Get keywords
#'
#' @param filename String to get keywords from
#'
#' @return Character vector of keywords obtained from filename
#' @export
#'
#' @examples
#' get_keywords("my_data apple friend-20220328.csv")
#'
get_keywords <- function(filename){

  keywords_to_ignore <- c(NA, "", "xlsx", "csv", "rds", "png", "jpg", "jpeg")

  keywords <- unlist(strsplit(gsub('[[:digit:]]+', '', basename(filename)), split = '[-_,. ]'))
  keywords <- keywords[!keywords %in% keywords_to_ignore]

  return(keywords)

}
