# Contact: Michael Lonneman, lonnemanm@si.edu
# Warning: This is a rough first attempt at creating an automated workflow for the conversion of MarineGEO data to the Darwin Core schema
# There are several issues with the resulting Darwin Core tables, including inappropriate eventIDs and occurrenceIDs. 
# The data is also made up. You've been warned. 

library(tidyverse)
library(magrittr)
library(readxl)

# Protocol structure, see marinegeo.github.io for protocol templates
protocol_structure <- read_csv("./data_to_dwc/marinegeo_trial_dwc_conversion/protocol_structure.csv")

# Provide information for example sampling event
site <- "USA-VASB"
protocols <- c("fish_seines", "seagrass_density", "seagrass_epifauna", "seagrass_shoots")
date <- "2019-September-23"

# Create a named list structure to hold all the data from each protocol
all_data <- vector("list", length(protocols))
names(all_data) <- protocols

## Read in data ###############

# Loop through each protocol, pull in each data sheet
for(protocol_name in protocols){
  
  # Get names of sheets for given protocol
  protocol_sheets <- protocol_structure %>%
    filter(protocol == protocol_name) %$% # Note use of %$% rather than %>%, allows you to use $ in unique and get results as a vector
    unique(.$sheet)
  
  # Create an empty list, each object will be a sheet for the protocol
  protocol_df <- vector("list", length(protocol_sheets))
  names(protocol_df) <- protocol_sheets
  
  # Read in each sheet for the protocol, assign to respective list object 
  for(sheet_name in protocol_sheets) {
    
    # Create file path for current sheet
    file <- paste0("./data_to_dwc/marinegeo_trial_dwc_conversion/", site, "/", protocol_name, "/", protocol_name, "_", site, "_", date, ".xlsx")
    
    protocol_df[[sheet_name]] <- read_excel(file, 
                                            sheet = sheet_name, 
                                            na = c("NA", "This cell will autocalculate"))
  }
  
  all_data[[protocol_name]] <- protocol_df
}

## Build Event Table ############
# Create parent events for each transect - fish trawls and other data collected at transect level will be associated
# Each quadrat will be a child event
# For each table, need to extract correct number of quadrats from data sheets
# Current code represents a transect as an event, but that is incorrect

event_df <- data.frame()

for(protocol_name in protocols){
  event_data <- all_data[[protocol_name]]$sample_metadata %>%
    mutate(eventID = paste(site_code, 
                           location_name, 
                           transect, 
                           sample_collection_date, sep="_"),
           footprintWTK = paste0("LINESTRING(", 
                                 transect_begin_decimal_latitude, " ", transect_begin_decimal_longitude, ", ", 
                                 transect_end_decimal_latitude, " ", transect_end_decimal_longitude, ")"),
           decimalLatitude = transect_begin_decimal_latitude,
           decimalLongitude = transect_begin_decimal_longitude,
           minimumDepthInMeters = depth_m,
           maximumDepthInMeters = depth_m) %>%
    select(eventID, decimalLatitude, decimalLongitude, minimumDepthInMeters, maximumDepthInMeters, footprintWTK)
  
  event_df <- bind_rows(event_df, event_data)
}
 
event_df <- event_df %>%
  distinct()

## Build occurrence data ######

occurrence_df <- data.frame()

for(protocol_name in protocols){
  
  # Get names of sheets for given protocol
  protocol_sheets <- protocol_structure %>%
    filter(sheet != "sample_metadata" & sheet != "taxa_list" & sheet != "macro_invert_sample_data") %>%
    filter(protocol == protocol_name) %$% # Note use of %$% rather than %>%, allows you to use $ in unique and get results as a vector
    unique(.$sheet)
  
  for(sheet in protocol_sheets){
    
    occurrence_data <- all_data[[protocol_name]][[sheet]] 

    # Fish seines are done at transect-level, rather than quadrats. Needs different workflow
    if(protocol_name == "fish_seines" & sheet == "sample_data") {
      occurrence_data <- rename(occurrence_data, quadrat = abundance)
    }
    
    # Occurence ID is currently per quadrat, but needs to be for species observation at quadrat
    if("taxon_id" %in% colnames(all_data[[protocol_name]][[sheet]])){
      occurrence_data <- occurrence_data %>%
        mutate(eventID = paste(site_code,
                               location_name,
                               transect,
                               sample_collection_date, sep="_"),
               occurrenceID = paste(site_code,
                                    location_name,
                                    transect,
                                    sample_collection_date,
                                    quadrat, sep="_")) %>%
        select(eventID, occurrenceID, taxon_id)

      occurrence_df <- bind_rows(occurrence_df, occurrence_data)
    }
  }
}

occurrence_df <- occurrence_df %>%
  distinct()

## Build fact or measurement table #####

factOrMeasurement_df <- data.frame()

for(protocol_name in protocols){
  
  # Get names of sheets for given protocol
  protocol_sheets <- protocol_structure %>%
    filter(sheet != "sample_metadata" & sheet != "taxa_list" & sheet != "macro_invert_sample_data") %>%
    filter(protocol == protocol_name) %$% # Note use of %$% rather than %>%, allows you to use $ in unique and get results as a vector
    unique(.$sheet)
  
  for(sheet in protocol_sheets){
    
    factOrMeasurement_data <- all_data[[protocol_name]][[sheet]] 
    
    if(protocol_name == "fish_seines" & sheet == "sample_data") {
      factOrMeasurement_data <- rename(factOrMeasurement_data, quadrat = abundance)
    }
    
    # Gather operation doesn't handle presence of numeric and character columns
    if("taxon_id" %in% colnames(all_data[[protocol_name]][[sheet]])){
      factOrMeasurement_data <- factOrMeasurement_data %>%
        ## Eventually: group by and assign unique ID for each fish-combo
        mutate(occurrenceID = paste(site_code,
                                    location_name,
                                    transect,
                                    sample_collection_date,
                                    quadrat, sep="_")) %>%
        select(-c(site_code, location_name, transect, sample_collection_date, quadrat, taxon_id)) %>%
        mutate_all(as.character()) %>%
        gather(key="measurementType", value="measurementValue", -occurrenceID) %>%
        select(occurrenceID, measurementType, measurementValue)
      
      factOrMeasurement_df <- factOrMeasurement_data %>%
        mutate_all(as.character) %>%
        bind_rows(factOrMeasurement_df)
    }
  }
}

factOrMeasurement_df <- factOrMeasurement_df %>%
  distinct()


