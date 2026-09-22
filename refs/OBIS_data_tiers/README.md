This document discusses a set of data detail "tiers" from bare minimum OBIS requirements (tier 0) up to much more detailed, domain-specific data.
These tiers define sets of Darwin Core (DwC) terms. 
A dataset which meets requirements of a particular tier is described as a tier-n DwC dataset.
As you align your data to DwC you will start by completing tier-0 and then progress upwards into higher tiers.
In general it is good practice to submit your tier-0 DwC data and update your submission once you have achieved a higher tier.

A google slide presentation to accompany these text descriptions can be found [here](https://docs.google.com/presentation/d/1KJJnyMaY75o9PImbmHWI0q89fXYv-7OmJGvq_yObSAM/edit?usp=sharing).


## Tier 0
Tier-0 is used to describe a set of Darwin Core files that meet the bare minimum requirements for submission to OBIS.
This is as simple as it gets.
Only one file is needed: `occurrences.csv`.

Each row in the file represents one observation.
This file contains only the following columns:

- occurrenceID    
- decimalLatitude
- decimalLongitude
- scientificName        
- scientificNameID    
- occurrenceStatus    
- basisOfRecord
- datasetID
- eventDate

An example Tier-0 dataset is the [datasets/example_obis_minimum_flair](https://github.com/ioos/bio_data_guide/tree/master/datasets/example_obis_minimum_flair) dataset.

## Tier 1
Tier-1 describes datsets with additional details which are generic enough to apply to any dataset, regardless of the dataset domain.
All DwC datsets should strive to complete tier-1's requirements.

Occurrences are usually recorded as part of a sampling event, research cruise, or similar multiple-occurrence-encapsulating event.
Occurrence entries often also contain additional information about the occurrence.
Tier-1 introduces Event and MeasurementOrFact files to include these additional context and detail about each occurrence.
For describing the context of many occurreneces, an event should be used.
If describing a measurement associated with only one occurence MeasurementorFact should be used.
MeasurementOrFacts can also be used to add details about an Event.

The following is a schema definition from QuickDBD for tier-1:

```
Occurrence
-
# tier 0 requirements
occurrenceID PK
decimalLatitude
decimalLongitude
scientificName
scientificNameID  
occurrenceStatus
basisOfRecord
datasetID
eventDate
# tier-1-spatial
minimumDepthInMeters    
maximumDepthInMeters    
coordinateUncertaintyInMeters
footprintWKT
# tier-1-quantity
individualCount
organismQuantity
# tier-1-organism_detail
lifeStage
reproductiveCondition
behavior
associatedMedia
# tier-1-specimen
preparations
disposition
# tier-1-event 
eventID FK >- Event.eventID


# tier-1-event 
Event
-
eventID PK 
parentEventID FK >- Event.eventID
eventDate
habitat
samplingProtocol
sampleSizeValue
sampleSizeUnit
samplingEffort

# tier-1-MoF
MeasurementOrFacts_event as MoFE
----
measurementID PK 
eventID FK >- Event.eventID
measurementType
measurementValue
measurementAccuracy
measurementUnit
measurementMethod

# tier-1-MoF
MeasurementOrFacts_occurrence as MoFO
----
measurementID PK 
occurrenceID FK >- Occurrence.occurrenceID
measurementType
measurementValue
measurementAccuracy
measurementUnit
measurementMethod
```

The above schema can be copy-pasted into https://app.quickdatabasediagrams.com/ for an interactive view.

## Tier 2+
Tier 2 and higher describe domain-specific additions on top of tier-0 or tier-1.
