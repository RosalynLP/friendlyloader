friendlyloader
========
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/RosalynLP/friendlyloader)](https://github.com/RosalynLP/friendlyloader/releases/latest)

The goal of `friendlyloader` is to help with routine running of scripts 
where you expect to find a file in a certain location, but where the
name of the file can be subject to minor changes, such as a change in 
date or using "_" or "-" instead of spaces.

## Installation

You can install the development version of friendlyloader like so:

``` r
remotes::install_github("RosalynLP/friendlyloader")
```

## How to use

This package includes wrapper functions for `utils::readcsv`, `readxl::read_excel` and `openxlsx::read.xlsx`. Namely:

1. `friendlyloader::read_csv_with_options`
2. `friendlyloader::read_excel_with_options`
3. `friendlyloader::read_xlsx_with_options`

You supply the usual arguments to these functions, with the optional additional choices:

* `useRstudio` (default `TRUE`). A boolean indicating whether to pick an alternative file using interactive R Studio windows, or (when set to `FALSE`) whether to use the terminal.

* `recursive` (default `TRUE`). A boolean. Only impactful when `useRstudio == FALSE`. Whether to look for files recursively or only in the chosen directory.

### Creating a friendly loader for a different file type

If you want to load a file other than csv or Excel you can easily create your own loader 
using `create_loader_with_options()`. This takes in a function for loading your desired filetype
and outputs a friendly version of that function. For example, for loading RDS files using `readRDS()`:

```r
read_rds_with_options <- create_loader_with_options(readRDS)

read_rds_with_options("some_arbitrary_file.rds")

```

### Matching filenames with dates stripped out

Sometimes you want to load a file in a given location but the date of the file is subject to change. `match_base_filename` allows you to load the  file without triggering an interactive set of options, which can be useful if you are running a server job or Rmarkdown:

```r
# This will read fruits_colours.xlsx 
openxlsx::read.xlsx(match_base_filename("20220328_fruits_colours.xlsx"))
```

Note that there can be only one file called \*fruits\*colours\*xlsx in the given directory or else the call to this function is ambiguous and it will fail.

### Using the terminal selector - when `useRstudio = FALSE`

#### Loading a csv 

This is based on the function `utils::read.csv`

``` r
library(friendlyloader)

# Creating test data frame and writing to csv
df <- data.frame (Fruit = c("Apple", "Orange", "Pear"), Colour = c("Red", "Orange", "Green"))
write.csv(df, "fruits_colours.csv", row.names = FALSE)

# Trying to load csv but with slightly wrong filename
read_csv_with_options("20220328_fruits_colours.csv", useRstudio = FALSE)

#>Could not find file 20220328_fruits_colours.csv. Searching for possible alternatives.
#>Should I use one of the files below?
#># A tibble: 1 × 2
#>  Filename           Subdirectory
#>  <chr>              <chr>       
#>1 fruits_colours.csv .           
#>Type the number to use, or type 'No' and press Enter.     1
#>   Fruit Colour
#>1  Apple    Red
#>2 Orange Orange
#>3   Pear  Green
#>
```

#### Loading the first sheet of an Excel file

There are two options which work in the same way. One is based on the function `readxl::read_excel`, and 
the other is based on `openxlsx::read.xlsx`. The names of these functions are `read_excel_with_options` and `read_xlsx_with_options`, respectively.

``` r
library(friendlyloader)

# Creating test data frame and writing to csv
df <- data.frame (Fruit = c("Apple", "Orange", "Pear"), Colour = c("Red", "Orange", "Green"))
writexl::write_xlsx(df, "fruits_colours.xlsx")

# Trying to load csv but with slightly wrong filename
read_excel_with_options("fruits-colours.xlsx", useRstudio = FALSE)

#>Could not find file fruits-colours.csv. Searching for possible alternatives.
#>Should I use one of the files below?
#># A tibble: 2 × 2
#>  Filename            Subdirectory
#>  <chr>               <chr>       
#>1 fruits_colours.csv  .           
#>2 fruits_colours.xlsx .           
#>Type the number to use, or type 'No' and press Enter.     2
#># A tibble: 3 × 2                                                                                                
#>  Fruit  Colour
#>  <chr>  <chr> 
#>1 Apple  Red   
#>2 Orange Orange
#>3 Pear   Green 
#>
```

#### Loading all sheets of an Excel file

Same as above but use `read_all_excel_sheets()` rather than `read_excel_with_options()`.
This uses the `openxlsx` package to read the information.


