#' Plot a scatter plot on a violin plot with two variables.
#'
#' There are three types of `plot_dot_` functions that plot "dots" as data symbols plotted with \code{\link[ggplot2]{geom_dotplot}} geometry. Variants can show summary and data distributions as bar and SD errors (\link{plot_dotbar_sd}), box and whisker plots (\link{plot_dotbox}) or violin and box & whiskers plots (\link{plot_dotviolin}). They all take a data table, a categorical X variable and a numeric Y variable. 
#' 
#' Related `plot_scatter` variants show data symbols using the \code{\link[ggplot2]{geom_point}} geometry. These are \link{plot_scatterbar_sd}, \link{plot_scatterbox} and \link{plot_scatterviolin}. Overplotting in `plot_scatter` variants can be reduced with the `jitter` argument.
#' 
#' The X variable is mapped to the \code{fill} aesthetic of dots, symbols, bars, boxes and violins.
#' 
#' Colours can be changed using `ColPal`, `ColRev` or `ColSeq` arguments. Colours available can be seen quickly with \code{\link{plot_grafify_palette}}. 
#' `ColPal` can be one of the following: "okabe_ito", "dark", "light", "bright", "pale", "vibrant,  "muted" or "contrast".
#' `ColRev` (logical TRUE/FALSE) decides whether colours are chosen from first-to-last or last-to-first from within the chosen palette. 
#' `ColSeq` decides whether colours are picked by respecting the order in the palette or the most distant ones using \code{\link[grDevices]{colorRampPalette}}.
#' 
#' If you prefer a single colour for the graph, use the `SingleColour` argument.
#'
#' @param data a data table object, e.g. data.frame or tibble.
#' @param xcol name of the column to plot on X axis. This should be a categorical variable.
#' @param ycol name of the column to plot on quantitative Y axis. This should be a quantitative variable.
#' @param facet add another variable from the data table to create faceted graphs using \code{ggplot2}[facet_wrap].
#' @param symsize size of dots relative to \code{binwidth} used by \code{geom_point}. Default set to 3.
#' @param s_alpha fractional opacity of symbols, default set to to 0.8 (i.e, 80% opacity). Set `s_alpha = 0` to not show scatter plot.
#' @param b_alpha fractional opacity of boxplots.  Default is set to 0, which results in white boxes inside violins. Change to any value >0 up to 1 for different levels of transparency.
#' @param v_alpha fractional opacity of violins, default set to 1.
#' @param bwid width of boxplots; default 0.3.
#' @param vadjust number to adjust the smooth/wigglyness of violin plot (default set to 1).
#' @param jitter extent of jitter (scatter) of symbols, default is 0 (i.e. aligned symbols). To reduce symbol overlap, try 0.1-0.3 or higher.  
#' @param trim set whether tips of violin plot should be trimmed at high/low data. Default \code{trim = T}, can be changed to F.
#' @param scale set to "area" by default, can be changed to "count" or "width".
#' @param TextXAngle orientation of text on X-axis; default 0 degrees. Change to 45 or 90 to remove overlapping text.
#' @param LogYTrans transform Y axis into "log10" or "log2"
#' @param LogYBreaks argument for \code{ggplot2[scale_y_continuous]} for Y axis breaks on log scales, default is `waiver()`, or provide a vector of desired breaks.
#' @param Ylabels argument for \code{ggplot2[scale_y_continuous]} for Y axis labels on log scales, default is `waiver()`, or provide a vector of desired labels. 
#' @param LogYLimits a vector of length two specifying the range (minimum and maximum) of the Y axis.
#' @param facet_scales whether or not to fix scales on X & Y axes for all graphs. Can be `fixed` (default), `free`, `free_y` or `free_x` (for Y and X axis one at a time, respectively).
#' @param fontsize parameter of \code{base_size} of fonts in \code{theme_classic}, default set to size 20.
#' @param symthick size (in 'pt' units) of outline of symbol lines (\code{stroke}), default = `fontsize`/22.
#' @param bvthick thickness (in 'pt' units) of both violin and boxplot lines; default = `fontsize`/22.
#' @param ColPal grafify colour palette to apply, default "okabe_ito"; see \code{\link{graf_palettes}} for available palettes.
#' @param ColRev whether to reverse order of colour within the selected palette, default F (FALSE); can be set to T (TRUE).
#' @param ColSeq logical TRUE or FALSE. Default TRUE for sequential colours from chosen palette. Set to FALSE for distant colours, which will be applied using  \code{scale_fill_grafify2}.
#' @param SingleColour a colour hexcode (starting with #), a number between 1-154, or names of colours from `grafify` colour palettes to fill along X-axis aesthetic. Accepts any colour other than "black"; use `grey_lin11`, which is almost black.
#' @param ... any additional arguments to pass to \code{ggplot2}[geom_boxplot], \code{ggplot2}[geom_point] or \code{ggplot2}[geom_violin].
#'
#' @return This function returns a \code{ggplot2} object of class "gg" and "ggplot".
#' @export plot_scatterviolin
#' @import ggplot2
#'
#' @examples
#'
#' #plot without jitter
#' plot_scatterviolin(data = data_t_pdiff, 
#' xcol = Condition, ycol = Mass, 
#' symsize = 2, trim = FALSE)
#' 
#' #no symbols
#' plot_scatterviolin(data = data_t_pdiff, 
#' xcol = Condition, ycol = Mass, 
#' s_alpha = 0,
#' symsize = 2, trim = FALSE)
#'
#' #single colour along X
#' plot_scatterviolin(data = data_t_pdiff, 
#' xcol = Condition, ycol = Mass, 
#' SingleColour = "pale_blue",
#' s_alpha = 0,
#' symsize = 2, trim = FALSE)


plot_scatterviolin <- function(data, xcol, ycol, facet, symsize = 3,  s_alpha = 0.8, b_alpha = 0, v_alpha = 1, bwid = 0.3, vadjust = 1, jitter = 0.1, trim = TRUE, scale = "width", TextXAngle = 0, LogYTrans, LogYBreaks = waiver(), Ylabels = waiver(), LogYLimits = NULL, facet_scales = "fixed", fontsize = 20, symthick, bvthick, ColPal = c("okabe_ito", "all_grafify", "bright",  "contrast",  "dark",  "fishy",  "kelly",  "light",  "muted",  "pale",  "r4",  "safe",  "vibrant"), ColSeq = TRUE, ColRev = FALSE, SingleColour = "NULL", ...){
  ColPal <- match.arg(ColPal)
  if (missing(bvthick)) {bvthick = fontsize/22}
  if (missing(symthick)) {symthick = fontsize/22}
  if (missing(SingleColour)) {
    if (b_alpha == 0){
      suppressWarnings(P <- ggplot2::ggplot(data, aes(x = factor({{ xcol }}),
                                                      y = {{ ycol }}))+
                         geom_violin(aes(fill = factor({{ xcol }})),
                                     alpha = v_alpha,
                                     trim = trim,
                                     scale = scale,
                                     colour = "black", 
                                     size = bvthick,
                                     adjust = vadjust,
                                     ...)+
                         geom_boxplot(fill = "white",
                                      colour = "black", 
                                      size = bvthick,
                                      outlier.alpha = 0,
                                      width = bwid,
                                      ...)+
                         geom_point(shape = 21,
                                    position = position_jitter(width = jitter),
                                    alpha = s_alpha,
                                    stroke = symthick,
                                    size = symsize,
                                    aes(fill = factor({{ xcol }})),
                                    ...)+
                         labs(x = enquo(xcol),
                              fill = enquo(xcol)))
    } else {
      suppressWarnings(P <- ggplot2::ggplot(data, aes(x = factor({{ xcol }}),
                                                      y = {{ ycol }}))+
                         geom_violin(aes(fill = factor({{ xcol }})),
                                     alpha = v_alpha,
                                     trim = trim,
                                     scale = scale,
                                     colour = "black", 
                                     size = bvthick,
                                     adjust = vadjust,
                                     ...)+
                         geom_boxplot(aes(fill = factor({{ xcol }})),
                                      alpha = b_alpha,
                                      colour = "black", 
                                      size = bvthick,
                                      outlier.alpha = 0,
                                      width = bwid,
                                      ...)+
                         geom_point(shape = 21,
                                    position = position_jitter(width = jitter),
                                    alpha = s_alpha,
                                    stroke = symthick,
                                    size = symsize,
                                    aes(fill = factor({{ xcol }})),
                                    ...)+
                         labs(x = enquo(xcol),
                              fill = enquo(xcol)))
    }
  } else {
    ifelse(grepl("#", SingleColour), 
           a <- SingleColour,
           a <- get_graf_colours(SingleColour))
    if (b_alpha == 0){
      suppressWarnings(P <- ggplot2::ggplot(data, aes(x = factor({{ xcol }}),
                                                      y = {{ ycol }}))+
                         geom_violin(fill = a,
                                     alpha = v_alpha,
                                     trim = trim,
                                     scale = scale,
                                     colour = "black", 
                                     size = bvthick,
                                     adjust = vadjust,
                                     ...)+
                         geom_boxplot(fill = "white",
                                      colour = "black", 
                                      size = bvthick,
                                      outlier.alpha = 0,
                                      width = bwid,
                                      ...)+
                         geom_point(shape = 21,
                                    position = position_jitter(width = jitter),
                                    alpha = s_alpha,
                                    stroke = symthick,
                                    size = symsize,
                                    fill = a,
                                    ...)+
                         labs(x = enquo(xcol)))
    } else {
      suppressWarnings(P <- ggplot2::ggplot(data, aes(x = factor({{ xcol }}),
                                                      y = {{ ycol }}))+
                         geom_violin(fill = a,
                                     alpha = v_alpha,
                                     trim = trim,
                                     scale = scale,
                                     colour = "black", 
                                     size = bvthick,
                                     adjust = vadjust,
                                     ...)+
                         geom_boxplot(fill = a,
                                      alpha = b_alpha,
                                      colour = "black", 
                                      size = bvthick,
                                      outlier.alpha = 0,
                                      width = bwid,
                                      ...)+
                         geom_point(shape = 21,
                                    position = position_jitter(width = jitter),
                                    alpha = s_alpha,
                                    stroke = symthick,
                                    size = symsize,
                                    fill = a,
                                    ...)+
                         labs(x = enquo(xcol)))
    }
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
                           labels = Ylabels, 
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
                           labels = Ylabels, 
                           limits = LogYLimits, 
                           ...)}
  }
  P <- P +
    theme_classic(base_size = fontsize)+
    theme(strip.background = element_blank())+
    guides(x = guide_axis(angle = TextXAngle))+ 
    scale_fill_grafify(palette = ColPal, 
                       reverse = ColRev, 
                       ColSeq = ColSeq)
  P
}
