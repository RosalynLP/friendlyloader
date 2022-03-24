
suggest_alternative_files <- function(keywords, location, recursive = TRUE){

  possibilities <- c()

  # Go through the list of keywords and search for files based off them
  for(keyword in keywords){
    key_poss <- list.files(path = location, pattern = keyword, all.files = FALSE,
                           full.names = TRUE, recursive = recursive,
                           ignore.case = TRUE, include.dirs = TRUE, no.. = FALSE)

    possibilities <- append(possibilities, key_poss)

  }

  print(unique(possibilities))
  user_choice <- readline(
    prompt="Should I use one of the above files? Type the number to use, or type 'No' and press Enter.     "
  )

  tryCatch(expr = {
    return(possibilities[as.integer(user_choice)])
  },
  warning = function(w){
    file_choice <- NA
  }
  )

}
