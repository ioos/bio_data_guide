# load libraries
librarian::shelf(
  glue, stringr, quiet = T)

# update Github repo contributors image
download.file(
  "https://contrib.rocks/image?repo=ioos/bio_data_guide",
  "figs/contrib.rocks.svg")

# update dataset-edna/README.md with downloaded Binder svg
file_md <- "datasets/dataset-edna/README.md"
url_svg <- "https://mybinder.org/badge_logo.svg"
fig_svg <- "figs/mybinder.org_badge_logo.svg"
if (!file.exists(fig_svg))
  download.file(url_svg, fig_svg)
readLines() |> 
  str_replace(url_svg, glue("/{fig_svg}")) |>
  writeLines("datasets/dataset-edna/README.qmd")
