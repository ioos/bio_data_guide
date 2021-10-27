# Contribute to the guide


## Contribute writing, research, examples or ideas

Contribute directly to chapters (01-Intro.Rmd). Either through the GitHub website and direct edits to the R markdown files prefixed with chapter numbers (eg. 01-intro.Rmd). You can write both markdown or R, and even python code. The site is built using the R package [bookdown](https://bookdown.org/) through GitHub Actions, so all you need to do is edit the R markdown file and GitHub will take care of the rest.

If you are a member of the IOOS GitHub biodata team you can edit the files directly on GitHub, or through a fork and then pull-request if you're an external  collaborator. Once the pull-request is approved and merged, the documentation site will update to reflect your changes (takes about 10 minutes for the site to update after PR is merged).

:bangbang: Don't forget to add your name and orcid to the [citation file](https://github.com/ioos/bio_data_guide/blob/main/CITATION.cff)!

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
bookdown::render_book("index.Rmd")
```
* OR, make a PDF of the book:
``` r
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

## Issues

Most issues have tags. Look for specific ones where you can help, or post a new issue!

### Tags

**Questions**

The easiest way to help out is to answer questions tagged in Issues. You won’t know the answer to everything, but that’s ok! Even just the acknowledgement that someone cares enough to try can be tremendously encouraging.

**Help wanted**

Issues tagged with `Help Wanted...` is where we show issues we need help with!

**Good First Issue**

A great issues to start with if you've never worked on GitHub issues like this before!



