# Applications

Some _significant_ applications are demonstrated in this chapter.

## Salmon Ocean Ecology Data



### Intro

One of the goals of the Hakai Institute and the Canadian Integrated Ocean Observing System (CIOOS) is to facilitate Open Science and FAIR (findable, accessible, interoperable, reusable) ecological and oceanographic data. In a concerted effort to adopt or establish how best to do that, several Hakai and CIOOS staff attended an International Ocean Observing System (IOOS) Code Sprint in Ann Arbour, Michigan between October 7--11, 2019, to discuss how to implement FAIR data principles for biological data collected in the marine environment. 

The [Darwin Core](https://dwc.tdwg.org) is a highly structured data format that standardizes data table relations, vocabularies, and defines field names. The Darwin Core defines three table types: `event`, `occurrence`, and `measurementOrFact`. This intuitively captures the way most ecologists conduct their research. Typically, a survey (event) is conducted and measurements, counts, or observations (collectively measurementOrFacts) are made regarding a specific habitat or species (occurrence). 

In the following script I demonstrate how I go about converting a subset of the data collected from the Hakai Institute Juvenile Salmon Program and discuss challenges, solutions, pros and cons, and when and what's worthwhile to convert to Darwin Core.

The conversion of a dataset to Darwin Core is much easier if your data are already tidy (normalized) in which you represent your data in separate tables that reflect the hierarchical and related nature of your observations. If your data are not already in a consistent and structured format, the conversion would likely be very arduous and not intuitive.

### event 

The first step is to consider what you will define as an event in your data set. I defined the capture of fish using a purse seine net as the `event`. Therefore, each row in the `event` table is one deployment of a seine net and is assigned a unique `eventID`. 

My process for conversion was to make a new table called `event` and map the standard Darwin Core column names to pre-existing columns that serve the same purpose in my original `seine_data` table and populate the other required fields.



```r
#TODO: Include abiotic measurements (YSI temp and salinity from 0 and 1 m) to hang off eventID in the eMoF table

event <- tibble(datasetName = "Hakai Institute Juvenile Salmon Program",
                eventID = survey_seines$seine_id,
                eventDate = date(survey_seines$survey_date),
                eventTime = paste0(survey_seines$set_time, "-0700"),
                eventRemarks = paste3(survey_seines$survey_comments, survey_seines$seine_comments),
                decimalLatitude = survey_seines$lat,
                decimalLongitude = survey_seines$long,
                locationID = survey_seines$site_id,
                coordinatePrecision = 0.00001,
                coordinateUncertaintyInMeters = 10,
                country = "Canada",
                countryCode = "CA",
                stateProvince = "British Columbia",
                habitat = "Nearshore marine",
                geodeticDatum = "EPSG:4326 WGS84",
                minimumDepthInMeters = 0,
                maximumDepthInMeters = 9, # seine depth is 9 m
                samplingProtocol = "http://dx.doi.org/10.21966/1.566666", # This is the DOI for the Hakai Salmon Data Package that contains the smnpling protocol, as well as the complete data package
                language = "en",
                license = "http://creativecommons.org/licenses/by/4.0/legalcode",
                bibliographicCitation = "Johnson, B.T., J.C.L. Gan, S.C. Godwin, M. Krkosek, B.P.V. Hunt. 2020. Hakai Juvenile Salmon Program Time Series. Hakai Institute, Quadra Island Ecological Observatory, Heriot Bay, British Columbia, Canada. v#.#.#, http://dx.doi.org/10.21966/1.566666",
                references = "https://github.com/HakaiInstitute/jsp-data",
                institutionID = "https://www.gbif.org/publisher/55897143-3f69-42f1-810d-ae94b55fde24, https://oceanexpert.org/institution/20121, https://edmo.seadatanet.org/report/5148",
                institutionCode = "Hakai"
               ) 
```


### occurrence

Next you'll want to determine what constitutes an occurrence for your data set. Because each event captures fish, I consider each fish to be an occurrence. Therefore, the unit of observation (each row) in the occurrence table is a fish. To link each occurrence to an event you need to include the `eventID` column for every occurrence so that you know what seine (event) each fish (occurrence) came from. You must also provide a globally unique identifier for each occurrence. I already have a locally unique identifier for each fish in the original `fish_data` table called `ufn`. To make it globally unique I pre-pend the organization and research program metadata to the `ufn` column. 

Not every fish is actually collected and given a Universal Fish Number (UFN) in our fish data tables, so in our field data sheets we record the total number of fish captured and the total number retained. So to get an occurrence row for every fish captured I create a row for every fish caught (minus the number taken) and create a generic numeric id (ie hakai-jsp-1) in one table and then join that to the fish table that includes a row for every fish retained that already has a UFN. 


```r
## make table long first
seines_total_long <- survey_seines %>% 
  select(seine_id, so_total, pi_total, cu_total, co_total, he_total, ck_total) %>% 
  pivot_longer(-seine_id, names_to = "scientificName", values_to = "n")

seines_total_long$scientificName <- recode(seines_total_long$scientificName, so_total = "Oncorhynchus nerka", pi_total = "Oncorhynchus gorbuscha", cu_total = "Oncorhynchus keta", co_total = "Oncorhynchus kisutch", ck_total = "Oncorhynchus tshawytscha", he_total = "Clupea pallasii") 

seines_taken_long <- survey_seines %>%
  select(seine_id, so_taken, pi_taken, cu_taken, co_taken, he_taken, ck_taken) %>% 
  pivot_longer(-seine_id, names_to = "scientificName", values_to = "n_taken") 

seines_taken_long$scientificName <- recode(seines_taken_long$scientificName, so_taken = "Oncorhynchus nerka", pi_taken = "Oncorhynchus gorbuscha", cu_taken = "Oncorhynchus keta", co_taken = "Oncorhynchus kisutch", ck_taken = "Oncorhynchus tshawytscha", he_taken = "Clupea pallasii") 

## remove records that have already been assigned an ID because they were actually retained
seines_long <-  full_join(seines_total_long, seines_taken_long, by = c("seine_id", "scientificName")) %>% 
  drop_na() %>% 
  mutate(n_not_taken = n - n_taken) %>% #so_total includes the number taken so I subtract n_taken to get n_not_taken
  select(-n_taken, -n) %>% 
  filter(n_not_taken > 0)

all_fish_not_retained <-
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
  select(seine_id, scientificName, occurrenceID)

occurrence <- bind_rows(all_fish_not_retained, fish_retained_data) %>% 
  rename(eventID = seine_id) %>%  # rename = dplyr::rename; vs plyr::rename
  mutate(`Life stage` = "juvenile")

unique_taxa <- unique(occurrence$scientificName)  
worms_names <- wm_records_names(unique_taxa) # library(worrms)
df_worms_names <- bind_rows(worms_names) %>% 
  select(scientificName = scientificname,
         scientificNameAuthorship = authority,
         taxonRank = rank,
         scientificNameID = lsid
         )

#include bycatch species

unique_bycatch <- unique(bycatch$scientificName) %>%  glimpse()

by_worms_names <- wm_records_names(unique_bycatch) %>% 
  bind_rows() %>% 
  select(scientificName = scientificname,
         scientificNameAuthorship = authority,
         taxonRank = rank,
         scientificNameID = lsid
         )

bycatch_occurrence <- bycatch %>% 
  select(eventID = seine_id, occurrenceID, scientificName, `Life stage` = bm_ageclass) %>% 
  filter(scientificName != "unknown")

bycatch_occurrence$`Life stage`[bycatch_occurrence$`Life stage` == "J"] <- "juvenile"
bycatch_occurrence$`Life stage`[bycatch_occurrence$`Life stage` == "A"] <- "adult"
bycatch_occurrence$`Life stage`[bycatch_occurrence$`Life stage` == "Y"] <- "Young of year"

combined_worms_names <- bind_rows(by_worms_names, df_worms_names) %>% 
  distinct(scientificName, .keep_all = TRUE)

occurrence <- bind_rows(bycatch_occurrence, occurrence)

occurrence <- left_join(occurrence, combined_worms_names) %>% 
    mutate(basisOfRecord = "HumanObservation",
        occurrenceStatus = "present")

write_csv(occurrence,"../datasets/hakai_salmon_data/raw_data/occurrence.csv") # here::here("..", "datasets", "hakai_salmon_data", "raw_data",   "occurrence.csv"))

# This removes events that didn't result in any occurrences
event <- dplyr::semi_join(event, occurrence, by = 'eventID') %>% 
  mutate(coordinateUncertaintyInMeters = ifelse(is.na(decimalLatitude), 1852, coordinateUncertaintyInMeters))

simple_sites <- sites %>% 
  select(site_id, ocgy_std_lat, ocgy_std_lon)

event <- dplyr::left_join(event, simple_sites, by = c("locationID" = "site_id")) %>% 
  mutate(decimalLatitude = coalesce(decimalLatitude, ocgy_std_lat),
         decimalLongitude = coalesce(decimalLongitude, ocgy_std_lon)) %>% 
  select(-c(ocgy_std_lat, ocgy_std_lon))

write_csv(event,"../datasets/hakai_salmon_data/raw_data/event.csv") # here::here("..", "datasets", "hakai_salmon_data", "raw_data",   "event.csv"))
```


### measurementOrFact
To convert all your measurements or facts from your normal format to Darwin Core you essentially need to put all your measurements into one column called measurementType and a corresponding column called MeasurementValue. This standardizes the column names are in the `measurementOrFact` table. There are a number of predefined `measurementType`s listed on the [NERC](https://www.bodc.ac.uk/resources/vocabularies/) database that should be used where possible. I found it difficult to navigate this page to find the correct `measurementType`. 

Here I convert length, and weight measurements that relate to an event and an occurrence and call those `measurementTypes` as `length` and `weight`.


```r
mof_types <- read_csv("https://raw.githubusercontent.com/HakaiInstitute/jsp-data/master/OBIS_data/mof_type_units_id.csv")

fish_data$weight <- coalesce(fish_data$weight, fish_data$weight_field)
fish_data$fork_length <- coalesce(fish_data$fork_length, fish_data$fork_length_field)
fish_data$`Life stage` <- "juvenile"



measurementOrFact <- fish_data %>%
  mutate(occurrenceID = paste0("hakai-jsp-", ufn)) %>% 
  select(occurrenceID, eventID = seine_id, "Length (fork length)" = fork_length,
         "Standard length" = standard_length, "Weight" = weight, `Life stage`) %>% 
  pivot_longer(`Length (fork length)`:`Life stage`,
               names_to = "measurementType",
               values_to = "measurementValue",
               values_transform = list(measurementValue = as.character)) %>%
  filter(measurementValue != "NA") %>%
  left_join(mof_types,by = c("measurementType")) %>% 
  mutate(measurementValueID = case_when(measurementValue == "juvenile" ~ "http://vocab.nerc.ac.uk/collection/S11/current/S1127/"),
         measurementID = paste(eventID, measurementType, occurrenceID, sep = "-"))


write_csv(measurementOrFact,"../datasets/hakai_salmon_data/raw_data/extendedMeasurementOrFact.csv") # here::here("..", "datasets", "hakai_salmon_data", "raw_data",   "extendedMeasurementOrFact.csv"))
```


```r
#Check that every eventID in Occurrence occurs in event table
no_keys <- dm(event, occurrence, measurementOrFact)
only_pk <- no_keys %>% 
  dm_add_pk(event, eventID) %>% 
  dm_add_pk(occurrence, occurrenceID) %>% 
  dm_add_pk(measurementOrFact, measurementID)
dm_examine_constraints(only_pk)

model <- only_pk %>% 
  dm_add_fk(occurrence, eventID, event) %>% 
  dm_add_fk(measurementOrFact, occurrenceID, occurrence)
dm_examine_constraints(model)

#TODO: Fix bookdown issues so that dm_draw shows data model html output. Perhaps add  `always_allow_html: true` to yaml front matter
# dm_draw(model, view_type = "all") 
```

## Hakai Seagrass

By: ZL Monteith, Hakai Institute

### Setup
This section clears the workspace, checks the working directory, and
installs packages (if required) and loads packages, and loads necessary
datasets


```r
# The following command will remove all objects** for a fresh start. Make
#   sure any objects you want to keep are saved before running!
rm(list = ls())

# Check working directory; set if necessary so document will compile
#   properly
getwd()

# Install packages; uncomment and run if packages not already installed
# install.packages(c("tidyverse", "uuid"))

# Load packages
lapply(c("tidyverse", "lubridate", "magrittr", "worrms"),
       library, character.only = TRUE)
```

#### Load Data
First load the seagrass density survey data, set variable classes, and have a quick look


```r
# Load density data
seagrassDensity <-
  read.csv("https://raw.githubusercontent.com/ioos/bio_data_guide/main/datasets/hakai_seagrass_data/raw_data/seagrass_density_survey.csv",
           colClass = "character") %>%
  mutate(date             = ymd(date),
         depth            = as.numeric(depth),
         transect_dist    = factor(transect_dist),
         collected_start  = ymd_hms(collected_start),
         collected_end    = ymd_hms(collected_end),
         density          = as.numeric(density),
         density_msq      = as.numeric(density_msq),
         canopy_height_cm = as.numeric(canopy_height_cm),
         flowering_shoots = as.numeric(flowering_shoots)) %T>%
  glimpse()
```

Next, load the habitat survey data, and same as above, set variable classes as necessary,
and have a quick look.


```r
# load habitat data, set variable classes, have a quick look
seagrassHabitat <-
  read.csv("https://raw.githubusercontent.com/ioos/bio_data_guide/main/datasets/hakai_seagrass_data/raw_data/seagrass_habitat_survey.csv",
           colClasses = "character") %>%
  mutate(date            = ymd(date),
         depth           = as.numeric(depth),
         hakai_id        = str_pad(hakai_id, 5, pad = "0"),
         transect_dist   = factor(transect_dist),
         collected_start = ymd_hms(collected_start),
         collected_end   = ymd_hms(collected_end)) %T>%
  glimpse()
```

Finally, load coordinate data for surveys, and subset necessary variables


```r
coordinates <-
  read.csv("https://raw.githubusercontent.com/ioos/bio_data_guide/main/datasets/hakai_seagrass_data/raw_data/seagrassCoordinates.csv",
           colClass = c("Point.Name" = "character")) %>%
  select(Point.Name, Decimal.Lat, Decimal.Long) %T>%
  glimpse()
```

#### Merge Datasets
Now all the datasets have been loaded, and briefly formatted, we'll join
together the habitat and density surveys, and the coordinates for these.

The seagrass density surveys collect data at discrete points (ie. 5 metres)
along the transects, while the habitat surveys collect data over sections
(ie. 0 - 5 metres) along the transects. In order to fit these two surveys
together, we'll narrow the habitat surveys from a range to a point so the
locations will match. Based on how the habitat data is collected, the point
the habitat survey is applied to will be the distance at the end of the
swath (ie. 10-15m will become 15m). To account for no preceeding distance,
the 0m distance will use the 0-5m section of the survey.

First, well make the necessary transformations to the habitat dataset.


```r
# Reformat seagrassHabitat to merge with seagrassDensity
## replicate 0 - 5m transect dist to match with 0m in density survey;
## rest of habitat bins can map one to one with density (ie. 5 - 10m -> 10m)
seagrass0tmp <-
  seagrassHabitat %>%
  filter(transect_dist %in% c("0 - 5", "0 - 2.5")) %>%
  mutate(transect_dist = factor(0))

## collapse various levels to match with seagrassDensity transect_dist
seagrassHabitat$transect_dist <-
  fct_collapse(seagrassHabitat$transect_dist,
               "5" = c("0 - 5", "2.5 - 7.5"),
               "10" = c("5 - 10", "7.5 - 12.5"),
               "15" = c("10 - 15", "12.5 - 17.5"),
               "20" = c("15 - 20", "17.5 - 22.5"),
               "25" = c("20 - 25", "22.5 - 27.5"),
               "30" = c("25 - 30", "27.5 - 30"))

## merge seagrass0tmp into seagrassHabitat to account for 0m samples,
## set class for date, datetime variables
seagrassHabitatFull <-
  rbind(seagrass0tmp, seagrassHabitat) %>%
  filter(transect_dist != "0 - 2.5")  %>% # already captured in seagrass0tmp
  droplevels(.)  # remove now unused factor levels
```

With the distances of habitat and density surveys now corresponding, we can
now merge these two datasets plus there coordinates together, combine
redundant fields, and remove unnecessary fields.


```r
# Merge seagrassHabitatFull with seagrassDensity, then coordinates
seagrass <-
  full_join(seagrassHabitatFull, seagrassDensity,
            by = c("organization",
                   "work_area",
                   "project",
                   "survey",
                   "site_id",
                   "date",
                   "transect_dist")) %>%
  # merge hakai_id.x and hakai_id.y into single variable field;
  # use combination of date, site_id, transect_dist, and field uid (hakai_id
  # when present)
  mutate(field_uid = ifelse(sample_collected == TRUE, hakai_id.x, "NA"),
         hakai_id = paste(date, "HAKAI:CALVERT", site_id, transect_dist, sep = ":"),
         # below, aggregate metadata that didn't merge naturally (ie. due to minor
         # differences in watch time or depth gauges)
         dive_supervisor = dive_supervisor.x,
         collected_start = ymd_hms(ifelse(is.na(collected_start.x),
                                          collected_start.y,
                                          collected_start.x)),
         collected_end   = ymd_hms(ifelse(is.na(collected_start.x),
                                          collected_start.y,
                                          collected_start.x)),
         depth_m         = ifelse(is.na(depth.x), depth.y, depth.x),
         sampling_bout   = sampling_bout.x) %>%
  left_join(., coordinates,  # add coordinates
            by = c("site_id" = "Point.Name")) %>%
  select( - c(X.x, X.y, hakai_id.x, hakai_id.y,  # remove unnecessary variables
              dive_supervisor.x, dive_supervisor.y,
              collected_start.x, collected_start.y,
              collected_end.x, collected_end.y,
              depth.x, depth.y,
              sampling_bout.x, sampling_bout.y)) %>%
  mutate(density_msq = as.character(density_msq),
         canopy_height_cm = as.character(canopy_height_cm),
         flowering_shoots = as.character(flowering_shoots),
         depth_m = as.character(depth_m)) %T>%
  glimpse()
```

### Convert Data to Darwin Core - Extended Measurement or Fact format
The Darwin Core ExtendedMeasurementOrFact (eMoF) extension bases records
around a core event (rather than occurrence as in standard Darwin Core),
allowing for additional measurement variables to be associated with
occurrence data.

#### Add Event ID and Occurrence ID variables to dataset
As this dataset will be annually updated, rather than using
natural keys (ie. using package::uuid to autogenerate) for event and
occurence IDs, here we will use surrogate keys made up of a concatenation
of date survey, transect location, observation distance, and sample ID
(for occurrenceID, when a sample is present).


```r
# create and populate eventID variable
## currently only event is used, but additional surveys and abiotic data
## are associated with parent events that may be included at a later date
seagrass$eventID <- seagrass$hakai_id

# create and populate occurrenceID; combine eventID with transect_dist
# and field_uid
## in the event of <NA> field_uid, no sample was collected, but
## measurements and occurrence are still taken; no further subsamples
## are associated with <NA> field_uids
seagrass$occurrenceID <-
  with(seagrass,
       paste(eventID, transect_dist, field_uid, sep = ":"))
```

#### Create Event, Occurrence, and eMoF tables
Now that we've created eventIDs and occurrenceIDs to connect all the
variables together, we can begin to create the Event, Occurrence,
and extended Measurement or Fact table necessary for DarwinCore
compliant datasets

##### Event Table


```r
# subset seagrass to create event table
seagrassEvent <-
  seagrass %>%
  distinct %>%  # some duplicates in data stemming from database conflicts
  select(date,
         Decimal.Lat, Decimal.Long, transect_dist,
         depth_m, eventID) %>%
  rename(eventDate                     = date,
         decimalLatitude               = Decimal.Lat,
         decimalLongitude              = Decimal.Long,
         coordinateUncertaintyInMeters = transect_dist,
         minimumDepthInMeters          = depth_m,
         maximumDepthInMeters          = depth_m) %>%
  mutate(geodeticDatum  = "WGS84",
         samplingEffort = "30 metre transect") %T>% glimpse

# save event table to csv
write.csv(seagrassEvent, "../datasets/hakai_seagrass_data/processed_data/hakaiSeagrassDwcEvent.csv")
```

##### Occurrence Table


```r
# subset seagrass to create occurrence table
seagrassOccurrence <-
  seagrass %>%
  distinct %>%  # some duplicates in data stemming from database conflicts
  select(eventID, occurrenceID) %>%
  mutate(basisOfRecord = "HumanObservation",
         scientificName   = "Zostera subg. Zostera marina",
         occurrenceStatus = "present")

# Taxonomic name matching
# in addition to the above metadata, DarwinCore format requires further
# taxonomic data that can be acquired through the WoRMS register.
## Load taxonomic info, downloaded via WoRMS tool
# zmWorms <-
#   read.delim("raw_data/zmworms_matched.txt",
#              header = TRUE,
#              nrows  = 1)

zmWorms <- wm_record(id = 145795)

# join WoRMS name with seagrassOccurrence create above
seagrassOccurrence <-
  full_join(seagrassOccurrence, zmWorms,
            by = c("scientificName" = "scientificname")) %>%
  select(eventID, occurrenceID, basisOfRecord, scientificName, occurrenceStatus, AphiaID,
         url, authority, status, unacceptreason, taxonRankID, rank,
         valid_AphiaID, valid_name, valid_authority, parentNameUsageID,
         kingdom, phylum, class, order, family, genus, citation, lsid,
         isMarine, match_type, modified) %T>%
  glimpse

# save occurrence table to csv
write.csv(seagrassOccurrence, "../datasets/hakai_seagrass_data/processed_data/hakaiSeagrassDwcOccurrence.csv")
```

##### Extended MeasurementOrFact table


```r
seagrassMof <-
  seagrass %>%
  # select variables for eMoF table
  select(date,
         eventID, survey, site_id, transect_dist,
         substrate, patchiness, adj_habitat_1, adj_habitat_2,
         vegetation_1, vegetation_2,
         density_msq, canopy_height_cm, flowering_shoots) %>%
  # split substrate into two variables (currently holds two substrate type in same variable)
  separate(substrate, sep = ",", into = c("substrate_1", "substrate_2")) %>%
  # change variables names to match NERC database (or to be more descriptive where none exist)
  rename(measurementDeterminedDate   = date,
         SubstrateTypeA              = substrate_1,
         SubstrateTypeB              = substrate_2,
         BarePatchLengthWithinSeagrass = patchiness,
         PrimaryAdjacentHabitat      = adj_habitat_1,
         SecondaryAdjacentHabitat    = adj_habitat_2,
         PrimaryAlgaeSp              = vegetation_1,
         SecondaryAlgaeSp            = vegetation_2,
         BedAbund                    = density_msq,
         CanopyHeight                = canopy_height_cm,
         FloweringBedAbund           = flowering_shoots) %>%
  # reformat variables into DwC MeasurementOrFact format
  # (single values variable, with measurement type, unit, etc. variables)
  pivot_longer( - c(measurementDeterminedDate, eventID, survey, site_id, transect_dist),
                names_to = "measurementType",
                values_to = "measurementValue",
                values_ptypes = list(measurementValue = "character")) %>%
  # use measurement type to fill in remainder of variables relating to
  # NERC vocabulary and metadata fields
  mutate(
    measurementTypeID = case_when(
      measurementType == "BedAbund" ~ "http://vocab.nerc.ac.uk/collection/P01/current/SDBIOL02/",
      measurementType == "CanopyHeight" ~ "http://vocab.nerc.ac.uk/collection/P01/current/OBSMAXLX/",
      # measurementType == "BarePatchWithinSeagrass" ~ "",
      measurementType == "FloweringBedAbund" ~ "http://vocab.nerc.ac.uk/collection/P01/current/SDBIOL02/"),
    measurementUnit = case_when(
      measurementType == "BedAbund" ~ "Number per square metre",
      measurementType == "CanopyHeight" ~ "Centimetres",
      measurementType == "BarePatchhLengthWithinSeagrass" ~ "Metres",
      measurementType == "FloweringBedAbund" ~ "Number per square metre"),
    measurementUnitID = case_when(
      measurementType == "BedAbund" ~ "http://vocab.nerc.ac.uk/collection/P06/current/UPMS/",
      measurementType == "CanopyHeight" ~ "http://vocab.nerc.ac.uk/collection/P06/current/ULCM/",
      measurementType == "BarePatchhLengthWithinSeagrass" ~ "http://vocab.nerc.ac.uk/collection/P06/current/ULAA/2/",
      measurementType == "FloweringBedAbund" ~ "http://vocab.nerc.ac.uk/collection/P06/current/UPMS/"),
    measurementAccuracy = case_when(
      measurementType == "CanopyHeight" ~ 5),
    measurementMethod = case_when(
      measurementType == "BedAbund" ~ "25cmx25cm quadrat count",
      measurementType == "CanopyHeight" ~ "in situ with ruler",
      measurementType == "BarePatchhLengthWithinSeagrass" ~ "estimated along transect line",
      measurementType == "FloweringBedAbund" ~ "25cmx25cm quadrat count")) %>%
  select(eventID, measurementDeterminedDate, measurementType, measurementValue,
         measurementTypeID, measurementUnit, measurementUnitID, measurementAccuracy,
         measurementMethod) %T>%
#  select(!c(survey, site_id, transect_dist)) %T>%
  glimpse()

# save eMoF table to csv
write.csv(seagrassMof, "../datasets/hakai_seagrass_data/processed_data/hakaiSeagrassDwcEmof.csv")
```

### Session Info
Print session information below in case necessary for future reference


```r
# Print Session Info for future reference
sessionInfo()
```
