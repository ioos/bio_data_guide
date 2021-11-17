# Darwin Core Guide
:notebook: This repository contains living documentation to help those just getting started with biological data or those looking to learn and contribute to IOOS's best practices for biological data.

## :question: Have Questions? :question:
* See the "issues" tab above to ask questions or discuss with the IOOS biodata community.
* Also try searching for related issues which are open or have been closed (ie answered)

## Got Data?
* :speech_balloon: open an issue in the issues tab above
* :floppy_disk: small datasets can be uploaded into `./datasets/` and we can help you align with best practices
* :link: dataset repositories or other hosted data can be included in the links in the `Datasets` section below

# Standardizing Marine Biological Data Guide

See the guide [here](https://ioos.github.io/bio_data_guide/intro.html)

We are documenting, in the form of a :notebook: Guide, relevant resources and standards which apply to various marine biological data sets. This is a work in progress, a growing guide that is being put together by scientists and data managers responsible for transforming their data to meet international standards. The Guide is exported into multiple formats, including a [pdf](https://github.com/ioos/bio_data_guide/raw/gh-pages/bio-data-guide.pdf) and an [epub](https://github.com/ioos/bio_data_guide/raw/gh-pages/bio-data-guide.epub) document. Chapters are written in R Markdown files; [contributions are welcome!](https://github.com/ioos/bio_data_guide/blob/main/CONTRIBUTING.md)

## Building the book on your local machine (_optional_)

### To build the book using Rstudio: 

* Make sure you have the most recent version of R and R Studio
  * Check that [pandoc](https://pandoc.org/installing.html) is installed and functioning on your machine (`library(rmarkdown); pandoc_available()` should return `TRUE`)
* Start a new project in R Studio using version control
* Fork or clone the GitHub repository from this url: https://github.com/ioos/bio_data_guide.git
* Install all the required packages: specifically `bookdown` and others as required
* In the Build tab, click 'Build Book' or in the console run `rmarkdown::render_site(encoding = 'UTF-8')`
* Commit and push changes to all modified files using the git pane in R Studio

### To build the book using R Console:
* Make sure you have the most recent version of R
* Check that [pandoc](https://pandoc.org/installing.html) is installed and functioning on your machine (`library(rmarkdown); pandoc_available()` should return `TRUE`) 
* Fork or clone the GitHub repository from this url: https://github.com/ioos/bio_data_guide.git
* Install the [required packages](https://github.com/ioos/bio_data_guide/blob/e5ce8894dc5d00729ff3c0df754d282ba4681119/.github/workflows/deploy_bookdown.yml#L26-L31):
``` r
install.packages(c("librarian", "rgdal", "rmarkdown", "vroom", "xfun", "tinytex"), type = "binary");
librarian::shelf(bookdown, dm, here, lubridate, , rmarkdown, tidyverse, worms);
remotes::install_github("iobis/obistools", upgrade="never");
tinytex::install_tinytex()
```
* To build the book:
``` r
setwd("bio-data-guide/")
options(knitr.duplicate.label = "allow")
bookdown::render_book("index.Rmd")
```
* OR, make a PDF of the book:
``` r
options(knitr.duplicate.label = "allow")
bookdown::render_book("index.Rmd", "bookdown::pdf_book")
```
* The markdown and pdf will be saved in the local `bio-data-guide/docs` directory.
  * Reminder: `bio-data-guide/docs` is [ignored by git](https://github.com/ioos/bio_data_guide/blob/main/.gitignore).
          
## Building and publishing the book through GitHub on your fork

* Create a fork of this repo under your ownership
* create an empty `gh-pages` branch in your fork (see [here](https://jiafulow.github.io/blog/2020/07/09/create-gh-pages-branch-in-existing-repo/)).
* Host [GitHub Pages](https://pages.github.com/)
  * In your GitHub repository, go to Settings -> Pages
  * Select the `gh-pages` branch and the `/(root)` directory.
  * Select **Save**
* You need to make a change (any change) to the repository to initiate the GitHub Action to
  build the website in the `gh-pages` branch.
  * Make a minor edit to one of the markdown files in `bio-data-guide`.
  * When you commit the change the GitHub action will build the webpage.
  * Once the GitHub action finishes, you should be able to view the document at
  `[username].github.io/bio_data_guide`
    * `[username]` is your GitHub username.

# Resources & Links
* Training & workshop documents
    * [2018 IOOS BioData Training in Seattle](https://ioos.github.io/BioData-Training-Workshop)
    * [2019 IOOS Code Sprint in Ann Arbor](https://github.com/marinebon/bio_data_scripts_ioos_workshop_2019)
* [marinebon.org](https://marinebon.org/)
* [more links from IOOS Code Sprint discussions(gdoc)](https://docs.google.com/document/d/1MWLYBMG5apFwUYuD9ZaKFNCkqT7i3NBjgwK7bGdtEd8/edit#bookmark=id.v03uousdt0h6)

## Monthly Meetings
We have open monthly meetings to discuss marine bio data issues. Please join us next time!

* [Link to meeting minutes](https://docs.google.com/document/d/1JfXHFXhP0rB8juAK3-KvOtqtwDofPwewoAB_ZyFwSwY/edit?usp=sharing)
* [Link to call participation details](https://docs.google.com/document/d/1JfXHFXhP0rB8juAK3-KvOtqtwDofPwewoAB_ZyFwSwY/edit#bookmark=id.1ksv4uv)


# Datasets
The `./datasets/` directory in this repository contains small datasets which meet one of the following criteria:
* :construction_worker: the community is currently aligning this data
* :notebook: the dataset is retained as an instructive example
* :speak_no_evil: the lazy maintainers of this repo haven't cleaned it out yet 

Ideally each dataset should contain a README.md file with details about the data and the ingestion process for this dataset.
A few datasets are highlighted below as especially instructive examples:

* [example_script_with_fake_data](https://github.com/ioos/bio_data_guide/tree/main/datasets/example_script_with_fake_data) - fake data crafted by Abby Benson to illustrate a very basic conversion to DwC

## Linked datasets
Datasets not included in this directory but still meeting one of the criteria above are linked here:

* [FL MBON Zooplankton](https://github.com/USF-IMARS/zoo-taxonomy-to-darwin-core)

--------------------------------------------------------------------------

# Historical

This repo has grown out of the 2019 IOOS code sprint.
Original documents from the sprint are retained on a fork of this repo in [marinebon/bio_data_scripts_ioos_workshop_2019](https://github.com/marinebon/bio_data_scripts_ioos_workshop_2019).
