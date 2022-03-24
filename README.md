
# friendlyloader

<!-- badges: start -->
<!-- badges: end -->

The goal of friendlyloader is to help with routine running of scripts 
where you expect to find a file in a certain location, but where the
name of the file can be subject to minor changes, such as a change in 
date or using "_" or "-" instead of spaces.

## Installation

You can install the development version of friendlyloader like so:

``` r
remotes::install_github("RosalynLP/friendlyloader")
```

## Example

This will look "data/my_apples.csv"
- If it's there it will return "data/my_apples.csv"
- If it's not there it will prompt the user with a list of filenames in "data" or subdirectories which include "my" or "apples"
- If the user selects an alternative, it will return this alternative filepath
- If the user doesn't select an alternative, an error is thrown

``` r
library(friendlyloader)

check_file("data/my_apples.csv")
```

