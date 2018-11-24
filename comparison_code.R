library(tidyverse)

election_data_settings <- locale(date_names = "fi", date_format = "%AD",
                              time_format = "%AT", decimal_mark = ",",
                              grouping_mark = " ", tz = "EET", 
                              ncoding = "ISO-8859-1", asciify = FALSE)
                              
parliamentary_by_candidate <- read_csv2('e-2015_ehd_01.csv', col_names = FALSE,
                                    locale = election_data_settings)
                                    
parliamentary_by_area <- read_csv2('e-2015_alu_01.csv', col_names = FALSE,
                                  locale = election_data_settings)
                                  
municipal_by_candidate <- read_csv2('kv-2017_teat_maa.csv', col_names = FALSE,
                                     n_max = 181000, locale = election_data_settings)

municipal_by_area <- read_csv2('kv-2017_taat_maa.csv', col_names = FALSE,
                               locale = election_data_settings)
