# Applications

Some _significant_ applications are demonstrated in this chapter.

## Salmon Ocean Ecology Data



One of the goals of the Hakai Institute and the Canadian Integrated Ocean Observing System (CIOOS) is to facilitate Open Science and FAIR (findable, accessible, interoperable, reusable) ecological and oceanographic data. In a concerted effort to adopt or establish how best to do that, several Hakai and CIOOS staff attended an International Ocean Observing System (IOOS) Code Sprint in Ann Arbour, Michigan between October 7--11, 2019, to discuss how to implement FAIR data principles for biological data collected in the marine environment. 

The [Darwin Core](https://dwc.tdwg.org) is a highly structured data format that standardizes data table relations, vocabularies, and defines field names. The Darwin Core defines three table types: `event`, `occurrence`, and `measurementOrFact`. This intuitively captures the way most ecologists conduct their research. Typically, a survey (event) is conducted and measurements, counts, or observations (collectively measurementOrFacts) are made regarding a specific habitat or species (occurrence). 

In the following script I demonstrate how I go about converting a subset of the data collected from the Hakai Institute Juvenile Salmon Program and discuss challenges, solutions, pros and cons, and when and what's worthwhile to convert to Darwin Core.

The conversion of a dataset to Darwin Core is much easier if your data are already tidy (normalized) in which you represent your data in separate tables that reflect the hierarchical and related nature of your observations. If your data are not already in a consistent and structured format, the conversion would likely be very arduous and not intuitive.

### event 

The first step is to consider what you will define as an event in your data set. I defined the capture of fish using a purse seine net as the `event`. Therefore, each row in the `event` table is one deployment of a seine net and is assigned a unique `eventID`. 

My process for conversion was to make a new table called `event` and map the standard Darwin Core column names to pre-existing columns that serve the same purpose in my original `seine_data` table and populate the other required fields.



```r
event <- tibble(eventID = survey_seines$seine_id,
                eventDate = date(survey_seines$survey_date),
                decimalLatitude = survey_seines$lat,
                decimalLongitude = survey_seines$long,
                geodeticDatum = "EPSG:4326 WGS84",
                minimumDepthInMeters = 0,
                maximumDepthInMeters = 9, # seine depth is 9 m
                samplingProtocol = "http://dx.doi.org/10.21966/1.566666" # This is the DOI for the Hakai Salmon Data Package that contains the smnpling protocol, as well as the complete data package
               ) 

write_csv(event, here::here("datasets", "hakai_salmon_data", "event.csv"))
```


### occurrence

Next you'll want to determine what constitutes an occurrence for your data set. Because each event captures fish, I consider each fish to be an occurrence. Therefore, the unit of observation (each row) in the occurrence table is a fish. To link each occurrence to an event you need to include the `eventID` column for every occurrence so that you know what seine (event) each fish (occurrence) came from. You must also provide a globally unique identifier for each occurrence. I already have a locally unique identifier for each fish in the original `fish_data` table called `ufn`. To make it globally unique I pre-pend the organization and research program metadata to the `ufn` column. 



```r
#TODO: Include bycatch data as well

## make table long first
seines_total_long <- survey_seines %>% 
  select(seine_id, so_total, pi_total, cu_total, co_total, he_total, ck_total) %>% 
  pivot_longer(-seine_id, names_to = "scientificName", values_to = "n")

seines_total_long$scientificName <- recode(seines_total_long$scientificName, so_total = "Oncorhynchus nerka", pi_total = "Oncorhynchus gorbushca", cu_total = "Oncorhynchus keta", co_total = "Oncorhynchus kisutch", ck_total = "Oncorhynchus tshawytscha", he_total = "Clupea pallasii") 

seines_taken_long <- survey_seines %>%
  select(seine_id, so_taken, pi_taken, cu_taken, co_taken, he_taken, ck_taken) %>% 
  pivot_longer(-seine_id, names_to = "scientificName", values_to = "n_taken") 

seines_taken_long$scientificName <- recode(seines_taken_long$scientificName, so_taken = "Oncorhynchus nerka", pi_taken = "Oncorhynchus gorbushca", cu_taken = "Oncorhynchus keta", co_taken = "Oncorhynchus kisutch", ck_taken = "Oncorhynchus tshawytscha", he_taken = "Clupea pallasii") 

## remove records that have already been assigned an ID  
seines_long <-  full_join(seines_total_long, seines_taken_long, by = c("seine_id", "scientificName")) %>% 
  drop_na() %>% 
  mutate(n_not_taken = n - n_taken) %>% #so_total includes the number taken so I subtract n_taken to get n_not_taken
  select(-n_taken, -n) %>% 
  filter(n_not_taken > 0)

all_fish_caught <-
  seines_long[rep(seq.int(1, nrow(seines_long)), seines_long$n_not_taken), 1:3] %>% 
  select(-n_not_taken) %>% 
  mutate(prefix = "hakai-jsp-",
         suffix = 1:nrow(.),
         occurrenceID = paste0(prefix, suffix)
  ) %>% 
  select(-prefix, -suffix)

#

# Change species names to full Scientific names 
latin <- fct_recode(fish_data$species, "Oncorhynchus nerka" = "SO", "Oncorhynchus gorbuscha" = "PI", "Oncorhynchus keta" = "CU", "Oncorhynchus kisutch" = "CO", "Clupea pallasii" = "HE", "Oncorhynchus tshawytscha" = "CK") %>% 
  as.character()

fish_retained_data <- fish_data %>% 
  mutate(scientificName = latin) %>% 
  select(-species) %>% 
  mutate(prefix = "hakai-jsp-",
         occurrenceID = paste0(prefix, ufn)) %>% 
  select(-semsp_id, -prefix, -ufn, -fork_length_field, -fork_length, -weight, -weight_field)

occurrence <- bind_rows(all_fish_caught, fish_retained_data) %>% 
  mutate(basisOfRecord = "HumanObservation",
        occurenceStatus = "present") %>% 
  rename(eventID = seine_id)
```

For each occurrence of the six different fish species that I caught I need to match the species name that I provide with the official `scientificName` that is part of the World Register of Marine Species database http://www.marinespecies.org/


```r
# I went directly to the WoRMS webite (http://www.marinespecies.org/) to download the full taxonomic levels for the salmon species I have and put the WoRMS output (species_matched.xls) table in this project directory which is read in below and joined with the occurrence table

species_matched <- readxl::read_excel(here::here("datasets", "hakai_salmon_data", "raw_data", "species_matched.xls"))

occurrence <- left_join(occurrence, species_matched, by = c("scientificName" = "ScientificName")) %>% 
  select(occurrenceID, basisOfRecord, scientificName, eventID, occurrenceStatus = occurenceStatus, Kingdom, Phylum, Class, Order, Family, Genus, Species)

#write_csv(occurrence, here::here("datasets", "hakai_salmon_data", "occurrence.csv"))
```


### measurementOrFact
To convert all your measurements or facts from your normal format to Darwin Core you essentially need to put all your measurements into one column called measurementType and a corresponding column called measurementValue. This standardizes the column names are in the `measurementOrFact` table. There are a number of predefined `measurementType`s listed on the [NERC](https://www.bodc.ac.uk/resources/vocabularies/) database that should be used where possible. I found it difficult to navigate this page to find the correct `measurementType`. 

Here I convert length, and weight measurements that relate to an event and an occurrence and call those `measurementTypes` as `length` and `weight`.


```r
fish_data$weight <- coalesce(fish_data$weight, fish_data$weight_field)
fish_data$fork_length <- coalesce(fish_data$fork_length, fish_data$fork_length_field)

fish_length <- fish_data %>%
  mutate(occurrenceID = paste0("hakai-jsp-", ufn)) %>% 
  select(occurrenceID, eventID = seine_id, fork_length, weight) %>% 
  mutate(measurementType = "fork length", measurementValue = fork_length) %>% 
  select(eventID, occurrenceID, measurementType, measurementValue) %>% 
  mutate(measurementUnit = "millimetres",
         measurementUnitID = "http://vocab.nerc.ac.uk/collection/P06/current/UXMM/")

fish_weight <- fish_data %>% 
  mutate(occurrenceID = paste0("hakai-jsp-", ufn)) %>% 
  select(occurrenceID, eventID = seine_id, fork_length, weight) %>% 
  mutate(measurementType = "mass", measurementValue = weight) %>% 
  select(eventID, occurrenceID, measurementType, measurementValue) %>% 
  mutate(measurementUnit = "grams",
         measurementUnitID = "http://vocab.nerc.ac.uk/collection/P06/current/UGRM/")

measurementOrFact <- bind_rows(fish_length, fish_weight) %>% 
  drop_na(measurementValue)

rm(fish_length, fish_weight)

#write_csv(measurementOrFact, here::here("datasets", "hakai_salmon_data", "measurementOrFact.csv"))
```

## Example two
