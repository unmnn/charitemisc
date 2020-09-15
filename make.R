rmarkdown::render(input = "README.rmd")
# source(file.path("data-raw", "charite.R"), encoding = 'UTF-8')
source(file.path("data-raw", "data_dict.R"), encoding = 'UTF-8')

devtools::document()
devtools::check()
