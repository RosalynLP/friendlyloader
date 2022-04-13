#' Suggest alternative files
#'
#' Searches for files in `location` containing one of the `keywords`, and returns
#' a character vector of the possibilties, prompting the user to pick one. Returns
#' the chosen possibility, or if none is chosen returns NA.
#'
#' @param keywords A character vector
#' @param location A character vector with one element
#' @param recursive Boolean for whether to recurse into directories to search
#'
#' @return A character vector or NULL
#' @export
#'
#' @examples
#' # keywords <- c("apple", "orange")
#' # location <- "data/"
#' # suggest_alternative_files(keywords, location)
suggest_alternative_files <- function(keywords, location, recursive = TRUE){

  possibilities <- c()

  # Go through the list of keywords and search for files based off them
  for(keyword in keywords){
    key_poss <- list.files(path = location, pattern = keyword, all.files = FALSE,
                           full.names = TRUE, recursive = recursive,
                           ignore.case = TRUE, include.dirs = TRUE, no.. = FALSE)

    possibilities <- append(possibilities, key_poss)

  }

  if (length(possibilities) == 0){ # No alternative files found

    stop(glue::glue("No alternatives found in directory {location}. Terminating script."))

  } else { # Found alternative files

    if(interactive()){ # Check whether session is interactive

      message("Should I use one of the files below?")
      print(tibble::tibble(Filename = basename(unique(possibilities)),
                           Subdirectory = gsub(location, '.', dirname(unique(possibilities)))
                           )
            )
      user_choice <- readline(
        prompt="Type the number to use, or type 'No' and press Enter.     "
      )


    } else { # If not interactive, choose first option

      message("Choosing first match to filename as session is not interactive")
      user_choice <- 1

    }

    # Get file choice
    tryCatch(expr = {
      return(possibilities[as.integer(user_choice)])
    },
    warning = function(w){
      file_choice <- NULL
    }
    )


  }

}
