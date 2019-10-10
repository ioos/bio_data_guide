library(dplyr)
library(purrr)
library(uuid)

d <- tibble(lttr = letters)
d <- d %>% 
  mutate(
    occurrenceID = map_chr(lttr, function(x) UUIDgenerate(use.time = T)))

sum(duplicated(d$occurrenceID))
