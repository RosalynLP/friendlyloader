#' Suggest alternative files
#'
#' Searches for files in `location` containing one of the `keywords`, and returns
#' a character vector of the possibilties, prompting the user to pick one. Returns
#' the chosen possibility, or if none is chosen returns NA.
#'
#' @param keywords A character vector
#' @param location A character vector with one element
#' @param file_filter Glob filter to choose which type of files to look for e.g. "*.csv"
#' @param recursive Boolean for whether to recurse into directories to search
#' @param useRstudio Boolean for whether to use interactive R studio to find files
#'
#' @return A character vector or NULL
#' @export
#'
#' @examples
#' # keywords <- c("apple", "orange")
#' # location <- "data/"
#' # suggest_alternative_files(keywords, location)
suggest_alternative_files <- function(keywords, location, file_filter="*",
                                      recursive = TRUE, useRstudio=TRUE){

  # USE RSTUDIO
  if(useRstudio){

    # Default is interactive selection of file
    file_choice <- rstudioapi::selectFile(caption="Choose an alternative file to load",
                                            path=location,
                                            filter=file_filter)
    if (is.null(file_choice)){
      rstudioapi::showDialog(title="Terminating script",
                             message="No file selected. Terminating script.")
      stop("No file selected. Terminating script.")
    } else {
      return(file_choice)
    }


    # NOT USING RSTUDIO
    } else {

      # Searching for possibilities
      possibilities <- c()

      # Go through the list of keywords and search for files based off them
      for(keyword in keywords){
        key_poss <- list.files(path = location, pattern = keyword, all.files = FALSE,
                               full.names = TRUE, recursive = recursive,
                               ignore.case = TRUE, include.dirs = TRUE, no.. = FALSE)

        possibilities <- append(possibilities, key_poss)
      }

      # No alternatives found
      if (length(possibilities) == 0){ # No alternative files found
        stop(glue::glue("No alternatives found in directory {location}. Terminating script."))
      }

      # Alternatives found

      if(interactive()){ # Check whether session is interactive

        message("Should I use one of the files below?")
        print(tibble::tibble(Filename = basename(unique(possibilities)),
                           Subdirectory = gsub(location, '.', dirname(unique(possibilities)))
                           )
            )
        user_choice <- readline(
          prompt="Type the number to use, or type 'No' and press Enter.     "
        )
        # Get file choice
        tryCatch(expr = {
         return(possibilities[as.integer(user_choice)])
            },
        warning = function(w){
         return(NULL)
            })

      } else { # If not interactive, choose first option

        message("Choosing first match to filename as session is not interactive")
        user_choice <- 1
        # Get file choice
        tryCatch(expr = {
         return(possibilities[as.integer(user_choice)])
       },
        warning = function(w){
         return(NULL)
          } )
      } # not interactive


  } # not using R studio

} # function bracket

