# load libraries
librarian::shelf(
  glue, here, rsvg, stringr, quiet = T)

# update Github repo contributors image
img_url <- "https://contrib.rocks/image?repo=ioos/bio_data_guide"
img_svg <- here("figs/contrib.rocks.svg")
img_png <- here("figs/contrib.rocks.png")
download.file(img_url, img_svg)
rsvg_png(img_svg, img_png)

# update dataset-edna/README.md (in git submodule) with downloaded Binder svg
doc_md  <- "datasets/dataset-edna/README.md"
img_url <- "https://mybinder.org/badge_logo.svg"
img_svg <- here("figs/mybinder.org_badge_logo.svg")
img_png <- here("figs/mybinder.org_badge_logo.png")
if (!file.exists(img_png)){
  download.file(img_url, img_svg)
  rsvg_png(img_svg, img_png) }
readLines(doc_md) |> 
  str_replace(img_url, glue("/{img_png}")) |>
  writeLines(doc_md)
