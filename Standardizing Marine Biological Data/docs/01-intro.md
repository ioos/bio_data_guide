# Introduction {#intro}

The world of standardizing marine biological data is complex and fraught with uncertainty for the new comer biologist, scientist, or programmer. This is about stacking the right standards for your desired ineroperability with other data types. For example, interopating fish biology measurements with climate level variables. There are a few links neccessary to make this possible and will permit broader access to better ecosystem based models. This phenomena is not unique to specic scientific domains, but is rather pervasive as many scientific domains are currently being rethought in light of game changing computing power, technology, and data science.

## Data Structures

The OBIS-ENV Darwin Core Archive Data Structure.

[OBIS manual]("https://obis.org/manual/")

## Ontologies & Controlled Vocabularies

An ontology is a classification system for establishing a hierarchically related set of concepts. Concepts are often terms from controlled vocabularies.

From Marine Metadata: # TODO: add link

"Ontologies can include all of the following, but are not required to include them, depending on which perspective from above you adhere to:

Classes (general things, types of things)
Instances (individual things)
Relationships among things
Properties of things
Functions, processes, constraints, and rules relating to things"

TODO: Research Unified Modeling Language?

There are a number of controlled vocabularies that are used to describe parameters commonly used in specific research domains. This allows for greater interoperability of data sets within the domain, and ideally between domains. Here, we strive to document a number of relevant examples. 

* [Climate and Format (CF) Standard Names]("http://cfconventions.org/standard-names.html") are applied to sensors for application with OPeNDAP web service. 

* [Device categories]("http://vocab.nerc.ac.uk/collection/L05/current/") using the SeaDataNet device categories in NERC 2.0

* [Device make/model using the SeaVoX Device Catalogue]("http://vocab.nerc.ac.uk/collection/L22/current/") in NERC 2.0, 

* [Platform categories using SeaVoX Platform Categories]("http://vocab.nerc.ac.uk/collection/L06/current/") in NERC 2.0

* [Platform instances using the ICES Platform Codes]("http://vocab.nerc.ac.uk/collection/C17/current/") in NERC 2.0

* [Unit of measure]("http://vocab.nerc.ac.uk/collection/P06/current/") 

* [GCMD Keywords (NASA)]("http://vocab.nerc.ac.uk/collection/P04/current/")

* [Geographic Domain/Features of Interest]("http://vocab.nerc.ac.uk/collection/C19/current/")

TODO: Improve this paragraph
There are numberous ways to investigate which controlled vocabulary to use and this can be fairly overwhelming. For a simplified overview see [here]("http://seadatanet.maris2.nl/v_bodc_vocab_v2/vocab_relations.asp?lib=P08").

Note: To describe a measurement or fact of a biological specimen that conforms to Darwin Core standards, it's neccessary to use the 'Biological entity described elsewhere' method rather than taxon specific.

### Collections

### Oceanography

[Biological and Chemcial Oceanography Data Management Office](http://www.bco-dmo.org/)

[Marine metadata interoperability vocab resources](https://mmisw.org/ont/#/)

### Biology

[BioPortal Ecosystem Ontology](http://bioportal.bioontology.org/ontologies/ECSO)

### NERC Search Interfaces

* [SeaDatanet Common Vocab Search Interface:](http://seadatanet.maris2.nl/v_bodc_vocab_v2/welcome.asp)

* [SeaDataNet Common Vocabularies:](https://www.seadatanet.org/Standards/Common-Vocabularies/)

* [SeaDataNet Vocab Library](http://seadatanet.maris2.nl/v_bodc_vocab_v2/vocab_relations.asp?lib=P08)


### Geosciences

[UDUNITS](https://www.unidata.ucar.edu/software/udunits/)are more common unit measurements in geosciences

### Eco/EnvO

[Environment Ontology]("http://www.obofoundry.org/ontology/envo.html") including genomics.

### Wild Cards

Question: Not sure use case for this. 

[P01 Biological Entity Parameter Code Builder]("https://www.bodc.ac.uk/resources/vocabularies/vocabulary_builder/biomodel/")

## Technologies

### ERDDAP

[ERDDAP]("https://coastwatch.pfeg.noaa.gov/erddap/index.html") can be thought of as a data server. It provides 'easier access to scientific data' by providing a consistent interface that aggregates many disparate data sources. It does this by providing translation services between many common file types for gridded arrarys ('net CDF' files) and tabular data (spreadsheets). Data access is also made easier because it unifies different types of data servers and access protocols. [Here]("https://github.com/HakaiInstitute/erddap-basic") is a basic erddap installation that walks you through how to load a data set.


## Notes on Integrating OBIS, Darwin Core as it relates to OOS's

## Metadata

OBIS uses the [GBIF EML profile](http://rs.gbif.org/schema/eml-gbif-profile/1.1/eml-gbif-profile.xsd) (version 1.1). In case data providers use ISO19115/ISO19139, there is a mapping available here: http://rs.gbif.org/schema/eml-gbif-profile/1.1/eml2iso19139.xsl This will be important for integrating OBIS datasets to OOS metadata profiles.

## Data QC

There are a number of tools available to check the quality of data or check your data format against the expected standard.

[OBIS Datatools](https://obis.org/manual/processing/) shows some great R packages for this.

### Compliance Checking 

LifeWatch Belgium provides a number of tools to check your data against.
Specifically you can test OBIS data format and see a map of your sample locations to check if they are on land.
See http://www.lifewatch.be/data-services/

### Semantic Web and Darwin Core

[Lessons learned from adapting the Darwin Core vocabulary standard for use in RDF]("http://www.semantic-web-journal.net/system/files/swj1093.pdf")

### Resource Description Framework

[Darwin Core Resource Description Framework Guide]("https://dwc.tdwg.org/rdf/")
