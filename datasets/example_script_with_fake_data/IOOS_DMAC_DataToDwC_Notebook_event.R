#' Aligning Data to Darwin Core - Sampling Event with Measurement or Fact
#' Abby Benson  
#' October 8,2019 

#' ## General information about this notebook
#' This notebook was created for the IOOS DMAC Code Sprint Biological Data Session
#' The data in this notebook were created specifically as an example and meant solely to be
#' illustrative of the process for aligning data to the biological data standard - Darwin Core.
#' These data should not be considered actually occurrences of species and any measurements
#' are also contrived. This notebook is meant to provide a step by step process for taking
#' original data and aligning it to Darwin Core.

#+ Load libraries, include=T
library(readr)
library(uuid)
library(dplyr)

MadeUpDataForBiologicalDataTraining <- read_csv("~/OBIS/Reference Documentation/Presentations/IOOS DMAC Code Sprint/MadeUpDataForBiologicalDataTraining.csv")

#' First we need to to decide if we will provide an occurrence only version of the data or 
#' a sampling event with measurement or facts version of the data. Occurrence only is easier 
#' to create. It's only one file to produce. However, several pieces of information will be
#' left out if we choose that option. If we choose to do sampling event with measurement or
#' fact we'll be able to capture all of the data in the file creating a lossless version. 
#' Here we decide to use the sampling event option to include as much information as we can.

#' First let's create the eventID and occurrenceID in the original file so that information
#' can be reused for all necessary files down the line.
MadeUpDataForBiologicalDataTraining$eventID <- paste(MadeUpDataForBiologicalDataTraining$region, 
                                                     MadeUpDataForBiologicalDataTraining$station, 
                                                     MadeUpDataForBiologicalDataTraining$transect, sep = "_") 
MadeUpDataForBiologicalDataTraining$occurrenceID <- ""
MadeUpDataForBiologicalDataTraining$occurrenceID <- sapply(MadeUpDataForBiologicalDataTraining$occurrenceID, 
                                       function(x) UUIDgenerate(use.time = TRUE))

#' We will need to create three separate files to comply with the sampling event format.
#' We'll start with the event file but we only need to include the columns that are relevant
#' to the event file.
event <- MadeUpDataForBiologicalDataTraining[c("date", "lat", "lon", "region", "station",
                                               "transect", "depth", "bottom type", "eventID")]

#' Next we need to rename any columns of data that match directly to Darwin Core. We know
#' this based on our crosswalk spreadsheet CrosswalkToDarwinCore.csv
event$decimalLatitude <- event$lat
event$decimalLongitude <- event$lon
event$minimumDepthInMeters <- event$depth
event$maximumDepthInMeters <- event$depth
event$habitat <- event$`bottom type`
event$island <- event$region

#' Let's see how it looks:
head(event, n = 10)

#' We need to convert the date to ISO format
event$eventDate <- as.Date(event$date, format = "%m/%d/%Y")

#' We will also have to add any missing required fields
event$basisOfRecord <- "HumanObservation"
event$geodeticDatum <- "EPSG:4326 WGS84"

#' Then we'll remove any columns that we no longer need to clean things up a bit.
event$date <- NULL
event$lat <- NULL
event$lon <- NULL
event$region <- NULL
event$station <- NULL
event$transect <- NULL
event$depth <- NULL
event$`bottom type` <- NULL

#' We have too many repeating rows of information. We can pare this down using eventID which
#' is a unique identifier for each sampling event in the data- which is six, three transects
#' per site.
event <- event[which(!duplicated(event$eventID)),]

head(event, n = 6)

#' Finally we write out the event file
write.csv(event, file="MadeUpData_event.csv", row.names=FALSE, fileEncoding="UTF-8", quote=TRUE)

#' Next we need to create the occurrence file. We start by creating the dataframe.
occurrence <- MadeUpDataForBiologicalDataTraining[c("scientific name", "eventID", "occurrenceID", "percent cover")] 

#' Then we'll rename the columns that align directly with Darwin Core.
occurrence$scientificName <- occurrence$`scientific name`

#' Finally we'll add required information that's missing.
occurrence$occurrenceStatus <-  ifelse (occurrence$`percent cover` == 0, "absent", "present")

#' ## Taxonomic Name Matching
#' A requirement for OBIS is that all scientific names match to the World Register of 
#' Marine Species (WoRMS) and a scientificNameID is included. A scientificNameID looks
#' like this "urn:lsid:marinespecies.org:taxname:275730" with the last digits after
#' the colon being the WoRMS aphia ID. We'll need to go out to WoRMS to grab this
#' information.

#' Create a lookup table of unique scientific names
lut_worms <- as.data.frame(unique(occurrence_only$scientificName))
lut_worms$scientificName <- as.character(lut_worms$`unique(occurrence_only$scientificName)`)
lut_worms$`unique(occurrence_only$scientificName)` <- NULL
lut_worms$scientificName <- as.character(lut_worms$scientificName)

#' Add the columns that we can grab information from WoRMS including the required scientificNameID.
lut_worms$acceptedname <- ""
lut_worms$acceptedID <- ""
lut_worms$scientificNameID <- ""
lut_worms$kingdom <- ""
lut_worms$phylum <- ""
lut_worms$class <- ""
lut_worms$order <- ""
lut_worms$family <- ""
lut_worms$genus <- ""
lut_worms$scientificNameAuthorship <- ""
lut_worms$taxonRank <- ""

#' Taxonomic lookup using the library taxizesoap
for (i in 1:nrow(lut_worms)){
  df <- worms_records(scientific = lut_worms$scientificName[i])
  lut_worms[i,]$scientificNameID <- df$lsid[1]
  lut_worms[i,]$acceptedname <- df$valid_name[1]
  lut_worms[i,]$acceptedID <- df$valid_AphiaID[1]
  lut_worms[i,]$kingdom <- df$kingdom[1]
  lut_worms[i,]$phylum <- df$phylum[1]
  lut_worms[i,]$class <- df$class[1]
  lut_worms[i,]$order <- df$order[1]
  lut_worms[i,]$family <- df$family[1]
  lut_worms[i,]$genus <- df$genus[1]
  lut_worms[i,]$scientificNameAuthorship <- df$authority[1]
  lut_worms[i,]$taxonRank <- df$rank[1]
  message(paste("Looking up information for species:", lut_worms[i,]$scientificName))
}

#' Merge the lookup table of unique scientific names back with the occurrence data.
occurrence <- merge(occurrence, lut_worms, by = "scientificName")

#' We're going to remove any unnecessary columns to clean up the file
occurrence$`scientific name` <- NULL
occurrence$`percent cover` <- NULL

#' Quick look at what we have before we write out the file
head(occurrence, n = 10)

#' Write out the file. All done with occurrence!
write.csv(occurrence, file="MadeUpData_Occurrence.csv", row.names=FALSE, fileEncoding="UTF-8", quote=TRUE)

#' The last file we need to create is the measurement or fact file. For this we need to 
#' combine all of the measurements or facts that we want to include making sure to include
#' IDs from the BODC NERC vocabulary where possible.
temperature <- MadeUpDataForBiologicalDataTraining[c("eventID", "temperature", "date")]
temperature$occurrenceID <- ""
temperature$measurementType <- "temperature"
temperature$measurementTypeID <- "http://vocab.nerc.ac.uk/collection/P25/current/WTEMP/"
temperature$measurementValue <- temperature$temperature
temperature$measurementUnit <- "Celsius"
temperature$measurementUnitID <- "http://vocab.nerc.ac.uk/collection/P06/current/UPAA/"
temperature$measurementAccuracy <- 3
temperature$measurementDeterminedDate <- as.Date(temperature$date, format = "%m/%d/%Y")
temperature$measurementMethod <- ""
temperature$temperature <- NULL
temperature$date <- NULL
rugosity <- MadeUpDataForBiologicalDataTraining[c("eventID", "rugosity", "date")]
rugosity$occurrenceID <- ""
rugosity$measurementType <- "rugosity"
rugosity$measurementTypeID <- ""
rugosity$measurementValue <- rugosity$rugosity
rugosity$measurementUnit <- ""
rugosity$measurementUnitID <- ""
rugosity$measuremntAccuracy <- ""
rugosity$measurementDeterminedDate <- as.Date(rugosity$date, format = "%m/%d/%Y")
rugosity$measurementMethod <- ""
rugosity$rugosity <- NULL
rugosity$date <- NULL
percentcover <- MadeUpDataForBiologicalDataTraining[c("eventID", "occurrenceID", "percent cover", "date")]
percentcover$measurementType <- "Percent Cover"
percentcover$measurementTypeID <- "http://vocab.nerc.ac.uk/collection/P01/current/SDBIOL10/"
percentcover$measurementValue <- percentcover$`percent cover`
percentcover$measurementUnit <- "Percent/100m^2"
percentcover$measurementUnitID <- ""
percentcover$measuremntAccuracy <- 5
percentcover$measurementDeterminedDate <- as.Date(percentcover$date, format = "%m/%d/%Y")
percentcover$measurementMethod <- ""
percentcover$`percent cover` <- NULL
percentcover$date <- NULL
measurementOrFact <- rbind(temperature, rugosity, percentcover)

#' Let's check to see what it looks like
head(measurementOrFact, n = 50)

write.csv(measurementOrFact, file="MadeUpData_mof.csv", row.names=FALSE, fileEncoding="UTF-8", quote=TRUE)