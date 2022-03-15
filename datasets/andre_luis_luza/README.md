Dataset being aligned at the 2022 BioData Mobilization Workshop by Andre Luis Luza.


The dataset was collected using belt transects distributed throughout BR coast and islands. 
Researchers applied a nested sampling design: higherGeographyUnit -> locationID -> locality -> transect

REf here: http://lecar.uff.br/uploads/site_publicacoes/Morais_et_al._2017_Spatial_patterns_of_fish_standing_biomass_across_Brazilian_reefs.pdf

------------------------------------

TODO: `**. depth_m` should be splitted into "min ... " and "max ... "

the eventID has the following information: `BR:SISBIOTA-MAR:stpauls_rocks_enseada_2009_2793`

This is basically the dataset (BR:SISBIOTA-MAR), the locationID (stpauls_rocks), the locality (enseada), the year (2009), and the transectID (2793).

This dataset will be an event-core dataset utilizing the occurrence and MoF extensions.

```R
# The MoF columns:
c("eventID", "occurrenceID","scientificName","scientificNameID",
                                "measurementValue", "measurementType","measurementUnit")

# The occurrence table columns:
c("eventID", "occurrenceID","basisOfRecord","scientificName","scientificNameID","kingdom",
                               "recordedBy", "organismQuantityType", "occurrenceStatus")

# the event core another set of descriptors:
parentEventID + eventID +
                                 higherGeographyID+locationID + locality+
                                 eventDate+eventYear+
                                 minimumDepthinMeters+maximumDepthinMeters+
                                 samplingProtocol+samplingEffort+sampleSizeValue+
                                 decimalLongitude+decimalLatitude+
                                 geodeticDatum+
                                 Country+countryCode
)
