# Tools
Below are some of the tools and packages used in workflows.

## R
Package | Description
-----|-------------
[robis](https://cran.r-project.org/web/packages/robis/index.html) | R client for the OBIS API
[iobis/obistools](https://iobis.github.io/obistools/) | Tools for data enhancement and quality control.
[worrms](https://cran.r-project.org/web/packages/worrms/index.html) | Client for [World Register of Marine Species](http://www.marinespecies.org/). Includes functions for each of the API methods, including searching for names by name, date and common names, searching using external identifiers, fetching synonyms, as well as fetching taxonomic children and taxonomic classification.
[tidyverse](https://cran.r-project.org/web/packages/tidyverse/index.html) | The 'tidyverse' is a set of packages that work in harmony because they share common data representations and 'API' design. This package is designed to make it easy to install and load multiple 'tidyverse' packages in a single step.
[lubridate](https://cran.r-project.org/web/packages/lubridate/index.html) | Functions to work with date-times and time-spans: fast and user friendly parsing of date-time data, extraction and updating of components of a date-time (years, months, days, hours, minutes, and seconds), algebraic manipulation on date-time and time-span objects.
[stringr](https://cran.r-project.org/web/packages/stringr/index.html) | Simple, Consistent Wrappers for Common String Operations
[ecocomDP](https://cran.r-project.org/web/packages/ecocomDP/index.html) | Work with the Ecological Community Data Design Pattern. 'ecocomDP' is a flexible data model for harmonizing ecological community surveys, in a research question agnostic format, from source data published across repositories, and with methods that keep the derived data up-to-date as the underlying sources change.
[finch](https://cran.r-project.org/web/packages/finch/index.html) | Parse Darwin Core Files
[taxize](https://cran.r-project.org/web/packages/taxize/index.html) | Interacts with a suite of web 'APIs' for taxonomic tasks, such as getting database specific taxonomic identifiers, verifying species names, getting taxonomic hierarchies, fetching downstream and upstream taxonomic names, getting taxonomic synonyms, converting scientific to common names and vice versa, and more.
[Hmisc](https://www.rdocumentation.org/packages/Hmisc/versions/4.6-0) | Contains many functions useful for data analysis, high-level graphics, utility operations, functions for computing sample size and power, simulation, importing and annotating datasets, imputing missing values, advanced table making, variable clustering, character string manipulation, conversion of R objects to LaTeX and html code, and recoding variables. Particularly check out the [describe()](https://www.rdocumentation.org/packages/Hmisc/versions/4.6-0/topics/describe) function.
[uuid](https://cran.r-project.org/web/packages/uuid/index.html) | Tools for generating and handling of UUIDs (Universally Unique Identifiers).
[ropensci/EML](https://docs.ropensci.org/EML/) | Provides support for the serializing and parsing of all low-level EML concepts
[EDIorg/EMLasseblyline](https://ediorg.github.io/EMLassemblyline/) | For scientists and data managers to create high quality EML metadata for dataset publication.
[bdveRse](https://bdverse.org/) | A family of R packages for biodiversity data.

## Python
Package | Description
--------|-------------
[pandas](https://pandas.pydata.org/) | pandas is a fast, powerful, flexible and easy to use open source data analysis and manipulation tool, built on top of the Python programming language. Super helpful when manipulating tabular data!
[numpy](https://numpy.org/) | NumPy (Numerical Python) is an open source Python library that’s used in almost every field of science and engineering. It’s the universal standard for working with numerical data in Python, and it’s at the core of the scientific Python and PyData ecosystems.
[pyworms](https://github.com/iobis/pyworms) | Python client for the World Register of Marine Species (WoRMS) REST service.
[uuid](https://docs.python.org/3/library/uuid.html) | This module provides immutable UUID objects (class UUID) and the functions uuid1(), uuid3(), uuid4(), uuid5() for generating version 1, 3, 4, and 5 UUIDs as specified in RFC 4122.
[python-dwca-reader](https://python-dwca-reader.readthedocs.io/en/latest/index.html) | A simple Python package to read and parse Darwin Core Archive (DwC-A) files, as produced by the GBIF website, the IPT and many other biodiversity informatics tools.
[metapype](https://pypi.org/project/metapype/) | A lightweight Python 3 library for generating EML metadata

## Google Sheets
Package | Description
--------|------------
[Google Sheet DarwinCore Archive Assistant add-on](https://dwcaassistant.com/) | Google Sheet add-on which assists the creation of Darwin Core Archives (DwCA) and publising to Zenodo. DwCA's are stored into user's Google Drive and can be downloaded for upload into IPT installations or other software which is able to read DwC-archives.

## Validators
Name | Description
-----|------------
[Darwin Core Archive Validator](https://tools.gbif.org/dwca-validator/) | This validator verifies the structural integrity of a Darwin Core Archive. It does not check the data values, such as coordinates, dates or scientific names.
[GBIF DATA VALIDATOR](https://www.gbif.org/tools/data-validator) | The GBIF data validator is a service that allows anyone with a GBIF-relevant dataset to receive a report on the syntactical correctness and the validity of the content contained within the dataset.
[LifeWatch Belgium](https://www.lifewatch.be/data-services/) | Through this interactive section of the LifeWatch.be portal users can upload their own data using a standard data format, and choose from several web services, models and applications to process the data.
