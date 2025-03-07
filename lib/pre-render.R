# This script is kicked off by _quarto.yml project: pre-render: lib/pre-render.R

# load libraries
librarian::shelf(
  glue, here, stringr, quiet = T)

# update Github repo contributors image
img_url <- "https://contrib.rocks/image?repo=ioos/bio_data_guide"
img_svg <- "figs/contrib.rocks.svg"
download.file(img_url, img_svg)

# copy dataset-edna/README.md (in git submodule) to README.qmd 
#   while replacing with downloaded Binder svg
doc_md  <- "datasets/dataset-edna/README.md"
doc_qmd <- "datasets/dataset-edna/README.qmd"
img_url <- "https://mybinder.org/badge_logo.svg"
img_svg <- "figs/mybinder.org_badge_logo.svg"
if (!file.exists(img_svg))
  download.file(img_url, img_svg)
readLines(doc_md) |> 
  str_replace(img_url, glue("/{img_svg}")) |>
  writeLines(doc_qmd)

# update bare links {x} (like http:// or https://) in all *.qmd files with angle tags <{x}>, 
#   except if already surrounded by a markdown link, ie [.*]({x}) or <{x}>, or in an R chunk
# The regex pattern (courtesy of claude.ai):
# - `(?<!\\]\\()` - Negative lookbehind to avoid URLs in markdown links
# - `(?<!<)` - Negative lookbehind to avoid URLs already in angle brackets
# - `(https?://[^\\s)]+)` - The URL pattern to capture
# - `(?!>)` - Negative lookahead to avoid URLs already ending with angle brackets
# - `(?![^](?:[^][^])*[^]$)` - Negative lookahead to avoid URLs in inline code (between backticks)
# - `(?![^```]*```[^```]*$)`` - Negative lookahead to avoid URLs in code blocks
pattern <- "(?<!\\]\\()(?<!<)(https?://[^\\s)]+)(?!>)(?![^`]*`(?:[^`]*`[^`]*`)*[^`]*$)(?![^```]*```[^```]*$)"
qmd_files <- list.files(".", pattern = "\\.qmd$", recursive = T, full.names = T)
for (q in qmd_files) {
  readLines(q, warn = FALSE) |> 
    paste(collapse = "\n") |> 
    str_replace_all(
      pattern,
      "<\\1>") |> 
    writeLines(q)
}