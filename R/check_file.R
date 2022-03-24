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
#'
#' @return A character vector
#' @export
#'
#' @examples
#'
#' check_file("data/my_apples.csv")
check_file <- function(filename){

  ##### First check file is there and if not suggest alternatives
  if(file.exists(filename) == FALSE){
    message(glue::glue("Could not find file {filename}. Searching for possible alternatives."))

    # Get keyword possibilities based off filename
    keywords <- unlist(lapply(strsplit(gsub('[[:digit:]]+', '', basename(filename)), split = '[-_,.]'),
                              function(z){ z[!is.na(z) & z != "" & z!="xlsx" & z!="csv"]}))

    # Suggest alternatives based off keywords
    alternative <- suggest_alternative_files(keywords, dirname(filename))

    if(is.null(alternative)){

      stop(glue::glue("Could not find file {filename} or suitable alternatives. Terminating script."))

    } else{

      return(alternative)

    }
  } else {
    return(filename)
  }

}
