## Passive Acoustic Monitoring

This is the processes by which the [SanctSound](https://sanctsound.ioos.us/) passive acoustic monitoring data are translated to Darwin Core.

### Background
The information contained here describes the process by which the passive acoustic monitoring data, collected by the 
National Marine Sanctuaries [Sanctuary Soundscape Monitoring Project (SanctSound)](https://sanctsound.ioos.us/), was
mobilized to OBIS-USA for standardization and sharing to the global repositories OBIS and GBIF. Below we set the stage 
by clearly defining what an occurrence is in this specific case, then we perform the data translation to DarwinCore, 
including some data QC, for submission to OBIS-USA. Finally, we provide links to the data once they have been mobilized
to OBIS-USA, OBIS, and GBIF.

### Source datasets 
The data used in this process were sourced from the following locations:

data | source | url 
-----|--------|----
sound production | ERDDAP | https://coastwatch.pfeg.noaa.gov/erddap/search/index.html?page=1&itemsPerPage=1000&searchFor=sanctsound+%22Sound+Production%22
sound propagation | Google Cloud Storage | https://console.cloud.google.com/storage/browser/noaa-passive-bioacoustic/sanctsound/products/sound_propagation_models;tab=objects

### Definitions

term | definition
-----|-----------
occurrence | Species `x` made an acoustic sound at `y` location on `z` day. We have binned all presence detections to daily occurrences. So, if an animal made multiple sounds during one day, it would be recorded as 1 occurrence.

### File descriptions
file | description
-----|------------
[**01_sound_production_to_presence.ipynb**](https://github.com/ioos/bio_data_guide/blob/main/datasets/SanctSound/01_sound_production_to_presence.ipynb) | Notebook to collect and combine the acoustically present records on [Coastwatch ERDDAP](https://coastwatch.pfeg.noaa.gov/erddap/index.html). Merges in WoRMS mapping table, and creates an `eventDate` column. Writes out `data/sanctsound_presence.zip`.
[**02_presence_to_occurrence.ipynb**](https://github.com/ioos/bio_data_guide/blob/main/datasets/SanctSound/02_presence_to_occurrence.ipynb) | Notebook to convert the presence file to an occurrence file. Creates `occurrenceID`. Reads in `data/sanctsound_presence.zip`. Writes out `data/occurrence.zip`.
[**03_occurrence_coordinateUncertainty.ipynb**](https://github.com/ioos/bio_data_guide/blob/main/datasets/SanctSound/03_occurrence_coordinateUncertainty.ipynb) | Notebook that gathers [sound propagation modeling](https://sanctsound.portal.axds.co/#sanctsound/compare/prop-model) data from Google Cloud Storage and adds them to the occurrence table. This also does some initial QA/QC and creates an emof table. Reads in `data/occurrence.zip` and [sound propagation model data](https://console.cloud.google.com/storage/browser/noaa-passive-bioacoustic/sanctsound/products/sound_propagation_models;tab=objects). Writes out `data/emof.zip` and `data/occurrence_w_coordinateUncertainty.zip`.
[**04_data_fixes.ipynb**](https://github.com/ioos/bio_data_guide/blob/main/datasets/SanctSound/04_data_fixes.ipynb) | This notebook fixes some errors that were found once the data were loaded to GBIF. Reads in `data/occurrence_w_coordinateUncertainty.zip`. Writes out `data/occurrence_w_coordinateUncertainty.zip`.
[**SanctSound_SpeciesLookupTable.csv**](https://github.com/ioos/bio_data_guide/blob/main/datasets/SanctSound/SanctSound_SpeciesLookupTable.csv) | Species and frequency lookup table for occurrence records.
[**data/**](https://github.com/ioos/bio_data_guide/blob/main/datasets/SanctSound/data) | Intermediary and final data files sent to OBIS-USA.

### Mobilized data endpoints
* GBIF - https://www.gbif.org/dataset/b3fc1d76-a50d-4a57-a2f3-425adfc59f9f
* OBIS - https://obis.org/dataset/7a4427f6-67ee-4cc1-b95f-3045523420a1
* OBIS-USA IPT - https://ipt-obis.gbif.us/resource?r=noaa_sanctsound_daily_species

### Key takeaways
- For passive acoustic monitoring data, it is really important to define a coordinateUncertaintyInMeters. We defined this by using the sound propagation modeling data, matching on frequency, site, and season.
- The sound propagation data were massive and hard to work with on Google Cloud Storage. But, `gsutil` made it easy to download all of the necessary files.
- The metadata available from the ERDDAP source and the netCDF sound propagation data were immensly helpful for mapping to Darwin Core.
- Extracting information from file names is a relatively easy process and can be beneficial when aligning to Darwin Core.
- Performing Darwin Core checks before sending data to OBIS-USA helps reduce the amount of iteration with the node manager.
- You can see the entire conversation for mobilizing these data at https://github.com/ioos/bio_data_guide/issues/147.