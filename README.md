friendlyloader
========

The goal of friendlyloader is to help with routine running of scripts 
where you expect to find a file in a certain location, but where the
name of the file can be subject to minor changes, such as a change in 
date or using "_" or "-" instead of spaces.

## Installation

You can install the development version of friendlyloader like so:

``` r
remotes::install_github("RosalynLP/friendlyloader")
```

## How to use

### Loading a csv 
``` r
library(friendlyloader)

# Creating test data frame and writing to csv
df <- data.frame (Fruit = c("Apple", "Orange", "Pear"), Colour = c("Red", "Orange", "Green"))
write.csv("fruits_colours.csv", row.names = FALSE)

# Trying to load csv but with slightly wrong filename
read_csv_with_options("20220328_fruits_colours.csv")

#> Could not find file 20220328_fruits_colours.csv. Searching for possible alternatives.
#> [1] "./fruits_colours.csv"
#> Should I use one of the above files? Type the number to use, or type 'No' and press Enter.     1
#>    Fruit Colour
#> 1  Apple    Red
#> 2 Orange Orange
#> 3   Pear  Green
#> 

```

### Loading the first sheet of an Excel file
``` r
library(friendlyloader)

# Creating test data frame and writing to csv
df <- data.frame (Fruit = c("Apple", "Orange", "Pear"), Colour = c("Red", "Orange", "Green"))
writexl::write_xlsx(df, "fruits_colours.xlsx")

# Trying to load csv but with slightly wrong filename
read_excel_with_options("fruits-colours.csv")

#> Could not find file fruits-colours.xlsx. Searching for possible alternatives.
#> [1] "./fruits_colours.csv"
#> [2] "./fruits_colours.xlsx"
#> Should I use one of the above files? Type the number to use, or type 'No' and press Enter.     2
#>    Fruit Colour
#> 1  Apple    Red
#> 2 Orange Orange
#> 3   Pear  Green
#> 

```

### Loading all sheets of an Excel file

Same as above but use `read_all_sheets()` rather than `read_excel_with_options()`

### Creating a friendly loader for a different file type

If you want to load a file other than csv or Excel you can easily create your own loader 
using `create_loader_with_options()`. This takes in a function for loading your desired filetype
and outputs a friendly version of that function. For example, for loading RDS files using `readRDS()`:

```r
read_rds_with_options <- create_loader_with_options(readRDS)

read_rds_with_options("Fruits_colours.rds")

```



