# BioDataGuide

Hello and welcome to the Darwin Core Marine Example Compendium! (We're calling it the BioDataGuide for short.) Here, we document relevant resources and standards 
which apply to various marine biological data types. This is a growing guide that is put together by scientists and 
data managers responsible for transforming their data to meet international standards.

This guide is meant for  data managers, scientists, or technicians new to transforming/publishing/mobilizing data. 
There is a general introduction to the world of international data integration, followed by some specific examples of 
data transformations.

To contribute to this guide see (CONTRIBUTING.md)[CONTRIBUTING.md]

# Standardizing Marine Biological Data Working Group (SMBD)

## Purpose
The purpose of the SMBD is to facilitate a community of practice for aligning marine biological data to [Darwin Core](https://dwc.tdwg.org/) 
for sharing to [OBIS](https://obis.org/). We do this by empowering our community members - which consist of federal, state, 
local, tribal, and private data managers, scientists, computer programmers, and everything in between - with the tools 
and knowledge to mobilize marine biological data.

## How do we do it?
We host monthly meetings, a Slack space, and this GitHub repository to provide various mechanisms for community members
to participate. 

The primary focus of the working group is to help you get past any blockers you might be experiencing during the 
mobilization process. Below is a list of example blockers we've seen already:

* What does the Darwin Core data model look like?
* What about metadata?
* How do I automatically collect scientific names for my species observations?
* How can I best represent my data in Darwin Core?
* I need help munging my data using R (or Python)!
* How do I deal with dates when I only know the year?

Those and many more questions can be answered through this working group!

## Who can join?
Anyone!

* Do you have *Taxonomic Occurrence data* and want to share it?
* Have you ever wanted to chat about *biological data standards*, *programming*, or *biodiversity*?

👋 If so: **This is the place for you**.

## 📆 How to participate?
We have open monthly meetings every **2nd Wednesday of the month at 16:00 ET** to discuss marine biological data issues. 
Please feel free to join us!

* 👉[**Join us every month** using connection details here!](https://docs.google.com/document/d/1JfXHFXhP0rB8juAK3-KvOtqtwDofPwewoAB_ZyFwSwY/edit#bookmark=id.1ksv4uv)👈
* [Join the standardizing-bke7693.slack.com slack](https://join.slack.com/t/standardizing-bke7693/shared_invite/zt-2rlgfmdlc-ptX4G24eGE9lLo2k~rO58g) and say hi on the `#general` channel.
* Submit an [issue](https://github.com/ioos/bio_data_guide/issues) to this repository.
* [![Join the chat at https://gitter.im/ioos/bio-data](https://badges.gitter.im/ioos/bio-data.svg)](https://gitter.im/ioos/bio-data?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Checkout our current contributors:

<a href="https://github.com/ioos/bio_data_guide/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=ioos/bio_data_guide" />
</a>

Made with [contrib.rocks](https://contrib.rocks).

-----------------------------------------------------------
# About this repository

There are multiple resources in this GitHub repository, including:

* :notebook: Living documentation for anyone working with, learning about, or conributing to IOOS's best practices for biological data.
* 🗄️ Datasets being actively worked on by community members.
* ♻️ Code and documentation used on other datasets that can be re-used.
* 🧰 Tools to help you navigate the organizational, technical, and social challenges of publishing data.


## :question: Have Questions? :question:
* See the "issues" tab above to ask questions or discuss with the IOOS biodata community.
* Also try searching for related issues which are open or have been closed (ie answered).

## Got Data to Share?
* :speech_balloon: open an issue in the issues tab above and tell us about it.
* :floppy_disk: small datasets can be uploaded into `./datasets/` so we can directly help you align with best practices.
* :link: dataset repositories or other hosted data can be included in the links in the `Datasets` section below.

Also, check out [CONTRIBUTING.md](CONTRIBUTING.md)

# Our training & workshops
* [Annual BioData Mobilization Workshop](https://ioos.github.io/bio_mobilization_workshop/)
* [2019 IOOS Code Sprint in Ann Arbor](https://github.com/marinebon/bio_data_scripts_ioos_workshop_2019)
* [2018 IOOS BioData Training in Seattle](https://ioos.github.io/BioData-Training-Workshop)

# Datasets
The `./datasets/` directory in this repository contains small datasets which meet one of the following criteria:
* :construction_worker: the community is currently aligning this data
* :notebook: the dataset is retained as an instructive example
* :speak_no_evil: the lazy maintainers of this repo haven't cleaned it out yet 

Ideally each dataset should contain a README.md file with details about the data and the ingestion process for this dataset.
See more on this in the [contribute example applications](CONTRIBUTING.md#contribute-example-applications) guidance. A few datasets are highlighted below as especially instructive examples:

* [example_script_with_fake_data](https://github.com/ioos/bio_data_guide/tree/main/datasets/example_script_with_fake_data) - fake data crafted by Abby Benson to illustrate a very basic conversion to DwC

------------------------------------------------------

# The Standardizing Marine Bio Data Guide

See the guide [here](https://ioos.github.io/bio_data_guide/intro.html).

We are documenting, in the form of a :notebook: Guide, relevant resources and standards which apply to various marine biological data sets. 
This is a work in progress, a growing guide that is being put together by scientists and data managers responsible for transforming their data to meet international standards. 
The Guide is exported into multiple formats, including a [pdf](https://github.com/ioos/bio_data_guide/raw/gh-pages/darwin-core-guide.pdf) and an [epub](https://github.com/ioos/bio_data_guide/raw/gh-pages/darwin-core-guide.epub) document. 
Chapters are written in R Markdown files; [contributions are welcome!](https://github.com/ioos/bio_data_guide/blob/main/CONTRIBUTING.md)

Technical details of how to work with the book can be found in [`/refs/building-the-data-guide.md`](https://github.com/ioos/bio_data_guide/blob/main/refs/building-the-guide.md).

<!--

--------------------------------------------------------------------------

# Historical

This repo started at the 2019 IOOS code sprint.
Original documents from the sprint are retained on a fork of this repo in [marinebon/bio_data_scripts_ioos_workshop_2019](https://github.com/marinebon/bio_data_scripts_ioos_workshop_2019).


# more links:

* [marinebon.org](https://marinebon.org/)
* [more links from IOOS Code Sprint discussions(gdoc)](https://docs.google.com/document/d/1MWLYBMG5apFwUYuD9ZaKFNCkqT7i3NBjgwK7bGdtEd8/edit#bookmark=id.v03uousdt0h6)

-->
