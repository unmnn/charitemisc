
# charitemisc

Miscellaneous helper functions for the Charité tinnitus data.

## Installation

``` r
remotes::install_github("unmnn/charitemisc")
```

## Usage

``` r
library(charitemisc)
library(dplyr)
library(purrr)
data_dict
```

    ## # A tibble: 379 x 4
    ##    item       label           description                    values   
    ##    <chr>      <chr>           <chr>                          <list>   
    ##  1 .age       age             patient age                    <NULL>   
    ##  2 .jour_nr   .jour_nr        patient ID                     <NULL>   
    ##  3 .group     .group          meta: group                    <NULL>   
    ##  4 .phase     .phase          phase                          <chr [3]>
    ##  5 .testdatum Date            testing date                   <NULL>   
    ##  6 .day       testing_day     testing date: day of the month <NULL>   
    ##  7 .weekday   testing_weekday testing date: day of the week  <NULL>   
    ##  8 .yearday   testing_yearday testing date: day of the year  <NULL>   
    ##  9 .week      testing_week    testing date: calendar week    <NULL>   
    ## 10 .month     testing_month   testing date: month            <NULL>   
    ## # ... with 369 more rows

``` r
var <- "adsl_adsl01"
data_dict %>% filter(item == var) %>% pull(description)
```

    ## [1] "\"During the past week I was bothered by things that usually don't bother me.\""

``` r
data_dict %>% filter(item == var) %>% pluck("values", 1)
```

    ##              0              1              2              3 
    ##       "rarely"    "sometimes" "occasionally"       "mostly"
