#' Create a read/write (i/o) function with a given base location
#'
#' \code{create_location_io} creates a wrapper around a function such as
#' \code{readRDS} or \code{readr::write_csv}, creating a new function where
#' reading/writing is done relative to a specified \code{data_folder}, rather
#' than the working directory. The new function is saved out with the same name
#' as the input function prefixed by \code{prefix_}.
#'
#' This function is used for it's side effects. It assigns a wrapped function
#' to an \code{environment}, by default the \code{global environment}.
#'
#' The functions created by \code{create_location_io} can be used in just the
#' same way as the functions they wrap, all the same arguments are available.
#' The only difference is that the filepath that you pass to the wrapped
#' function is appended to the \code{data_folder} that the function was
#' created with. For instance, if \code{create_location_io} is used to wrap
#' \code{fread}, as
#' \code{create_location_io(data.table::fread, "/tmp/directory")}
#' then a new function will be created in the \code{global environment}
#' (your workspace), called \code{project_fread}. If you use this function to
#' read a file, as \code{data <- project_fread("data/myfile.csv")},
#' then the file will be read from \code{"/tmp/directory/data/myfile.csv"}.
#'
#' Even where \code{io} is specified, the function will try to deduce whether
#' \code{startfun} is an input, or output, function. If this deduction fails then
#' you will be warned. If the deduction doesn't match \code{io} then the
#' function will ask the user if they want to continue.
#'
#' @param startfun \code{function} to create a wrapper around
#' @param data_folder \code{character} string giving the filepath of the base
#' location the new function will read/write from
#' @param io \code{character} string taking values of either "read" or "write",
#' indicating whether \code{startfun} reads or writes information. If \code{io}
#' is missing then the function will try to deduce the correct value from the
#' name of \code{startfun}. \code{io} can also be abbreviated to "r" or "w"
#' @param prefix \code{character} string giving the prefix for the name of the
#' new function. Defaults to 'project'
#' @param env \code{environment} to add the new function to. Defaults to
#' \code{globalenv()}
#' @param ... other parameters to pass to \code{startfun}
#'
#' @return \code{create_location_io} returns its first argument invisibly
#'
#' @examples
#' \dontrun{
#'
#' # Create a variable holding the path to the data folder.
#' dat_folder <- "/path/to/chosen/data/folder/"
#'
#' # Create some wrapped i/o functions. That read/write to
#' # 'dat_folder' as a base location.
#' create_location_io(saveRDS, dat_folder, io = "write")
#' create_location_io(readRDS, dat_folder, prefix = "custom")
#'
#' # Create some data.
#' x <- 2
#'
#' # Save the data to 'dat_folder' using the wrapped function.
#' project_saveRDS(x, "test.rds")
#'
#' # Read the saved file back into R.
#' y <- custom_readRDS("test.rds")
#'
#' y
#' }
#'
#' @export
create_location_io <- function(startfun, data_folder, io = c("read", "write"),
                              prefix = "project", env = globalenv(), ...){

  ## Argument testing

  # Check that startfun and data_folder arguments have both been provided.
  if (missing(startfun) | missing(data_folder)) {
    stop("Arguments startfun and data_folder must both be provided")
  }

  # Check that startfun is a function that can be found.
  if (!(tryCatch(is.function(startfun), error = function(cond) FALSE))) {
    stop(paste("function", deparse(substitute(startfun)), "not found"))
  }

  # Check data_folder is a length one character string.
  if (!(is.character(data_folder) & length(data_folder) == 1)) {
    stop("data_folder must be a character string of length 1")
  }

  # Check that data_folder exists.
  if (!dir.exists(data_folder)) {
    stop(paste0("data_folder (", data_folder,
                ") either doesn't exist or isn't a directory"))
  }

  # If io is not missing check it is a length one character string
  # with a valid value.
  if (!missing(io)) {

    # Check that io is a length one character string.
    if (!(is.character(io) & length(io) == 1)) {
      stop("io must be a character string of length 1")
    }

    # Check that io has a valid value.
    if (!(io %in% c("read", "r", "write", "w"))) {
      stop(paste(io, "is not a valid value for io"))
    }
  }

  # Check prefix is a length one character string.
  if (!(is.character(prefix) & length(prefix) == 1)) {
    stop("prefix must be a character string of length 1")
  }

  # Check that env is an environment.
  if(!is.environment(env)) {
    stop("env must be an environment")
  }

  ## Body of function

  # Get the start function name e.g. "read_csv" from "readr::read_csv".
  funname <- sub("^.*::", "", deparse(substitute(startfun)))

  # Determine the value of io from the function argumnt.
  if (!missing(io)) {
    io <- match.arg(io)

  } else {
    io <- NULL

  }

  # Deduce an io by searching for keywords in the function name to determine
  # whether the function is for input or output
  if(grepl("read", funname)) {
    io_derived <- "read"

  } else if (grepl("write", funname) | grepl("save", funname)) {
    io_derived <- "write"

  } else {
    warning(paste("Unclear from the name whether startfun is an i/o function.",
                  "Proceeding anyway ..."))
  }

  # Make sure that io and io_derived are consistent and assign a final io.
  if (is.null(io) & exists("io_derived")) {
    io <- io_derived

  } else if (!is.null(io) & exists("io_derived")) {

    if(io != io_derived) {
      # io disagrees with io_derived. Ask the user if they want to continue.
      continue <- ask_edris_user(
        title = "Warning",
        message = glue::glue("io is set to {io} but function {funname} ",
                             "has {io_derived} in the name. ",
                             "Do you wish to continue?"),
        ok = "Yes", cancel = "No")

      if(!continue){
        stop("Terminating call to create_location_io. No io created.")
      }
    }

  }

  # Make a final check that we have a value for io.
  if (is.null(io)) {
    stop(paste("io is missing and couldn't be deduced from startfun.",
               "Please re-run with io set to either 'read' or 'write'"))
  }

  # Create wrapped function and assign to env.
  if(io == "read") {

    assign(glue::glue("{prefix}_{funname}"),
           function(filename, ...){
             contents <- startfun(glue::glue("{data_folder}/{filename}"), ...)

             return(contents)
           }, envir = env)

  } else if (io == "write"){

    assign(glue::glue("{prefix}_{funname}"),
           function(x, filename, ...){
             startfun(x, glue::glue("{data_folder}/{filename}"), ...)

             invisible()
           }, envir = env)
  }

  # Return the first argument invisibly.
  invisible(startfun)
}
