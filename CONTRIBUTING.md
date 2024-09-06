# Contribute to the guide


## Contribute text to the chapters

Contribute directly to chapters (eg. intro.qmd). Either through the GitHub website and direct edits to the Quarto markdown files prefixed with chapter numbers (eg. intro.qmd). You can write both markdown or R, and even python code. The site is built using the R package [Quarto](https://quarto.org/) through GitHub Actions, so all you need to do is edit the Quarto markdown file, following the [markdown formatting](https://quarto.org/docs/get-started/hello/vscode.html#basic-workflow), and GitHub will take care of the rest.

If you are a member of the IOOS GitHub biodata team you can edit the files directly on GitHub, or through a fork and then pull-request if you're an external  collaborator. Once the pull-request is approved and merged, the documentation site will update to reflect your changes (takes about 5 minutes for the site to update after PR is merged).

:bangbang: Don't forget to add your name and orcid to the [citation file](https://github.com/ioos/bio_data_guide/blob/main/CITATION.cff)!

Here's a few high level key points worth pointing out about the migration from Rbookdown to Quarto: https://github.com/MathewBiddle/bio_data_guide/pull/7#issuecomment-2334215815

## Contribute example applications

Document your example application in an R markdown (`.qmd`) or markdown (`.md`) file in the appropriate directory under `datasets/`. Submit a [ticket](https://github.com/ioos/bio_data_guide/issues/new/choose) or update [_quarto.yml](https://github.com/ioos/bio_data_guide/blob/73c03872c85b106a28b8d95cef93b150695e8004/_quarto.yml#L29) with a pointer to your application example file.  

*Note:* The largest header in your markdown file should be a second level header (ie. `##`). This is a requirement for how the book gets built, the largest header (`#`) are the chapter identifiers.

## Issues

Most issues have tags. Look for specific ones where you can help, or post a new issue!

### Tags

**Questions**

The easiest way to help out is to answer questions tagged in Issues. You won’t know the answer to everything, but that’s ok! Even just the acknowledgement that someone cares enough to try can be tremendously encouraging.

**Help wanted**

Issues tagged with `Help Wanted...` is where we show issues we need help with!

**Good First Issue**

A great issues to start with if you've never worked on GitHub issues like this before!



