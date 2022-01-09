## Aligning Data to Darwin Core - Event Core with Extended Measurement or Fact

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
    type   modified language                                                    license institutionCode
1  Event 2022-01-09       en http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD
2  Event 2022-01-09       en http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD
3  Event 2022-01-09       en http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD
4  Event 2022-01-09       en http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD
5  Event 2022-01-09       en http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD
6  Event 2022-01-09       en http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD
7  Event 2022-01-09       en http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD
8  Event 2022-01-09       en http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD
9  Event 2022-01-09       en http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD
10 Event 2022-01-09       en http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD
   ownerInstitutionCode coordinateUncertaintyInMeters geodeticDatum georeferenceProtocol       country
1                  HARC                           100         WGS84         Handheld GPS United States
2                  HARC                           100         WGS84         Handheld GPS United States
3                  HARC                           100         WGS84         Handheld GPS United States
4                  HARC                           100         WGS84         Handheld GPS United States
5                  HARC                           100         WGS84         Handheld GPS United States
6                  HARC                           100         WGS84         Handheld GPS United States
7                  HARC                           100         WGS84         Handheld GPS United States
8                  HARC                           100         WGS84         Handheld GPS United States
9                  HARC                           100         WGS84         Handheld GPS United States
10                 HARC                           100         WGS84         Handheld GPS United States
   countryCode stateProvince                             datasetID                                eventID
1           US         Texas TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_95_Date_09JAN1997:14:35:00.000
2           US         Texas TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_95_Date_18AUG2000:11:02:00.000
3           US         Texas TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_96_Date_28JUN2005:08:41:00.000
4           US         Texas TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_96_Date_23AUG2006:11:47:00.000
5           US         Texas TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_96_Date_17OCT2006:14:23:00.000
6           US         Texas TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_96_Date_19FEB1996:10:27:00.000
7           US         Texas TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_96_Date_11JUN2001:14:12:00.000
8           US         Texas TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_96_Date_16MAR1992:09:46:00.000
9           US         Texas TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_96_Date_25SEP1996:11:28:00.000
10          US         Texas TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_96_Date_08MAY1997:13:20:00.000
   sampleSizeUnit minimumDepthInMeters maximumDepthInMeters
1        hectares                  0.0                  0.6
2        hectares                  0.1                  0.5
3        hectares                  0.4                  0.6
4        hectares                  0.2                  0.4
5        hectares                  0.7                  0.8
6        hectares                  0.1                  0.3
7        hectares                  0.4                  0.5
8        hectares                  0.0                  0.4
9        hectares                  0.3                  0.7
10       hectares                  0.4                  0.6
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
You'll notice when we did that step we went from 5481 obs (or rows) in the data to 334341 obs. We went from wide to long.
```r
dim(BagSeine)
[1] 5481  109
dim(occurrence)
[1] 334341     49
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
       n  missing distinct 
  334341        0       61 

lowest : urn:lsid:marinespecies.org:taxname:105792 urn:lsid:marinespecies.org:taxname:107034 urn:lsid:marinespecies.org:taxname:107379 urn:lsid:marinespecies.org:taxname:126983 urn:lsid:marinespecies.org:taxname:127089
highest: urn:lsid:marinespecies.org:taxname:367528 urn:lsid:marinespecies.org:taxname:396707 urn:lsid:marinespecies.org:taxname:421784 urn:lsid:marinespecies.org:taxname:422069 urn:lsid:marinespecies.org:taxname:443955
```
For that last line of code we are expecting to see no missing values for scientificNameID. Every row in the file should have a value in scientificNameID which should be a WoRMS LSID that look like this "urn:lsid:marinespecies.org:taxname:144531"

We need to create a unique ID for each row in the occurrence file. This is known as the occurrenceID and is a required term. The occurrenceID needs to be globally unique and needs to be permanent and kept in place if any updates to the dataset are made. You should not create brand new occurrenceIDs when you update a dataset. To facilitate this I like to build the occurrenceID from pieces of information available in the dataset to create a unique ID for each row in the occurrence file. For this dataset I used the eventID (Station + Date) plus the scientific name. This only works if there is only one scientific name per station per date so if you have different ages or sexes of species at the same station and date this method of creating the occurrenceID won't work for you.
```r
occurrence$occurrenceID <- paste(occurrence$eventID, gsub(" ", "_",occurrence$scientificName), sep = "_")
occurrence[1,]$occurrenceID
[1] "Station_95_Date_09JAN1997:14:35:00.000_Atractosteus_spatula"
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
 measurementValue                                eventID
1               18 Station_95_Date_09JAN1997:14:35:00.000
2              103 Station_95_Date_18AUG2000:11:02:00.000
3              401 Station_96_Date_28JUN2005:08:41:00.000
4               35 Station_96_Date_23AUG2006:11:47:00.000
5               57 Station_96_Date_17OCT2006:14:23:00.000
6                5 Station_96_Date_19FEB1996:10:27:00.000
                                               measurementType measurementUnit measurementTypeID
1 Total number of samples used to calculate relative abundance                                  
2 Total number of samples used to calculate relative abundance                                  
3 Total number of samples used to calculate relative abundance                                  
4 Total number of samples used to calculate relative abundance                                  
5 Total number of samples used to calculate relative abundance                                  
6 Total number of samples used to calculate relative abundance                                  
  measurementUnitID occurrenceID
1                               
2                               
3                               
4                               
5                               
6                               
tail(mof)
       measurementValue                                 eventID    measurementType measurementUnit
334336        0.0000000 Station_217_Date_03APR2003:13:28:00.000 relative abundance                
334337        0.0000000 Station_217_Date_24FEB2006:10:12:00.000 relative abundance                
334338        0.1428571 Station_217_Date_23JUN2001:12:28:00.000 relative abundance                
334339        0.0000000 Station_212_Date_23MAY1990:10:43:00.000 relative abundance                
334340        0.1224490 Station_212_Date_24JUL1990:09:34:00.000 relative abundance                
334341        0.0000000 Station_212_Date_21MAR2001:11:52:00.000 relative abundance                
                                              measurementTypeID measurementUnitID
334336 http://vocab.nerc.ac.uk/collection/S06/current/S0600020/                  
334337 http://vocab.nerc.ac.uk/collection/S06/current/S0600020/                  
334338 http://vocab.nerc.ac.uk/collection/S06/current/S0600020/                  
334339 http://vocab.nerc.ac.uk/collection/S06/current/S0600020/                  
334340 http://vocab.nerc.ac.uk/collection/S06/current/S0600020/                  
334341 http://vocab.nerc.ac.uk/collection/S06/current/S0600020/                  
                                                        occurrenceID
334336 Station_217_Date_03APR2003:13:28:00.000_Litopenaeus_setiferus
334337 Station_217_Date_24FEB2006:10:12:00.000_Litopenaeus_setiferus
334338 Station_217_Date_23JUN2001:12:28:00.000_Litopenaeus_setiferus
334339 Station_212_Date_23MAY1990:10:43:00.000_Litopenaeus_setiferus
334340 Station_212_Date_24JUL1990:09:34:00.000_Litopenaeus_setiferus
334341 Station_212_Date_21MAR2001:11:52:00.000_Litopenaeus_setiferus

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
  samplingProtocol                locality   waterBody decimalLatitude decimalLongitude
1        Bag Seine Mission-Aransas Estuary Aransas Bay        28.13472        -97.00833
2        Bag Seine Mission-Aransas Estuary Aransas Bay        28.13528        -97.00722
3        Bag Seine Mission-Aransas Estuary Aransas Bay        28.13444        -96.99611
4        Bag Seine Mission-Aransas Estuary Aransas Bay        28.13444        -96.99611
5        Bag Seine Mission-Aransas Estuary Aransas Bay        28.13444        -96.99611
6        Bag Seine Mission-Aransas Estuary Aransas Bay        28.13472        -96.99583
            eventDate sampleSizeValue minimumDepthInMeters maximumDepthInMeters  type   modified language
1 1997-01-09 14:35:00            0.03                  0.0                  0.6 Event 2022-01-09       en
2 2000-08-18 11:02:00            0.03                  0.1                  0.5 Event 2022-01-09       en
3 2005-06-28 08:41:00            0.03                  0.4                  0.6 Event 2022-01-09       en
4 2006-08-23 11:47:00            0.03                  0.2                  0.4 Event 2022-01-09       en
5 2006-10-17 14:23:00            0.03                  0.7                  0.8 Event 2022-01-09       en
6 1996-02-19 10:27:00            0.03                  0.1                  0.3 Event 2022-01-09       en
                                                     license institutionCode ownerInstitutionCode
1 http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD                 HARC
2 http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD                 HARC
3 http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD                 HARC
4 http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD                 HARC
5 http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD                 HARC
6 http://creativecommons.org/publicdomain/zero/1.0/legalcode            TPWD                 HARC
  coordinateUncertaintyInMeters geodeticDatum georeferenceProtocol       country countryCode stateProvince
1                           100         WGS84         Handheld GPS United States          US         Texas
2                           100         WGS84         Handheld GPS United States          US         Texas
3                           100         WGS84         Handheld GPS United States          US         Texas
4                           100         WGS84         Handheld GPS United States          US         Texas
5                           100         WGS84         Handheld GPS United States          US         Texas
6                           100         WGS84         Handheld GPS United States          US         Texas
                              datasetID                                eventID sampleSizeUnit
1 TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_95_Date_09JAN1997:14:35:00.000       hectares
2 TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_95_Date_18AUG2000:11:02:00.000       hectares
3 TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_96_Date_28JUN2005:08:41:00.000       hectares
4 TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_96_Date_23AUG2006:11:47:00.000       hectares
5 TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_96_Date_17OCT2006:14:23:00.000       hectares
6 TPWD_HARC_Texas_Aransas_Bay_Bag_Seine Station_96_Date_19FEB1996:10:27:00.000       hectares
  samplingEffort
1    120 seconds
2    120 seconds
3    120 seconds
4    120 seconds
5    120 seconds
6    120 seconds

write.csv(event, file = paste0(event[1,]$datasetID, "_event_", lubridate::today(),".csv"), fileEncoding = "UTF-8", row.names = F, na = "")                    

occurrence <- occurrence[c("vernacularName","eventID","occurrenceStatus","basisOfRecord",
                           "scientificName","scientificNameID","kingdom","phylum","class",
                           "order","family","genus",
                           "scientificNameAuthorship","taxonRank", "organismQuantity",
                           "organismQuantityType", "occurrenceID","collectionCode")]
head(occurrence)
  vernacularName                                eventID occurrenceStatus    basisOfRecord
1  Alligator gar Station_95_Date_09JAN1997:14:35:00.000           Absent HumanObservation
2  Alligator gar Station_95_Date_18AUG2000:11:02:00.000           Absent HumanObservation
3  Alligator gar Station_96_Date_28JUN2005:08:41:00.000           Absent HumanObservation
4  Alligator gar Station_96_Date_23AUG2006:11:47:00.000           Absent HumanObservation
5  Alligator gar Station_96_Date_17OCT2006:14:23:00.000           Absent HumanObservation
6  Alligator gar Station_96_Date_19FEB1996:10:27:00.000           Absent HumanObservation
        scientificName                          scientificNameID  kingdom   phylum       class
1 Atractosteus spatula urn:lsid:marinespecies.org:taxname:279822 Animalia Chordata Actinopteri
2 Atractosteus spatula urn:lsid:marinespecies.org:taxname:279822 Animalia Chordata Actinopteri
3 Atractosteus spatula urn:lsid:marinespecies.org:taxname:279822 Animalia Chordata Actinopteri
4 Atractosteus spatula urn:lsid:marinespecies.org:taxname:279822 Animalia Chordata Actinopteri
5 Atractosteus spatula urn:lsid:marinespecies.org:taxname:279822 Animalia Chordata Actinopteri
6 Atractosteus spatula urn:lsid:marinespecies.org:taxname:279822 Animalia Chordata Actinopteri
             order        family        genus scientificNameAuthorship taxonRank organismQuantity
1 Lepisosteiformes Lepisosteidae Atractosteus         (Lacepède, 1803)   Species                0
2 Lepisosteiformes Lepisosteidae Atractosteus         (Lacepède, 1803)   Species                0
3 Lepisosteiformes Lepisosteidae Atractosteus         (Lacepède, 1803)   Species                0
4 Lepisosteiformes Lepisosteidae Atractosteus         (Lacepède, 1803)   Species                0
5 Lepisosteiformes Lepisosteidae Atractosteus         (Lacepède, 1803)   Species                0
6 Lepisosteiformes Lepisosteidae Atractosteus         (Lacepède, 1803)   Species                0
  organismQuantityType                                                occurrenceID        collectionCode
1   Relative Abundance Station_95_Date_09JAN1997:14:35:00.000_Atractosteus_spatula Aransas Bay Bag Seine
2   Relative Abundance Station_95_Date_18AUG2000:11:02:00.000_Atractosteus_spatula Aransas Bay Bag Seine
3   Relative Abundance Station_96_Date_28JUN2005:08:41:00.000_Atractosteus_spatula Aransas Bay Bag Seine
4   Relative Abundance Station_96_Date_23AUG2006:11:47:00.000_Atractosteus_spatula Aransas Bay Bag Seine
5   Relative Abundance Station_96_Date_17OCT2006:14:23:00.000_Atractosteus_spatula Aransas Bay Bag Seine
6   Relative Abundance Station_96_Date_19FEB1996:10:27:00.000_Atractosteus_spatula Aransas Bay Bag Seine
                           
write.csv(occurrence, file = paste0(event[1,]$datasetID, "_occurrence_",lubridate::today(),".csv"), fileEncoding = "UTF-8", row.names = F, na = "")
```