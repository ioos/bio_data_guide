This directory contains file to translate [SanctSound](https://www.ncei.noaa.gov/maps/passive_acoustic_data/) data to 
Darwin Core.

Included in this directory are the following files:
1. **sound_production_to_presence.ipynb** - Notebook to combine the acoustically present records on [Coastwatch ERDDAP](https://coastwatch.pfeg.noaa.gov/erddap/index.html).
1. **presence_to_occurrence.ipynb** - Notebook to convert the presence file to an occurrence file (with some additional columns).
1. **sound_propagation_processing.ipynb** - Notebook to gather [sound propagation modeling](https://sanctsound.portal.axds.co/#sanctsound/compare/prop-model) data and add it to the occurrence table from above.

* **SanctSound_SpeciesLookupTable.csv** - Species and frequency lookup table for occurrence records.
* **/data**
  * zip file which contains data that:
    1. has a functioning ERDDAP endpoint 
    2. has a variable for presence 
    3. the presence variable is 1 (present). - I have filtered each dataset to only return the times where presence==1.
  * **sancsound_presence.zip** contains the following standard headers:
  
    column | description
    -------|------------
    `time` | time variable
    `start_time` | start time of observation period?
    `end_time` | end time of observation period?
    `dataset_id` | identifier in ERDDAP for the dataset
    `WKT` | coordinate information from global attribute for dataset (repeated for each presence)
    `decimalLatitude` | latitude extracted from WKT string
    `decimalLongitude` | Longitude extracted from WKT string
    `species` | attempt to pull species info out of data - not foolproof.
    `*_presence` | presence data for each animal - 1 - present, NaN - not present.

  * **occurrence.zip** contains the following standard headers (DwC compliant):
   
    column | description
    -------|------------
    `WKT` | well known text representation of the geospatial bounds from the ERDDAP presence records.
    `decimalLatitude` | decimal latitude from the geospatial bounds from the ERDDAP presence records.
    `decimalLongitude` | decimal longitude from the geospatial bounds from the ERDDAP presence records.
    `vernacularName` | The name extracted from the title of the dataset in the ERDDAP presence records.
    `scientificName` | The scientific name of the species extracted from the **Sansound_SpeciesLookupTable.csv**.
    `scientificNameID` | The AphiaID of the species extracted from the **Sansound_SpeciesLookupTable.csv**.
    `taxonRank` | The highest rank of the identified species, extracted from the **Sansound_SpeciesLookupTable.csv**.
    `kingdom` | The identified Kingdom to which the species belongs to, extracted from the **Sansound_SpeciesLookupTable.csv**.
    `eventDate` | Date of presence record in ERDDAP presence datasets. (`presence == 1`).
    `occurrenceID` | A combination of the ERDDAP dataset ID and date/time of presence, concatenated together with `_`. For example, `noaaSanctSound_GR01_01_dolphins_1h_2018-12-15T04:00:00.000000Z`.

  * **occurrence_w_coordinateUncertainty.zip** final DarwinCore aligned dataset.
    
    column | description
    -------|------------
    
