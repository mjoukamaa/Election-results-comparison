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

# The first two .csv files include data only from
# Helsinki voting district (district number 01)
parliamentary_by_candidate_raw <- read_csv2('e-2015_ehd_01.csv', col_names = FALSE,
                                            locale = election_data_settings)
                                    
parliamentary_by_area_raw <- read_csv2('e-2015_alu_01.csv',col_names = FALSE,
                                       locale = election_data_settings)

# As the next file includes candidate vote totals by individual voting areas
# for the whole country, n_max is used to read only the records from Helsinki
# voting district in order to keep the data file size in reasonable limits
municipal_by_candidate_raw <- read_csv2('kv-2017_teat_maa.csv', col_names = FALSE,
                                    n_max = 181028, locale = election_data_settings)

# This file covers also the whole country, but can be read in whole due to its
# smaller size; records from other municipalities are filtered out later
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
  # Filtering for the candidate of interest, also excluding total
  # counts for all of the voting district included in the raw data
  filter(X18 == '[Candidate_first_name]' & X19 == '[Candidate_last_name]' &
         X16 != 'Helsinki' & X16 != 'Helsingin vaalipiiri') %>%
  # Creating a single name variable from the first and last name
  # columns plus converting vote totals to integers as above
  mutate(candidate_name = paste(X18, X19, sep = " "),
         candidate_vote_total = as.integer(X35)) %>%
  # Selecting the variables relevant for making the comparisons
  select(candidate_name, area_name = X16, candidate_vote_total)

# Joining the two dataframes together
parliamentary_combined <- left_join(parliamentary_candidate_data, 
                                    parliamentary_by_area,
                                    by = 'area_name')


# Making the corresponding selections, conversions and joins
# for the municipal elections data
municipal_by_area <- municipal_by_area_raw %>%
  # filtering out data from other municipalities than Helsinki
  filter(X6 == 'HEL') %>% 
  select(area_name = X10, area_number = X5, area_vote_total = X66) %>%
  mutate(area_number = substr(area_number, 1, nchar(area_number)-1),
         area_vote_total = as.integer(area_vote_total))

municipal_candidate_data <- municipal_by_candidate_raw %>%
  filter(X18 == '[Candidate_first_name]' & X19 == '[Candidate_last_name]' &
         X16 != 'Helsinki' & X16 != 'Helsingin vaalipiiri') %>%
  mutate(candidate_name = paste(X18, X19, sep = " "),
         candidate_vote_total = as.integer(X35)) %>%
  select(candidate_name, area_name = X16, candidate_vote_total)

municipal_combined <- left_join(municipal_candidate_data,
                                municipal_by_area,
                                by = 'area_name')


# Making the area-wise vote sum comparisons both sets
# of the data, with calculations of candidate's
# percentage of total votes for each area included

parliamentary_combined %>%
  group_by(area_number) %>%
  summarize(area_sums = sum(area_vote_total), candidate_sums = sum(candidate_vote_total),
            area_pct = candidate_sums / area_sums * 100) %>%
  arrange(desc(candidate_sums))

municipal_combined %>%
  group_by(area_number) %>%
  summarize(area_sums = sum(area_vote_total), candidate_sums = sum(candidate_vote_total),
            area_pct = candidate_sums / area_sums * 100) %>%
  arrange(desc(candidate_sums))
