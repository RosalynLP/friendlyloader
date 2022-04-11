#' Match base filename
#'
#' @param filename A string containing the full filepath you are looking for
#' @param files_to_match A character vector of files to match to filename. If NULL (default),
#' this is the list of files in the same directory as `filename`
#' @param recursive Boolean, default FALSE. Whether to search recursively for `files_to_match`
#' when `files_to_match` is not specified.
#' @return A character vector of length one specifying the file in `files_to_match` which matches
#' filename.
#' @export
#'
#' @examples
#' match_base_filename("20220302_Some_File.csv",
#' c("20220304_somefile.csv", "20220302_Some_Other_File.csv"))
#` #> [1] "20220304_somefile.csv"
#'
match_base_filename <- function(filename, files_to_match = NULL, recursive = FALSE){

  # If no files to match provided, get all files in same directory as filename
  if (is.null(files_to_match)){

    files_to_match <- list.files(path = dirname(filename),
                                 all.files = FALSE,
                                 full.names = TRUE,
                                 recursive = recursive,
                                 ignore.case = TRUE,
                                 include.dirs = TRUE,
                                 no.. = FALSE)
  }

  # Strip date and _/- out of filenames to match base string
  stripped_files <- sapply(X=files_to_match, FUN=filename_without_date)
  match_vec <- stripped_files == filename_without_date(filename)

  # Get names that match given filename
  matchvec <- stripped_files == filename_without_date(filename)
  matchnames <- names(matchvec[matchvec==TRUE])

  if(length(matchnames) == 0){

    stop(glue::glue("No matches found for {basename(filename)} in directory {dirname(filename)}. Terminating script. "))

  } else if (length(matchnames) != 1) {

    warning(glue::glue("{length(matchnames)} matches found for {basename(filename)} in directory {dirname(filename)}:",
                    "\n {matchnames}. Choosing first option: {matchnames[1]}."))

    matchnames <- matchnames[1]

  }

  # Return matched filename if it exists
  return(matchnames)


}




#' Filename without date
#'
#' @param filename A string of the file name
#'
#' @return Filename with numbers, -, _ and common file extensions stripped out, and in lowercase
#' @export
#'
#' @examples
#' filename_without_date("20220302_Some_File.csv")
#' #> [1] "somefile"
#'
filename_without_date <- function(filename){

  file_extensions <- c(".xlsx", ".csv", ".rds", ".png", ".jpg", ".jpeg", ".xls")

  stripped_filename <- gsub('[_-]', '', gsub('[[:digit:]]+', '',basename(filename)))

  for (extension in file_extensions){
    stripped_filename <- gsub(extension, "", stripped_filename)
  }

  return(tolower(stripped_filename))

}
