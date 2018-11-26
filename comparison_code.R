# Loading up the tidyverse library
# for easier data handling
library(tidyverse)


# Setting up a locale variable for read_csv2() to handle
# character encodings and other features of the data
election_data_settings <- locale(date_names = "fi", date_format = "%AD",
                                 time_format = "%AT", decimal_mark = ",",
                                 grouping_mark = " ", tz = "EET", 
                                 encoding = "ISO-8859-1", asciify = FALSE)


# Reading up the different .csv datafiles into tibbles/dataframes,
# using read_csv2 since fields are separated by semicolons

parliamentary_by_candidate_raw <- read_csv2('e-2015_ehd_01.csv', col_names = FALSE,
                                        locale = election_data_settings)
                                    
parliamentary_by_area_raw <- read_csv2('e-2015_alu_01.csv', col_names = FALSE,
                                   locale = election_data_settings)
                                  
municipal_by_candidate_raw <- read_csv2('kv-2017_teat_maa.csv', col_names = FALSE,
                                    n_max = 181000, locale = election_data_settings)

municipal_by_area_raw <- read_csv2('kv-2017_taat_maa.csv', col_names = FALSE,
                               locale = election_data_settings)


parliamentary_by_area <- parliamentary_by_area_raw %>%
  # Selecting the variables relevant for making the comparisons
  select(area_name = X10, area_number = X5, area_vote_total = X66) %>%
  # Dropping the last character from voting area codes so that they
  # can be aggregated by their common numerical designator, also
  # converting vote totals from strings to integers
  mutate(area_number = substr(area_number, 1, nchar(area_number)-1),
         area_vote_total = as.integer(area_vote_total))

parliamentary_candidate_data <- parliamentary_by_candidate_raw %>%
  filter(X18 == '[Candidate_first_name]' & X19 == '[Candidate_last_name]' &
         X16 != 'Helsinki' & X16 != 'Helsingin vaalipiiri') %>%
  mutate(candidate_name = paste(X18, X19, sep = " "),
         candidate_vote_total = as.integer(X35)) %>%
  select(candidate_name, area_name = X16, candidate_vote_total)



# Making the corresponding selections and conversions for
# the municipal elections data

municipal_by_area <- municipal_by_area_raw %>%
  select(area_name = X10, area_number = X5, area_vote_total = X66) %>%
  mutate(area_number = substr(area_number, 1, nchar(area_number)-1),
         area_vote_total = as.integer(area_vote_total))

municipal_candidate_data <- municipal_by_candidate_raw %>%
  filter(X18 == '[Candidate_first_name]' & X19 == '[Candidate_last_name]' &
         X16 != 'Helsinki' & X16 != 'Helsingin vaalipiiri') %>%
  mutate(candidate_name = paste(X18, X19, sep = " "),
         candidate_vote_total = as.integer(X35)) %>%
  select(candidate_name, area_name = X16, candidate_vote_total)
