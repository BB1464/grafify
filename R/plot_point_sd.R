#' Plot a point as mean with SD error bars using two variables.
#'
#' This function takes a data table, categorical X and numeric Y variables, and plots a point showing the mean with SD error bars. The X variable is mapped to the \code{fill} aesthetic of symbols.
#'
#' The function uses \code{\link[ggplot2]{stat_summary}} with \code{geom = "point"} with \code{size = 3}.
#' Standard deviation (SD) is plotted through \code{\link[ggplot2]{stat_summary}} calculated using \code{mean_sdl} from the \code{ggplot2} package (get help with \code{?mean_sdl}), and 1x SD is plotted (\code{fun.arg = list(mult = 1)}.
#' 
#' Colours can be changed using `ColPal`, `ColRev` or `ColSeq` arguments. Colours available can be seen quickly with \code{\link{plot_grafify_palette}}.
#' `ColPal` can be one of the following: "okabe_ito", "dark", "light", "bright", "pale", "vibrant,  "muted" or "contrast".
#' `ColRev` (logical TRUE/FALSE) decides whether colours are chosen from first-to-last or last-to-first from within the chosen palette. 
#' `ColSeq` (logical TRUE/FALSE) decides whether colours are picked by respecting the order in the palette or the most distant ones using \code{\link[grDevices]{colorRampPalette}}.
#' 
#' If there are many groups along the X axis and you prefer a single colour for the graph,use the `SingleColour` argument.
#' 
#' You are instead encouraged to show all data using the following functions: \code{\link{plot_scatterbar_sd}}, \code{\link{plot_scatterbox}}, \code{\link{plot_dotbox}}, \code{\link{plot_dotbar_sd}}, \code{\link{plot_scatterviolin}} or \code{\link{plot_dotviolin}}.
#'
#' @param data a data table object, e.g. data.frame or tibble.
#' @param xcol name of the column with a categorical X variable.
#' @param ycol name of the column with quantitative Y variable.
#' @param facet add another variable from the data table to create faceted graphs using \code{ggplot2}[facet_wrap].
#' @param symsize size of point symbols, default set to 3.5.
#' @param s_alpha fractional opacity of symbols, default set to 1 (i.e. maximum opacity & zero transparency).
#' @param ewid width of error bars, default set to 0.2.
#' @param TextXAngle orientation of text on X-axis; default 0 degrees. Change to 45 or 90 to remove overlapping text.
#' @param LogYTrans transform Y axis into "log10" or "log2"
#' @param LogYBreaks argument for \code{ggplot2[scale_y_continuous]} for Y axis breaks on log scales, default is `waiver()`, or provide a vector of desired breaks.
#' @param LogYLabels argument for \code{ggplot2[scale_y_continuous]} for Y axis labels on log scales, default is `waiver()`, or provide a vector of desired labels. 
#' @param LogYLimits a vector of length two specifying the range (minimum and maximum) of the Y axis.
#' @param facet_scales whether or not to fix scales on X & Y axes for all facet facet graphs. Can be `fixed` (default), `free`, `free_y` or `free_x` (for Y and X axis one at a time, respectively).
#' @param fontsize parameter of \code{base_size} of fonts in \code{theme_classic}, default set to size 20.
#' @param symthick thickness of symbol border, default set to `fontsize1`/22.
#' @param ethick thickness of error bar lines; default `fontsize`/22.
#' @param ColPal grafify colour palette to apply, default "okabe_ito"; see \code{\link{graf_palettes}} for available palettes.
#' @param ColSeq logical TRUE or FALSE. Default TRUE for sequential colours from chosen palette. Set to FALSE for distant colours, which will be applied using  \code{scale_fill_grafify2}.
#' @param ColRev whether to reverse order of colour within the selected palette, default F (FALSE); can be set to T (TRUE).
#' @param SingleColour a colour hexcode (starting with #), a number between 1-154, or names of colours from `grafify` colour palettes to fill along X-axis aesthetic. Accepts any colour other than "black"; use `grey_lin11`, which is almost black.
#' @param ... any additional arguments to pass to \code{ggplot2}[stat_summary].
#'
#' @return This function returns a \code{ggplot2} object of class "gg" and "ggplot".
#' @export plot_point_sd
#' @import ggplot2 Hmisc
#'
#' @examples
#' #Basic usage
#' plot_point_sd(data = data_doubling_time, 
#' xcol = Student, ycol = Doubling_time)
#'

plot_point_sd <- function(data, xcol, ycol, facet, symsize = 3.5, s_alpha = 1, ewid = 0.2, TextXAngle = 0, LogYTrans, LogYBreaks = waiver(), LogYLabels = waiver(), LogYLimits = NULL, facet_scales = "fixed", fontsize = 20, symthick, ethick, ColPal = c("okabe_ito", "all_grafify", "bright",  "contrast",  "dark",  "fishy",  "kelly",  "light",  "muted",  "pale",  "r4",  "safe",  "vibrant"), ColSeq = TRUE, ColRev = FALSE, SingleColour = "NULL", ...){
  ColPal <- match.arg(ColPal)
  if (missing(ethick)) {ethick = fontsize/22}
  if (missing(symthick)) {symthick = fontsize/22}
  if (missing(SingleColour)) {
    P <- ggplot2::ggplot(data, aes(x = factor({{ xcol }}),
                                   y = {{ ycol }}))+
      stat_summary(geom = "errorbar",
                   fun.data = "mean_sdl", 
                   size = ethick,
                   fun.args = list(mult = 1),
                   width = ewid, ...)+
      stat_summary(geom = "point", 
                   shape = 21,
                   size = symsize, 
                   stroke = symthick,
                   alpha = s_alpha,
                   fun = "mean",
                   aes(fill = factor({{ xcol }})), ...)+
      labs(x = enquo(xcol),
           fill = enquo(xcol))
  } else {
    ifelse(grepl("#", SingleColour), 
           a <- SingleColour,
           a <- get_graf_colours(SingleColour))
    
    P <- ggplot2::ggplot(data, aes(x = factor({{ xcol }}),
                                   y = {{ ycol }}))+
      stat_summary(geom = "errorbar",
                   fun.data = "mean_sdl", 
                   size = ethick,
                   fun.args = list(mult = 1),
                   alpha = s_alpha,
                   width = ewid, ...)+
      stat_summary(geom = "point", shape = 21,
                   size = symsize, 
                   stroke = symthick,
                   fun = "mean",
                   fill = a, ...)+
      labs(x = enquo(xcol))
  }
  if(!missing(facet)) {
    P <- P + facet_wrap(vars({{ facet }}), 
                        scales = facet_scales, 
                        ...)
  }
  if (!missing(LogYTrans)) {
    if (!(LogYTrans %in% c("log2", "log10"))) {
      stop("LogYTrans only allows 'log2' or 'log10' transformation.")
    }
    if (LogYTrans == "log10") {
      P <- P + 
        scale_y_continuous(trans = "log10", 
                           breaks = LogYBreaks, 
                           labels = LogYLabels, 
                           limits = LogYLimits, 
                           ...)+
        annotation_logticks(sides = "l", 
                            outside = TRUE,
                            base = 10,
                            long = unit(0.2, "cm"), 
                            mid = unit(0.1, "cm"),
                            ...)+ 
        coord_cartesian(clip = "off", ...)
    }
    if (LogYTrans == "log2") {
      P <- P + 
        scale_y_continuous(trans = "log2", 
                           breaks = LogYBreaks, 
                           labels = LogYLabels, 
                           limits = LogYLimits, 
                           ...)}
  }
  P <- P+
    theme_classic(base_size = fontsize)+
    theme(strip.background = element_blank())+
    guides(x = guide_axis(angle = TextXAngle))+
    scale_fill_grafify(palette = ColPal, 
                       reverse = ColRev, 
                       ColSeq = ColSeq)
  P
}
