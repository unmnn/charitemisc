#' Extract the "legitimate" subset of patients who were treated
#'
#' In many scenarios, it is useful to extract the subset of patients who
#' received treatment. However, for several patients, there exist multiple
#' recordings in phase 'A' or 'E', respectively.
#' The function `filter_treated` finds the "closest" A recording to the first E
#' recording within the boundary of `tolerance` days.
#' Since the treatment was 7 days long, the function considers the A recording
#' that is closest to 7 days before the E recording (in case there are multiple
#' A recordings for the same patient).
#'
#' @param df The `charite` data.
#' @param tolerance The tolerable maximum number of days between an A recording
#' and its corresponding E recording.
#'
#' @return The filtered `charite`dataset. Each patient has exactly 1 A and 1 E
#' recording.
#' @export
#'
#' @import dplyr
#' @importFrom rlang .data
#'
filter_treated <- function(df, tolerance = 14L) {
  tmp <- df %>%
    tibble::rowid_to_column(".id") %>%
    select(.data$.id, .data$.jour_nr, .data$.testdatum, .data$.phase,
           .data$.phase_seq) %>%
    tidyr::drop_na() %>%
    arrange(.data$.jour_nr, .data$.testdatum, .data$.phase) %>%
    # patients must have recordings at both A and E
    filter(stringr::str_detect(.data$.phase_seq, "A+E+")) %>%
    # get row index of first "E"
    group_by(.data$.jour_nr) %>%
    mutate(.first_pos_e = stringr::str_locate(.data$.phase_seq, "E")[1,1]) %>%
    # only the first "E" interview is considered
    filter(!(.data$.phase == "E") | row_number() == .data$.first_pos_e) %>%
    # retain the "A" interview which was before "E" AND which is closest to "7 days before "E""
    # .td = (negative) difference between testing and first E testing in days
    mutate(.td = as.double(difftime(.data$.testdatum,
                                    .data$.testdatum[.data$.first_pos_e],
                                    units = "days"))) %>%
    # must be either before or at the same day, phase E
    filter(between(.data$.td, -tolerance, 0) | .data$.phase == "E") %>%
    # set .td to Inf for E testings
    mutate(.td = if_else(.data$.phase == "E", Inf, .data$.td)) %>%
    mutate(.td_diff_to_7_days = abs(.data$.td + 7)) %>%
    mutate(.a_final = case_when(min(.data$.td_diff_to_7_days) == Inf ~ FALSE,
                                .td_diff_to_7_days == min(.data$.td_diff_to_7_days) ~ TRUE,
                                TRUE ~ FALSE)) %>%
    mutate(.a_final = if_else(.data$.a_final | (any(.data$.a_final) & .data$.phase == "E"), TRUE, FALSE)) %>%
    filter(.data$.a_final) %>%
    ungroup()

  df %>% slice(tmp$.id)
}


