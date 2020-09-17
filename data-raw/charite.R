library(tidyverse)
library(readxl)

file_path <- file.path("data-raw", "Tinnitusgross_2015_11_Gesamt_ab_2011.xlsx")
sheets <- c("sozk",
            "tinskal",
            "acsa",
            "tq",
            "psq",
            "sf8",
            "swop",
            "tlq",
            "adsl",
            "bsf",
            "bi",
            "ses",
            "schmerzskal",
            "phqk",
            "isr",
            "soc")
str_date <- "190311"

# Read all tables of original excel sheet ----
data <- map(1:length(sheets), ~read_excel(file_path, sheet = .x))
names(data) <- sheets

# Convert dttm to date ----
data <- map(data, function(x){
  mutate_if(x, lubridate::is.POSIXct, lubridate::as_date)
})

# Replace German Umlaute ----
data <- map(data, function(x){
  names(x) <- stringi::stri_replace_all_fixed(
    names(x),
    c("ä", "ö", "ü", "Ä", "Ö", "Ü"),
    c("ae", "oe", "ue", "Ae", "Oe", "Ue"),
    vectorize_all = FALSE
  )
  return(x)
})

# Make all variables names lowercase ----
data <- map(data, function(x){
  names(x) <- str_to_lower(names(x))
  x
})

# Replace "zeitmarke" with "timestamp"
data <- map(data, function(x){
  names(x) <- str_replace(names(x), "zeitmarke", "timestamp")
  x
})

# sozk variables: replace 9 with NA ----
rep_nine_with_NA <- function(x){
  x[x == 9] <- NA
  x
}
data$sozk <- mutate(data$sozk, across(starts_with("soz"), rep_nine_with_NA))

# ALL: remove duplicate rows -> take the row with higher REC_NR
# data$tinnitusfbg` %>%
#   count(jour_nr, testdatum, phase) %>%
#   pull(n) %>% table()

# num rows before duplicate removal
num_rows_before <- map_int(data, nrow)

# Remove duplicate rows ----
data <- map(data, function(x){
  x <- x %>%
    group_by(jour_nr, testdatum, phase) %>%
    arrange(desc(rec_nr)) %>%
    slice(1) %>%
    ungroup()
})

# num rows after duplicate removal
num_rows_after <- map_int(data, nrow)

# difference
num_rows_after - num_rows_before

# Remove ACSA01 as there are only missing values ----
data$acsa <- data$acsa %>%
  mutate(testdatum = lubridate::as_date(testdatum)) %>%
  select(-acsa01)

# sheet names: remove _, make lowercase ----
sheets <- str_to_lower(sheets) %>%
  str_remove_all("-") %>%
  str_remove_all("_")


# Remove irrelevant vars ----
irr_cols <- c("fall_zaehl", "code", "bearbeiter", "rec_nr")
data <- map(data, ~ .x %>% select(-all_of(irr_cols)))

# add sheet prefix to variables ----
meta_cols <- c("jour_nr", "age", "testdatum", "phase")
meta_cols_new <- str_c(".", meta_cols)

data <- map2(data, sheets, function(x, y){
  names_to_replace <- which(!names(x) %in% c(meta_cols))
  names(x)[names_to_replace] <- str_c(y, "_", names(x)[names_to_replace])
  x
})

# add . prefix to meta vars ----
data <- map(data, function(x){
  xy <- x %>% select(all_of(meta_cols), everything())
  names(xy)[1:length(meta_cols)] <- meta_cols_new
  xy
})

# transform sozk features ----
df <- data$sozk
pattern <- "^sozk_.*\\d$"

col_idx_relevant <- str_which(names(df), pattern)

# Alle Patienten haben mindestens einen fehlenden Wert bei den soz_k-Daten
df_new_vars <- df %>%
  select(all_of(col_idx_relevant)) %>%
  mutate(sozk_soz01_male = if_else(sozk_soz01 == 1, 1L, 0L)) %>%
  mutate(sozk_soz02_german = if_else(sozk_soz02 == 1, 1L, 0L)) %>%
  mutate(sozk_soz05_partner = if_else(sozk_soz05 == 1, 1L, 0L)) %>%
  mutate(sozk_soz06_unmarried = if_else(sozk_soz06 == 1, 1L, 0L)) %>%
  mutate(sozk_soz06_married = if_else(sozk_soz06 == 2, 1L, 0L)) %>%
  mutate(sozk_soz06_divorced = if_else(sozk_soz06 == 3, 1L, 0L)) %>%
  mutate(sozk_soz09_abitur = if_else(sozk_soz09 == 1, 1L, 0L)) %>%
  mutate(sozk_soz09_fachabitur = if_else(sozk_soz09 == 2, 1L, 0L)) %>%
  mutate(sozk_soz09_mittlreife = if_else(sozk_soz09 == 3, 1L, 0L)) %>%
  mutate(sozk_soz09_hauptsch = if_else(sozk_soz09 == 4, 1L, 0L)) %>%
  mutate(sozk_soz10_schueazubi = if_else(sozk_soz10 %in% c(1,2), 1L, 0L)) %>%
  mutate(sozk_soz10_geselle = if_else(sozk_soz10 == 3, 1L, 0L)) %>%
  mutate(sozk_soz10_meister = if_else(sozk_soz10 == 4, 1L, 0L)) %>%
  mutate(sozk_soz10_student = if_else(sozk_soz10 == 5, 1L, 0L)) %>%
  mutate(sozk_soz10_graduate = if_else(sozk_soz10 == 6, 1L, 0L)) %>%
  mutate(sozk_soz10_keinAbschl = if_else(sozk_soz10 == 1, 1L, 0L)) %>%
  mutate(sozk_soz11_job = if_else(sozk_soz11 == 1, 1L, 0L)) %>%
  # soz12 rauslassen
  # soz16 mit soz17 kombinieren
  mutate(sozk_soz1617_arblos = case_when(sozk_soz16 == 2 ~ 0,
                                         sozk_soz17 == 1 ~ .25,
                                         sozk_soz17 == 2 ~ .75,
                                         sozk_soz17 == 3 ~ 1.5,
                                         sozk_soz17 == 4 ~ 2.5,
                                         sozk_soz17 == 5 ~ 4,
                                         TRUE ~ NA_real_)) %>%
  # soz18: 'mithelfend im eigenen Betrieb' 'sonstiges' und NA zusammengefasst
  mutate(sozk_soz18_selbstst = if_else(sozk_soz18 == 1, 1L, 0L)) %>%
  mutate(sozk_soz18_arbeiter = if_else(sozk_soz18 == 2, 1L, 0L)) %>%
  mutate(sozk_soz18_angest = if_else(sozk_soz18 == 3, 1L, 0L)) %>%
  mutate(sozk_soz18_beamter = if_else(sozk_soz18 == 4, 1L, 0L)) %>%
  mutate(sozk_soz18_other = if_else(sozk_soz18 %in% c(5,6), 1L, 0L)) %>%
  # soz19 mit soz20 kombinieren
  mutate(sozk_soz1920_krank = case_when(sozk_soz19 == 2 ~ 0,
                                        sozk_soz20 == 1 ~ 1,
                                        sozk_soz20 == 2 ~ 3.5,
                                        sozk_soz20 == 3 ~ 9,
                                        TRUE ~ NA_real_)) %>%
  mutate(sozk_soz21_tindauer = case_when(sozk_soz21 == 1 ~ 0.25,
                                         sozk_soz21 == 2 ~ 0.75,
                                         sozk_soz21 == 3 ~ 1.5,
                                         sozk_soz21 == 4 ~ 3.5,
                                         sozk_soz21 == 5 ~ 5,
                                         TRUE ~ NA_real_)) %>%
  # soz22 mit soz24 kombinieren
  mutate(sozk_soz2224_psycho = case_when(sozk_soz22 == 2 ~ 0,
                                         sozk_soz24 == 1 ~ 0.5,
                                         sozk_soz24 == 2 ~ 5.5,
                                         sozk_soz24 == 3 ~ 12,
                                         TRUE ~ NA_real_)) %>%
  mutate(sozk_soz25_numdoc = as.double(sozk_soz25)) %>%
  select(-matches(pattern))
df_new_vars[is.na(df_new_vars)] <- 0

df <- bind_cols(df %>% select(-all_of(col_idx_relevant)), df_new_vars)
data$sozk <- df

# binarize tlq features ----
data$tlq <- data$tlq %>%
  # tlq01: Tinnituslokalisation
  # 1 = right ear
  mutate(tlq_tlq01_1 = as.integer(tlq_tlq01 == 1)) %>%
  # 2 = left ear
  mutate(tlq_tlq01_2 = as.integer(tlq_tlq01 == 2)) %>%
  # 3 = both ears
  mutate(tlq_tlq01_3 = as.integer(tlq_tlq01 == 3)) %>%
  # 4 = entire head
  mutate(tlq_tlq01_4 = as.integer(tlq_tlq01 == 4)) %>%
  # tlq02: Tinnitusqualität
  # 1 = whistling
  mutate(tlq_tlq02_1 = as.integer(tlq_tlq02 == 1)) %>%
  # 2 = hissing (zischen)
  mutate(tlq_tlq02_2 = as.integer(tlq_tlq02 == 2)) %>%
  # 3 = ringing
  mutate(tlq_tlq02_3 = as.integer(tlq_tlq02 == 3)) %>%
  # 4 = rustling (rauschen)
  mutate(tlq_tlq02_4 = as.integer(tlq_tlq02 == 4)) %>%
  select(-c(tlq_tlq01, tlq_tlq02))

# remove strongly redundant features ----
data <- map(data, ~.x %>% select(-ends_with("100")))

# add panic syndrome variable ----
data$phqk <- data$phqk %>%
  mutate(phqk_paniksyndrom = if_else(phqk_phqk_2a +
                                       phqk_phqk_2b +
                                       phqk_phqk_2c +
                                       phqk_phqk_2d +
                                       phqk_phqk_2e == 5, 1L, 0L),
         .before = phqk_timestamp)

# join tables ----
pos_tinnitusfbg <- which(names(data) == "tq")
data <- c(data[pos_tinnitusfbg], data[-pos_tinnitusfbg])
df_data <- data %>% reduce(full_join, by = meta_cols_new)

# remove underage patients ----
df_data <- df_data %>% filter(.age >= 18)

# for each patient, add sequence of phases ----
df_data <- df_data %>%
  arrange(.jour_nr, .testdatum, .phase) %>%
  group_by(.jour_nr) %>%
  mutate(.phase_seq = str_c(.phase, collapse = ""), .after = .phase) %>%
  ungroup()

# save data as tibble ----
charite <- df_data
usethis::use_data(charite, overwrite = TRUE)
