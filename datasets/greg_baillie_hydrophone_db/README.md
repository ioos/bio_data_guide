These notes are about a dataset from Greg Baillie from the [2022 Marine BioData Mobilization Workshop](https://github.com/ioos/bio_mobilization_workshop).

This database exists in a SQL database and an extraction is being done to produce DwC-compatibile csv files.

The db is the backend to https://data.oceannetworks.ca/

Current plan is to export the data as occurrence core with the Location and MoF extensions.

### How to encode uncertainty from annotations

One or more of the terms under the Location extension can be used as follows:
* could use `identificationVerificationStatus` to mark some as "0 ("unverified" in HISPID/ABCD)."
* could use `identificationQualifier` to include `cf` or `aff` as appropriate.
* could put actual annotation into `identificationRemarks`. `occurrenceRemarks` is more often used to note remarks about the conditions of the occurrence.

In OBIS terms in the Location extension should just be included as columns in the occurence file. 
