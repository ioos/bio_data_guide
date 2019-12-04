library(tidyverse)
library(lubridate)
library(here)

# Read in Hakai Salmon Program Data v1.0.2 (current as of 2019-11-12)

survey_data <- read_csv(here("data_to_dwc", "hakai_salmon_data", "v1.0.2", "data", "survey_data.csv")) %>% 
  filter(survey_type == "standard") %>% 
  select(survey_id, survey_date)


write_csv(survey_data, here::here("data_to_dwc", "hakai_salmon_data", "raw_data", "survey_data.csv"))

seine_data <- read_csv(here("data_to_dwc", "hakai_salmon_data", "v1.0.2", "data", "seine_data.csv")) %>% 
  filter(collection_protocol == "SEMSP",
         fish_retained == "yes") %>% # Not concerned with effort, so remove zero catch seines
  select(seine_id, survey_id, lat, long, set_time, so_total, so_taken, pi_total, pi_taken, cu_total, cu_taken, 
         co_total, co_taken, he_total, he_taken, ck_total, ck_taken) %>% 
  drop_na(lat) %>% #as of v1.0.2 there's a JS seine with no lat long
  filter(lat < 90) # as of v1.0.2 there's a lat that is way off

write_csv(seine_data, here::here("data_to_dwc", "hakai_salmon_data", "raw_data", "seine_data.csv"))

fish_lab_data <- read_csv(here("data_to_dwc", "hakai_salmon_data", "v1.0.2", "data", "fish_lab_data.csv"), guess_max = 20000) %>% 
  dplyr::select(ufn, weight, fork_length)


fish_field_data <- read_csv(here("data_to_dwc", "hakai_salmon_data", "v1.0.2", "data", "fish_field_data.csv"), guess_max =  20000) %>% 
  select(ufn, semsp_id, seine_id, species, fork_length_field, weight_field)

# Comnbine fish lab and fish field data
fish_data <- left_join(fish_field_data, fish_lab_data, by = 'ufn') 

write_csv(fish_data, here::here("data_to_dwc", "hakai_salmon_data", "raw_data", "fish_data.csv"))

bycatch <- read_csv(here::here("data_to_dwc", "hakai_salmon_data", "v1.0.2", "data", "bycatch_mort.csv"))
  
