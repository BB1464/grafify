#' Plot a dot plot with matched shapes on a violin & box plot using four variables.
#'
#' The functions \code{\link{plot_3d_scatterbar}}, \code{\link{plot_3d_scatterbox}}, \code{\link{plot_3d_scatterviolin}}, \code{\link{plot_4d_scatterbar}}, \code{\link{plot_4d_scatterbox}}  and \code{\link{plot_4d_scatterviolin}} are useful for plotting one-way or two-way ANOVA designs with randomised blocks or repeated measures. The blocks or subjects can be mapped to the `shapes` argument in both functions (up to 25 levels can be mapped to `shapes`; there will be an error if this number is exceeded). The 3d versions use the categorical variable (`xcol`) for grouping (e.g. one-way ANOVA designs), and 4d versions take an additional grouping variable (e.g. two-way ANOVA designs) that is passed to either `boxes` or `bars` argument.
#' 
#' These functions rely on \code{\link[ggplot2]{ggplot}} with \code{\link[ggplot2]{geom_point}} and \code{\link[ggplot2]{geom_bar}} (through \code{stat_summary}), or  \code{\link[ggplot2]{geom_violin}}  and  \code{\link[ggplot2]{geom_boxplot}} geometries.
#'
#' Variables other than the quantitative variable (`ycol`) will be automatically converted to categorical variables even if they are numeric in the data table.
#' 
#' Shapes are always plotted in black colour, and their opacity can be changed with the `s_alpha` argument and overlap can be reduced with the `jitter` argument. Other arguments are similar to other plot functions as briefly explained below.
#'
#' Bars depict means using \code{\link[ggplot2]{stat_summary}} with \code{geom = "bar", fun = "mean"} , and bar width is set to 0.7 (cannot be changed). Error bar width can be changed with the `ewid` argument.
#' 
#' Boxplot geometry uses \code{\link[ggplot2]{geom_boxplot}} with \code{position = position_dodge(width = 0.9), width = 0.6}. The thick line within the boxplot depicts the median, the box the IQR (interquantile range) and the whiskers show 1.5*IQR.
#' 
#' In 4d versions, the two grouping variables (i.e. `xcol` and either `boxes` or `bars`) are passed to ggplot aesthetics through \code{group = interaction{ xcol, shapes}}. 
#'  
#' Colours can be changed using `ColPal`, `ColRev` or `ColSeq` arguments. 
#' `ColPal` can be one of the following: "okabe_ito", "dark", "light", "bright", "pale", "vibrant,  "muted" or "contrast".
#' `ColRev` (logical TRUE/FALSE) decides whether colours are chosen from first-to-last or last-to-first from within the chosen palette. 
#' `ColSeq` (logical TRUE/FALSE) decides whether colours are picked by respecting the order in the palette or the most distant ones using \code{\link[grDevices]{colorRampPalette}}.
#' 
#' All four functions can be expanded further, for example with \code{\link[ggplot2]{facet_grid}} or \code{\link[ggplot2]{facet_wrap}}.
#'
#' @param data a data table, e.g. data.frame or tibble.
#' @param xcol name of the column with the categorical factor to plot on X axis. If column is numeric, enter as \code{factor(col)}.
#' @param ycol name of the column to plot on quantitative variable on the Y axis.
#' @param boxes name of the column containing grouping within the factor plotted on X axis. Can be categorical or numeric X. If your table has numeric X and you want to plot as factor, enter \code{xcol = factor(name of colum)}.
#' @param shapes name of the column that contains matched observations, e.g. subject IDs, experiment number etc.
#' @param facet add another variable from the data table to create faceted graphs using \code{ggplot2}[facet_wrap].
#' @param symsize size of symbols, default set to 3.
#' @param s_alpha fractional opacity of symbols, default set to 0.8 (i.e. 80% opacity). Set `s_alpha = 0` to not show scatter plot.
#' @param b_alpha fractional opacity of boxes.  Default is set to 0, which results in white boxes inside violins. Change to any value >0 up to 1 for different levels of transparency. 
#' @param v_alpha fractional opacity of violins, default set to 1.
#' @param bwid width of boxes; default 0.3.
#' @param vadjust number to adjust the smooth/wigglyness of violin plot (default set to 1).
#' @param jitter extent of jitter (scatter) of symbols, default is 0.1. Increase to reduce symbol overlap, set to 0 for aligned symbols.  
#' @param TextXAngle orientation of text on X-axis; default 0 degrees. Change to 45 or 90 to remove overlapping text.
#' @param scale set to "area" by default, can be changed to "count" or "width".
#' @param trim set whether tips of violin plot should be trimmed at high/low data. Default \code{trim = T}, can be changed to F.
#' @param LogYTrans transform Y axis into "log10" or "log2"
#' @param LogYBreaks argument for \code{ggplot2[scale_y_continuous]} for Y axis breaks on log scales, default is `waiver()`, or provide a vector of desired breaks.
#' @param LogYLabels argument for \code{ggplot2[scale_y_continuous]} for Y axis labels on log scales, default is `waiver()`, or provide a vector of desired labels. 
#' @param LogYLimits a vector of length two specifying the range (minimum and maximum) of the Y axis.
#' @param facet_scales whether or not to fix scales on X & Y axes for all facet facet graphs. Can be `fixed` (default), `free`, `free_y` or `free_x` (for Y and X axis one at a time, respectively).
#' @param fontsize parameter of \code{base_size} of fonts in \code{theme_classic}, default set to size 20.
#' @param symthick size (in 'pt' units) of outline of symbol lines (\code{stroke}), default = `fontsize`/22.
#' @param bvthick thickness (in 'pt' units) of both violin and boxplot lines; default = `fontsize`/22.
#' @param ColPal grafify colour palette to apply, default "okabe_ito"; see \code{\link{graf_palettes}} for available palettes.
#' @param ColRev whether to reverse order of colour within the selected palette, default F (FALSE); can be set to T (TRUE).
#' @param ColSeq logical TRUE or FALSE. Default TRUE for sequential colours from chosen palette. Set to FALSE for distant colours, which will be applied using  \code{scale_fill_grafify2}.
#' @param ... any additional arguments to pass to \code{ggplot2}[geom_boxplot] or \code{ggplot2}[geom_violin].
#'
#' @return This function returns a \code{ggplot2} object of class "gg" and "ggplot".
#' @export plot_4d_scatterviolin
#' @import ggplot2
#'
#' @examples
#' #3d version for 1-way data with blocking
#' plot_3d_scatterviolin(data = data_1w_death, 
#' xcol = Genotype, ycol = Death, shapes = Experiment)
#' #compare above graph to
#' plot_scatterviolin(data = data_1w_death, 
#' xcol = Genotype, ycol = Death)
#' 
#' #4d version for 2-way data with blocking
#' plot_4d_scatterviolin(data = data_2w_Tdeath, 
#' xcol = Genotype, 
#' ycol = PI, 
#' boxes = Time, 
#' shapes = Experiment)
#' 
plot_4d_scatterviolin <- function(data, xcol, ycol, boxes, shapes, facet, symsize = 3, s_alpha = 0.8, v_alpha = 1, b_alpha = 0, bwid = 0.3, vadjust = 1, jitter = 0.1, TextXAngle = 0, scale = "width", trim = TRUE, LogYTrans, LogYBreaks = waiver(), LogYLabels = waiver(), LogYLimits = NULL, facet_scales = "fixed", fontsize = 20, symthick, bvthick, ColPal = c("okabe_ito", "all_grafify", "bright",  "contrast",  "dark",  "fishy",  "kelly",  "light",  "muted",  "pale",  "r4",  "safe",  "vibrant"), ColSeq = TRUE, ColRev = FALSE, ...){
  ColPal <- match.arg(ColPal)
  if (missing(bvthick)) {bvthick = fontsize/22}
  if (missing(symthick)) {symthick = fontsize/22}
  if (b_alpha == 0){
    P <- ggplot2::ggplot(data, aes(x = factor({{ xcol }}),
                                   y = {{ ycol }},
                                   group = interaction(factor({{ boxes }}),
                                                       factor({{ xcol }}))))+
      geom_violin(scale = scale, 
                  alpha = v_alpha, 
                  size = bvthick,
                  colour = "black",
                  trim = trim,
                  aes(fill = factor({{ boxes }})), 
                  adjust = vadjust,
                  position = position_dodge(width = 0.8),
                  ...)+
      geom_boxplot(width = bwid,
                   fill = "white",
                   size = bvthick,
                   aes(fill = factor({{ boxes }})),
                   outlier.alpha = 0,
                   position = position_dodge(width = 0.8),
                   ...)+
      geom_point(size = symsize, 
                 alpha = s_alpha, 
                 stroke = symthick, 
                 colour = "black",
                 position = position_jitterdodge(jitter.width = jitter,
                                                 dodge.width = 0.8),
                 aes(shape = factor({{ shapes }})))+
      scale_shape_manual(values = 0:25)+
      labs(fill = enquo(boxes),
           x = enquo(xcol),
           shape = enquo(shapes))
  } else {
    P <- ggplot2::ggplot(data, aes(x = factor({{ xcol }}),
                                   y = {{ ycol }},
                                   group = interaction(factor({{ boxes }}),
                                                       factor({{ xcol }}))))+
      geom_violin(scale = scale, 
                  alpha = v_alpha, 
                  size = bvthick,
                  colour = "black",
                  trim = trim,
                  aes(fill = factor({{ boxes }})), 
                  adjust = vadjust,
                  position = position_dodge(width = 0.8),
                  ...)+
      geom_boxplot(width = bwid, 
                   alpha = b_alpha, 
                   size = bvthick,
                   aes(fill = factor({{ boxes }})), 
                   outlier.alpha = 0,
                   position = position_dodge(width = 0.8),
                   ...)+
      geom_point(size = symsize, 
                 alpha = s_alpha, 
                 stroke = symthick, 
                 colour = "black",
                 position = position_jitterdodge(jitter.width = jitter,
                                                 dodge.width = 0.8),
                 aes(shape = factor({{ shapes }})))+
      scale_shape_manual(values = 0:25)+
      labs(fill = enquo(boxes),
           x = enquo(xcol),
           shape = enquo(shapes))
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
  P <- P +
    theme_classic(base_size = fontsize)+
    theme(strip.background = element_blank())+
    guides(x = guide_axis(angle = TextXAngle),
           fill = guide_legend(order = 1),
           shape = guide_legend(order = 2))+
    scale_fill_grafify(palette = ColPal, 
                       reverse = ColRev, 
                       ColSeq = ColSeq)
  P
}
