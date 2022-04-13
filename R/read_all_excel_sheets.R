#' Read all Excel sheets
#'
#' Reads all sheets of an Excel file to a list using `openxlsx::read.xlsx`.
#' Checks the file exists and suggests alternatives if not.
#'
#' @param xlsxFile String of path to Excel file
#' @param ... Additional arguments to pass to openxlsx::read.xlsx
#'
#' @return List of contents of each Excel sheet
#' @export
#'
#' @examples
#'
read_all_excel_sheets = function(xlsxFile, ...) {

  xlsxFile <- check_file(xlsxFile)

  ##### Read the excel file
  sheet_names = openxlsx::getSheetNames(xlsxFile)
  sheet_list = as.list(rep(NA, length(sheet_names)))
  names(sheet_list) = sheet_names
  for (sn in sheet_names) {
    sheet_list[[sn]] = openxlsx::read.xlsx(xlsxFile,
                                           sheet=sn,
                                           sep.names=" ",
                                           detectDates=TRUE,
                                           colNames=TRUE, ...)
  }
  return(sheet_list)

}
