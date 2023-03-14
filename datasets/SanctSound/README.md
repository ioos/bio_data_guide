This directory contains file to translate [SanctSound](https://www.ncei.noaa.gov/maps/passive_acoustic_data/) data to 
Darwin Core.

Included in this directory are the following files:
* processing.ipynb
* `/data`
  * csv file which contains data that:
    1. has a functioning ERDDAP endpoint 
    2. has a variable for presence 
    3. the presence variable is 1 (present). - I have filtered each dataset to only return the times where presence==1.
  * The csv file contains the following standard headers:
    * `time` - time variable
    * `start_time` - start time of observation period?
    * `end_time` - end time of observation period?
    * `dataset_id` - identifier in ERDDAP for the dataset
    * `WKT` - coordinate information from global attribute for dataset (repeated for each presence)
    * `decimalLatitude` - latitude extracted from WKT string
    * `decimalLongitude` - Longitude extracted from WKT string
    * `species` - attempt to pull species info out of data - not foolproof.
    * `*_presence` - presence data for each animal - 1 - present, NaN - not present.