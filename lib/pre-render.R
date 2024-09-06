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
