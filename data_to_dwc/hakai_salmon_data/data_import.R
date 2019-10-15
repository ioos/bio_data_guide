library(tidyverse)
library(lubridate)
library(here)

# Read in Hakai Salmon Program Data
seine_data <- read_csv("https://raw.githubusercontent.com/HakaiInstitute/jsp-data/master/data/seine_data.csv") %>% 
  select(seine_id, survey_id, lat, long, set_time, so_total, pi_total, cu_total, 
         co_total, he_total, ck_total)

write_csv(seine_data, here::here("data_to_dwc", "hakai_salmon_data", "raw_data", "seine_data.csv"))

fish_lab_data <- read_csv(
  "https://raw.githubusercontent.com/HakaiInstitute/jsp-data/master/data/fish_lab_data.csv") %>% 
  select(ufn, weight, fork_length, quality_flag)


fish_field_data <- read_csv(
  "https://raw.githubusercontent.com/HakaiInstitute/jsp-data/master/data/fish_field_data.csv") %>% 
  select(ufn, semsp_id, seine_id, species, fork_length_field, weight_field)

# Comnbine fish lab and fish field data
fish_data <- left_join(fish_field_data, fish_lab_data) 

write_csv(fish_data, here::here("data_to_dwc", "hakai_salmon_data", "raw_data", "fish_data.csv"))

