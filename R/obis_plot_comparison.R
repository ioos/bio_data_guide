# function to compare two OBIS occurrence results.

obis_plot_comparison = function(
    occurrence_1,
    occurrence_2
){
  # TODO: make this into one nice plot
  ggplot2::ggplot(occurrence_1) + ggplot2::geom_bar(ggplot2::aes(eventDate), width = 1)
  ggplot2::ggplot(occurrence_2) + ggplot2::geom_bar(ggplot2::aes(eventDate), width = 1)
}
