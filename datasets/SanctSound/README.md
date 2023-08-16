This directory contains the processes in which the [SanctSound](https://www.ncei.noaa.gov/maps/passive_acoustic_data/) data are translated to Darwin Core.

# Mobilized data endpoints
* GBIF - https://www.gbif.org/dataset/b3fc1d76-a50d-4a57-a2f3-425adfc59f9f
* OBIS - https://obis.org/dataset/7a4427f6-67ee-4cc1-b95f-3045523420a1

## Definitions

term | definition
-----|-----------
occurrence | Species `x` made an acoustic sound at `y` location on `z` day. We have binned all presence detections to daily occurrences. So, if an animal made multiple sounds during one day, it would be recorded as 1 occurrence.

# File descriptions
file | description
-----|------------
[**01_sound_production_to_presence.ipynb**](https://github.com/ioos/bio_data_guide/blob/main/datasets/SanctSound/01_sound_production_to_presence.ipynb) | Notebook to collect and combine the acoustically present records on [Coastwatch ERDDAP](https://coastwatch.pfeg.noaa.gov/erddap/index.html). Merges in WoRMS mapping table, and creates an `eventDate` column. Writes out `data/sanctsound_presence.zip`.
[**02_presence_to_occurrence.ipynb**](https://github.com/ioos/bio_data_guide/blob/main/datasets/SanctSound/02_presence_to_occurrence.ipynb) | Notebook to convert the presence file to an occurrence file. Creates `occurrenceID`. Reads in `data/sanctsound_presence.zip`. Writes out `data/occurrence.zip`.
[**03_occurrence_coordinateUncertainty.ipynb**](https://github.com/ioos/bio_data_guide/blob/main/datasets/SanctSound/03_occurrence_coordinateUncertainty.ipynb) | Notebook that gathers [sound propagation modeling](https://sanctsound.portal.axds.co/#sanctsound/compare/prop-model) data from Google Cloud Storage and adds them to the occurrence table. This also does some initial QA/QC and creates an emof table. Reads in `data/occurrence.zip` and [sound propagation model data](https://console.cloud.google.com/storage/browser/noaa-passive-bioacoustic/sanctsound/products/sound_propagation_models;tab=objects). Writes out `data/emof.zip` and `data/occurrence_w_coordinateUncertainty.zip`.
[**04_data_fixes.ipynb**](https://github.com/ioos/bio_data_guide/blob/main/datasets/SanctSound/04_data_fixes.ipynb) | This notebook fixes some errors that were found once the data were loaded to GBIF. Reads in `data/occurrence_w_coordinateUncertainty.zip`. Writes out `data/occurrence_w_coordinateUncertainty.zip`.
[**SanctSound_SpeciesLookupTable.csv**](https://github.com/ioos/bio_data_guide/blob/main/datasets/SanctSound/SanctSound_SpeciesLookupTable.csv) | Species and frequency lookup table for occurrence records. 
