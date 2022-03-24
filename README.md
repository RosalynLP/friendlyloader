
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

This will look for files inside data/ with "apples" or "oranges" in the name, 
and return a list of possibilities.

``` r
library(friendlyloader)

suggest_alternative_files(keywords = c("apples", "oranges"), location = "data/")
```

