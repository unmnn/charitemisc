#' Charite tinnitus data dictionary.
#'
#' A data frame with descriptions for every variable in the Charite tinnitus
#' questionnaire data.
#'
#' Note: As of 17.08.2020, english descriptions of variables of the following
#' questionnaires are available: meta, acsa, adsl, bi, bsf, isr, phq, psq, sozk,
#' sf8, tq, tinskal, tlq.
#'
#' The descriptions for variables of soc and swop have yet to be translated.
#'
#' @format A data frame with 5 variables:
#' \describe{
#'   \item{item}{`chr` Name of the variable. Meta variables like ".jour_nr" start
#'   with a ".".}
#'   \item{label}{`chr` Label of the variable. Note, that while every variable has a
#'   name, not every variable has a label.}
#'   \item{description}{`chr` Description of the variable.}
#'   \item{values}{`list` Mapping of numeric values to character strings for
#'   categorical variables. `NULL` for numeric variables.}
#'   ...
#' }
#' @source \url{https://tinnituszentrum.charite.de/}
#'
#'
"data_dict"

#' Tinnitus patients data from Charite Universitaetsmedizin Berlin.
#'
"charite"
