## Aligning Data to Darwin Core - Sampling Event with Extended Measurement or Fact

Abby Benson  
January 9, 2022 

### General information about this notebook
Script to process the Texas Parks and Wildlife Department (TPWD) Aransas Bay bag seine data from
the format used by the Houston Advanced Research Center (HARC) for bays in Texas. Taxonomy was processed using a separate script (TPWD_Taxonomy.R) using a taxa list pulled from the pdf "2009 Resource Monitoring Operations Manual". All original data, processed data and scripts are stored on [an item](https://www.sciencebase.gov/catalog/item/53a887f4e4b075096c60cfdd) in USGS ScienceBase. 


```r
# Load some of the libraries
library(reshape2)
library(tidyverse)
library(readr)
```

```r
# Load the data
BagSeine <- read.csv("https://www.sciencebase.gov/catalog/file/get/53a887f4e4b075096c60cfdd?f=__disk__6e%2F6a%2F67%2F6e6a678c41cf928e025fd30339789cc8b893a815&allowOpen=true", stringsAsFactors=FALSE, strip.white = TRUE)
```

Note that if not already done you'll need to run the TPWD_Taxonomy.R script to get the taxaList file squared away or load the taxonomy file to the World Register of Marine Species Taxon Match Tool https://www.marinespecies.org/aphia.php?p=match

To start we will create the Darwin Core Event file. This is the file that will have all the information about the sampling event such as date, location, depth, sampling protocol. Basically anything about the cruise or the way the sampling was done will go in this file. You can see all the Darwin Core terms that are part of the event file here http://tools.gbif.org/dwca-validator/extension.do?id=dwc:Event.

The original format for these TPWD HARC files has all of the information associated as the event in the first approximately 50 columns and then all of the information about the occurrence (species) as columns for each species. We will need to start by limiting to the event information only.
```r
event <- BagSeine[,1:47]
```
Next there are several pieces of information that need 
1) to be added like the geodeticDatum
2) to be pieced together from multiple columns like datasetID or
3) minor changes like the minimum and maximum depth.

```r
event <- event %>%
  mutate(type = "Event",
         modified = lubridate::today(),
         language = "en",
         license = "http://creativecommons.org/publicdomain/zero/1.0/legalcode",
         institutionCode = "TPWD",
         ownerInstitutionCode = "HARC",
         coordinateUncertaintyInMeters = "100",
         geodeticDatum = "WGS84",
         georeferenceProtocol = "Handheld GPS",
         country = "United States",
         countryCode = "US",
         stateProvince = "Texas",
         datasetID = gsub(" ", "_", paste("TPWD_HARC_Texas", event$Bay, event$Gear_Type)),
         eventID = paste("Station", event$station_code, "Date", event$completion_dttm, sep = "_"),
         sampleSizeUnit = "hectares",
         CompDate = lubridate::mdy_hms(event$CompDate, tz="America/Chicago"), 
         StartDate = lubridate::mdy_hms(event$StartDate, tz="America/Chicago"),
         minimumDepthInMeters = ifelse(start_shallow_water_depth_num < start_deep_water_depth_num, 
                                       start_shallow_water_depth_num, start_deep_water_depth_num),
         maximumDepthInMeters = ifelse(start_deep_water_depth_num > start_shallow_water_depth_num,
                                       start_deep_water_depth_num, start_shallow_water_depth_num))
```
```r
head(event[,48:64], n = 10)

```
For this dataset there was a start timestamp and end timestamp that we can use to identify the sampling effort which can be really valuable information for downstream users when trying to reuse data from multiple projects.

```r
## Calculate duration of bag seine event
event$samplingEffort <- ""
for (i in 1:nrow(event)){
  event[i,]$samplingEffort <- abs(lubridate::as.duration(event[i,]$CompDate - event[i,]$StartDate))
}
event$samplingEffort <- paste(event$samplingEffort, "seconds", sep = " ")
```
Finally there were a few columns that were a direct match to a Darwin Core term and therefore just need to be renamed to follow the standard.

```r
event <- event %>%
  rename(samplingProtocol = Gear_Type,
         locality = Estuary,
         waterBody = SubBay,
         decimalLatitude = Latitude,
         decimalLongitude = Longitude,
         sampleSizeValue = surface_area_num,
         eventDate = CompDate)
```
The next file we need to create is the Occurrence file. This file includes all the information about the species that were observed. An occurrence in Darwin Core is the intersection of an organism at a time and a place. We have already done the work to identify the time and place in the event file so we don't need to do that again here. What we do need to is identify all the information about the organisms. Another piece of information that goes in here is basisOfRecord which is a required field and has a controlled vocabulary. For the data we work with you'll usually put "HumanObservation" or "MachineObservation". If it's eDNA data you'll use "MaterialSample". If your data are part of a museum collection you'll use "PreservedSpecimen". 

Important to note that there is overlap in the Darwin Core terms that "allowed" to be in the event file and in the occurrence file. This is because data can be submitted as "Occurrence Only" where you don't have a separate event file. In that case, the location and date information will need to be included in the occurrence file. Since we are formatting this dataset as a sampling event we will not include location and date information in the occurrence file. To see all the Darwin Core terms that can go in the occurrence file go here https://tools.gbif.org/dwca-validator/extension.do?id=dwc:occurrence.

This dataset in its original format is in "wide format". All that means is that data that we would expect to be encoded as values in the rows are instead column headers. We have to pull all the scientific names out of the column headers and turn them into actual values in the data.
```r
occurrence <- melt(BagSeine, id=1:47, measure=48:109, variable.name="vernacularName", value.name="relativeAbundance")
```
You'll notice when we did that step we went from 5481 obs (or rows) in the data to 339822 obs. We went from wide to long.
```r
dim(BagSeine)
dim(occurrence)
```

Now as with the event file we have several pieces of information that need to be added or changed to make sure the data are following Darwin Core. We always want to include as much information as possible to make the data as reusable as possible.
```r
occurrence <- occurrence %>%
  mutate(vernacularName = gsub("\\.",' ', vernacularName),
         eventID = paste("Station", station_code, "Date", completion_dttm, sep = "_"),
         occurrenceStatus = ifelse(relativeAbundance == 0, "Absent", "Present"),
         basisOfRecord = "HumanObservation",
         organismQuantityType = "Relative Abundance",
         collectionCode = paste(Bay, Gear_Type, sep = " "))
```

We will match the taxa list with our occurrence file data to bring in the taxonomic information that we pulled from WoRMS. To save time you'll just import the processed taxa list which includes the taxonomic hierarchy and the required term scientificNameID which is one of the most important pieces of information to include for OBIS.
```r
taxaList <- read.csv("https://www.sciencebase.gov/catalog/file/get/53a887f4e4b075096c60cfdd?f=__disk__49%2F0a%2F73%2F490a7337fa94039715809496b22f5d003b8a79a2&allowOpen=true", stringsAsFactors = FALSE)
## Merge taxaList with occurrence
occurrence <- merge(occurrence, taxaList, by = "vernacularName", all.x = T)
## Test that all the vernacularNames found a match in taxaList_updated
Hmisc::describe(occurrence$scientificNameID)
```
For that last line of code we are expecting to see no missing values for scientificNameID. Every row in the file should have a value in scientificNameID which should be a WoRMS LSID that look like this "urn:lsid:marinespecies.org:taxname:144531"

We need to create a unique ID for each row in the occurrence file. This is known as the occurrenceID and is a required term. The occurrenceID needs to be globally unique and needs to be permanent and kept in place if any updates to the dataset are made. You should not create brand new occurrenceIDs when you update a dataset. To facilitate this I like to build the occurrenceID from pieces of information available in the dataset to create a unique ID for each row in the occurrence file. For this dataset I used the eventID (Station + Date) plus the scientific name. This only works if there is only one scientific name per station per date so if you have different ages or sexes of species at the same station and date this method of creating the occurrenceID won't work for you.
```r
occurrence$occurrenceID <- paste(occurrence$eventID, gsub(" ", "_",occurrence$scientificName), sep = "_")
```
For the occurrence file we only have one column to rename. We could have avoided this step if we had named it organismQuantity up above but I kept this to remind me what the data providers had called this.
```r
occurrence <- occurrence %>%
  rename(organismQuantity = relativeAbundance)
```

The final file we are going to create is the extended measurement or fact extension. This is a bit like a catch all for any measurements or facts that are not captured in Darwin Core. Darwin Core does not have terms for things like temperature, salinity, gear type, cruise  number, length, weight, etc. We are going to create a long format file where each of these is a set of rows in the extended measurement or fact file. You can find all the terms in this extension here https://tools.gbif.org/dwca-validator/extension.do?id=http://rs.iobis.org/obis/terms/ExtendedMeasurementOrFact. 

OBIS uses the BODC NERC Vocabulary Server to provide explicit definitions for each of the measurements https://vocab.nerc.ac.uk/search_nvs/.

For this dataset I was only able to find code definitions provided by the data providers for some of the measurements. I included the ones that I was able to find code definitions and left out any that I couldn't find those for. The ones I was able to find code definitions for were Total.Of.Samples_Count, gear_size, start_wind_speed_num, start_barometric_pressure_num, start_temperature_num, start_salinity_num, start_dissolved_oxygen_num. All the others I left out.


```r
totalOfSamples <- event[c("Total.Of.Samples_Count", "eventID")]
totalOfSamples <- totalOfSamples[which(!is.na(totalOfSamples$Total.Of.Samples_Count)),]
totalOfSamples <- totalOfSamples %>% 
  mutate(measurementType = "Total number of samples used to calculate relative abundance",
         measurementUnit = "",
         measurementTypeID = "",
         measurementUnitID = "",
         occurrenceID = "") %>%
  rename(measurementValue = Total.Of.Samples_Count)

gear_size <- event[c("gear_size", "eventID")]
gear_size <- gear_size[which(!is.na(gear_size$gear_size)),]
gear_size <- gear_size %>% 
  mutate(measurementType = "gear size",
         measurementUnit = "meters",
         measurementTypeID = "http://vocab.nerc.ac.uk/collection/P01/current/MTHAREA1/",
         measurementUnitID = "http://vocab.nerc.ac.uk/collection/P06/current/ULAA/",
         occurrenceID = "") %>%
  rename(measurementValue = gear_size)

start_wind_speed_num <- event[c("start_wind_speed_num", "eventID")]
start_wind_speed_num <- start_wind_speed_num[which(!is.na(start_wind_speed_num$start_wind_speed_num)),]
start_wind_speed_num <- start_wind_speed_num %>% 
  mutate(measurementType = "wind speed",
         measurementUnit = "not provided",
         measurementTypeID = "http://vocab.nerc.ac.uk/collection/P01/current/EWSBZZ01/",
         measurementUnitID = "",
         occurrenceID = "") %>%
  rename(measurementValue = start_wind_speed_num)

start_barometric_pressure_num <- event[c("start_barometric_pressure_num", "eventID")]
start_barometric_pressure_num <- start_barometric_pressure_num[which(!is.na(start_barometric_pressure_num$start_barometric_pressure_num)),]
start_barometric_pressure_num <- start_barometric_pressure_num %>% 
  mutate(measurementType = "barometric pressure",
         measurementUnit = "not provided",
         measurementTypeID = "http://vocab.nerc.ac.uk/collection/P07/current/CFSN0015/",
         measurementUnitID = "",
         occurrenceID = "") %>%
  rename(measurementValue = start_barometric_pressure_num)

start_temperature_num <- event[c("start_temperature_num", "eventID")]
start_temperature_num <- start_temperature_num[which(!is.na(start_temperature_num$start_temperature_num)),]
start_temperature_num <- start_temperature_num %>% 
  mutate(measurementType = "water temperature",
         measurementUnit = "Celsius",
         measurementTypeID = "http://vocab.nerc.ac.uk/collection/P01/current/TEMPPR01/",
         measurementUnitID = "http://vocab.nerc.ac.uk/collection/P06/current/UPAA/",
         occurrenceID = "") %>%
  rename(measurementValue = start_temperature_num)

start_salinity_num <- event[c("start_salinity_num", "eventID")]
start_salinity_num <- start_salinity_num[which(!is.na(start_salinity_num$start_salinity_num)),]
start_salinity_num <- start_salinity_num %>% 
  mutate(measurementType = "salinity",
         measurementUnit = "ppt",
         measurementTypeID = "http://vocab.nerc.ac.uk/collection/P01/current/ODSDM021/",
         measurementUnitID = "http://vocab.nerc.ac.uk/collection/P06/current/UPPT/",
         occurrenceID = "") %>%
  rename(measurementValue = start_salinity_num)

start_dissolved_oxygen_num <- event[c("start_dissolved_oxygen_num", "eventID")]
start_dissolved_oxygen_num <- start_dissolved_oxygen_num[which(!is.na(start_dissolved_oxygen_num$start_dissolved_oxygen_num)),]
start_dissolved_oxygen_num <- start_dissolved_oxygen_num %>% 
  mutate(measurementType = "dissolved oxygen",
         measurementUnit = "ppm",
         measurementTypeID = "http://vocab.nerc.ac.uk/collection/P09/current/DOX2/",
         measurementUnitID = "http://vocab.nerc.ac.uk/collection/P06/current/UPPM/",
         occurrenceID = "") %>%
  rename(measurementValue = start_dissolved_oxygen_num)

alternate_station_code <- event[c("alternate_station_code", "eventID")]
alternate_station_code <- alternate_station_code[which(!is.na(alternate_station_code$alternate_station_code)),]
alternate_station_code <- alternate_station_code %>% 
  mutate(measurementType = "alternate station code",
         measurementUnit = "",
         measurementTypeID = "",
         measurementUnitID = "",
         occurrenceID = "") %>%
  rename(measurementValue = alternate_station_code)

organismQuantity <- occurrence[c("organismQuantity", "eventID", "occurrenceID")]
organismQuantity <- organismQuantity[which(!is.na(organismQuantity$organismQuantity)),]
organismQuantity <- organismQuantity %>% 
  mutate(measurementType = "relative abundance",
         measurementUnit = "",
         measurementTypeID = "http://vocab.nerc.ac.uk/collection/S06/current/S0600020/",
         measurementUnitID = "") %>%
  rename(measurementValue = organismQuantity)

# Bind the separate measurements together into one file  
mof <- rbind(totalOfSamples, start_barometric_pressure_num, start_dissolved_oxygen_num, 
             start_salinity_num, start_temperature_num, start_wind_speed_num, gear_size,
             alternate_station_code, organismQuantity)
head(mof)
tail(mof)

# Write out the file
write.csv(mof, file = (paste0(event[1,]$datasetID, "_mof_", lubridate::today(),".csv")), fileEncoding = "UTF-8", row.names = F, na = "")
```

Now that we have all of our files created we can clean up the event and occurrence files to remove the columns that are not following Darwin Core. We had to leave the extra bits in before because we needed them to create the mof file above.


```r
event <- event[c("samplingProtocol","locality","waterBody","decimalLatitude","decimalLongitude",
                 "eventDate","sampleSizeValue","minimumDepthInMeters",
                 "maximumDepthInMeters","type","modified","language","license","institutionCode",
                 "ownerInstitutionCode","coordinateUncertaintyInMeters",
                 "geodeticDatum", "georeferenceProtocol","country","countryCode","stateProvince",
                 "datasetID","eventID","sampleSizeUnit","samplingEffort")]
head(event)

write.csv(event, file = paste0(event[1,]$datasetID, "_event_", lubridate::today(),".csv"), fileEncoding = "UTF-8", row.names = F, na = "")                    

occurrence <- occurrence[c("vernacularName","eventID","occurrenceStatus","basisOfRecord",
                           "scientificName","scientificNameID","kingdom","phylum","class",
                           "order","family","genus",
                           "scientificNameAuthorship","taxonRank", "organismQuantity",
                           "organismQuantityType", "occurrenceID","collectionCode")]
head(occurrence)
                           
write.csv(occurrence, file = paste0(event[1,]$datasetID, "_occurrence_",lubridate::today(),".csv"), fileEncoding = "UTF-8", row.names = F, na = "")
```