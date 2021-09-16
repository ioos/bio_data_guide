# Contribute to the guide


## Contribute writiing, research, examples or ideas

Contribute directly to chapters (01-Intro.Rmd). Either through the GitHub website and direct edits to the R markdown files prefixed with chapter numbers (eg. 01-intro.Rmd). You can write both markdown or R, and even python code. The site is built using the R package [bookdown](https://bookdown.org/) through GitHub Actions, so all you need to do is edit the R markdown file and GitHub will take care of the rest.

If you are a member of the IOOS GitHub org you can edit the files directly on GitHub, or through a fork and then pull-request if you're an external  collaborator. Once the pull-request is approved and merged, the documentation site will update to reflect your changes.

## Building the book on your local machine (_optional_)

To build the book: 

* Make sure you have the most recent version of R and R Studio
* Start a new project in R Studio using version control
* Fork or clone the github repository from this urL: https://github.com/ioos/bio_data_guide.git
* Install all the requried packages: specifically `bookdown` and others as required
* In the Build tab, click 'Build Book' or in the console run `rmarkdown::render_site(encoding = 'UTF-8')`
* Commit and push chagnes to all modified files using the git pane in R Studio

## Building and publishing the book on your fork

* Create a fork of this repo under your ownership
* create an empty `gh-pages` branch in your fork (see [here](https://jiafulow.github.io/blog/2020/07/09/create-gh-pages-branch-in-existing-repo/)).
* In your github repository, go to Settings -> Pages
* Select the `gh-pages` branch and the `/(root)` directory.
* Once the GitHub action finishes, you should be able to view the document at
  `[username].github.io/bio_data_guide`
  * `[username]` is your GitHub user name.

## Issues

Most issues have tags. Look for specific ones where you can help, or post a new issue!

### Tags

**Quesitons**

The easiest way to help out is to answer questions tagged in Issues. You won’t know the answer to everything, but that’s ok! Even just the acknowledgement that someone cares enough to try can be tremendously encouraging.

**Help wanted**

Issues tagged with Help Wanted... is where we show issues we need help with!

**Good First Issue**

A great issues to start with if you've never worked on GitHub issues like this before!



