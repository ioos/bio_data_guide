# ioos_bio_data_scripts
Bio data scripts &amp; code samples related to the IOOS code sprint Biological Data Session.

Each subdirectory is focuses on a particular problem/question.
The subdirectories may contain R `DESCRIPTION` and/or python `requirements.txt` files to help with installing dependencies.
Subdirectories can also contain their own README files.

There are no hard rules here; it's just a quick and easy place to drop your scripts/examples.

The `install.sh` (and `install_*.sh`) files in the root dir are helpers which comb through the subdirs and try to install all dependencies.
They aren't pretty.

Highlights:

* data_to_dwc : Abby's example data transformations
* obis_subset : Pull data out of OBIS using robis then make some plots in R & in python. 
