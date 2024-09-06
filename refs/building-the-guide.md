# Building the book on your local machine (_optional_)

A Github Action will build the book automatically when you push changes to the repository. However, you can also build the book locally on your machine, which is especially helpful for testing output and debugging any issues.

## Setup software (R, Rstudio, Quarto, TinyTex) and download the repository

* Make sure you have the most recent version of R and R Studio

* Check that [Quarto](https://quarto.org/docs/get-started/) is installed and functioning on your machine. Check the version of Quarto installed in the R **Console**:
  ```r
  quarto::quarto_version()
  ```

* Install [TinyTex](https://yihui.org/tinytex/) (used for rendering to PDF) in the bash **Terminal**:
  ```bash
  quarto install tinytex
  ```

* In R Studio, File > New Project... > Version Control > Git.

* Fork or clone the GitHub repository from this Repository URL: 
  ```
  https://github.com/ioos/bio_data_guide.git
  ```

* Install all the required packages listed in the `DESCRIPTION` from the R **Console**:
  ```r
  remotes::install_deps()
  ```

* Update the git submodule in the repository (i.e., `datasets/dataset-edna` -> [iobis/dataset-edna](https://github.com/iobis/dataset-edna)) from the bash **Terminal**:
  ```bash
  git submodule update --init --recursive
  ```
  
## Render the Quarto book

* Reset the git submodule and create the necessary README.qmd in the bash **Terminal**:
  ```bash
  # copy placeholder file referenced in _quarto.yml, but overwritten by lib/pre-render.R
  cp datasets/dataset-edna/README.md datasets/dataset-edna/README.qmd
  
  # reset git submodule
  cd datasets/dataset-edna/
  git pull
  rm README.qmd 
  git log # check hash for latest
  #git reset --hard e7bb04218420b189e04d651f1653977f3a5d051d
  git reset --hard HEAD # TODO: is this the same as above, but based on latest?
  ```
  
* Render all Quarto output formats (i.e., `html`, `pdf`, `epub`) from source files (\*.qmd) listed in the `_quarto.yaml` (starting with `chapters:`) into the `output-dir` (i.e.,`_book`)  from the bash **Terminal**:
  ```bash
  quarto render
  ```

* If you have any problems, be sure to show versions of quarto and tinytex in the bash **Terminal**:
  ```bash
  quarto check
  ```
  
* Inspect results (`BioDataGuide.pdf`, `index.html`) in the output directory `_book/`.

* Commit and push changes to all modified files via the **Git** pane in R Studio. Note that the `_book` directory is ignored by git (per the `.gitignore` file), since the book is rendered and published by the Github Action (`.github/workflows/render_book.yml`) into the `gh-pages` Github branch.

## Building and publishing the book through GitHub on your fork

* [Fork this repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) at `ioos/bio_data_guide` under your ownership.
* Create an empty `gh-pages` branch in your fork (see [here](https://jiafulow.github.io/blog/2020/07/09/create-gh-pages-branch-in-existing-repo/)).
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

## Adding R package dependencies to `DESCRIPTION`

Depending on the type of R package:

* CRAN
  ```r
  usethis::use_package("dplyr")
  ```
  
* Github (and not CRAN)
  ```r
  usethis::use_dev_package("obistools", remote = "iobis/obistools")
  ```
  
* CRAN meta-package
  ```r
  usethis::use_package("tidyverse", type = "depends")
  ```
