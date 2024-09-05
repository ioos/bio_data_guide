
## Building the book on your local machine (_optional_)

### To build the book using Rstudio: 

* Update the git submodule(s) in the repository (e.g., `datasets/dataset-edna` -> [iobis/dataset-edna](https://github.com/iobis/dataset-edna))
  ```bash
  git submodule update --init --recursive
  ```
* Make sure you have the most recent version of R and R Studio
  * Check that [pandoc](https://pandoc.org/installing.html) is installed and functioning on your machine 
(`library(rmarkdown); pandoc_available()` should return `TRUE`)
* Start a new project in R Studio using version control
* Fork or clone the GitHub repository from this url: https://github.com/ioos/bio_data_guide.git
* Install all the required packages: specifically `bookdown` and others as required
* In the Build tab, click 'Build Book' or in the console run `rmarkdown::render_site(encoding = 'UTF-8')`
* Commit and push changes to all modified files using the git pane in R Studio

### To build the book using R Console:
* Make sure you have the most recent version of R
* Check that [pandoc](https://pandoc.org/installing.html) is installed and functioning on your machine 
(`library(rmarkdown); pandoc_available()` should return `TRUE`) 
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
